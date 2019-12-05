library sumslack;

import 'dart:convert';
import 'package:convert/convert.dart';
import 'dart:math';
import 'NetUtils.dart';
import '../config.dart' as C;
import 'dart:collection';
import 'package:crypto/crypto.dart' as crypto;

var _API_BASE_URL = C.Config.url_gateway;
var _APPID = C.Config.appId;
var _APPSEC = C.Config.appSec;

init(appId,appSec){
  _APPID = appId;
  _APPSEC = appSec;
}
auth(String username,String pass,{String authType="jwt"}) async{
  String url = C.Config.url_auth + "/auth/jwt/login";
  var login = await _request(url,params:{
    "username":username,
    "password":pass
  });
  if(login["status"]==0){
    NetUtils.setHeader("Authorization", "Bearer " + login["data"].toString());
    NetUtils.setHeader("AuthorizationType", authType);
  }else{
    NetUtils.removeHeader("Authorization");
    NetUtils.removeHeader("AuthorizationType");
  }
  return login;
}
get(url,Map<String, dynamic> p) async{
  return _request(_API_BASE_URL + url,method:"GET",params:p);
}
post(url,Map<String, dynamic> p) async{
  return _request(_API_BASE_URL + url,method:"POST",params:p);
}
delete(url,Map<String, dynamic> p) async{
  return _request(_API_BASE_URL + url,method:"DELETE",params:p);
}
_request(url,{String method:"GET",Map<String, dynamic> params}) async{
  int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  var randStr = 'abcdefghijklmnopqrstuvwxyz0123456789';
  var _nonceStr = _nonce(16);
  params['app_id'] = _APPID;
  params['nonce_str'] = _nonceStr;
  params['time_stamp'] = timestamp.toString();

  Map<String, dynamic> treeMap = new SplayTreeMap<String, dynamic>.from(params);
  var _params = '';
  treeMap.forEach((k,v){
    _params += '&' + k + '=' + v;
  });
  _params = _params.substring(1);
  _params += "&app_key=" + _APPSEC;

  //获取签名
  String _sign = _generateMd5(_params);
  params['sign'] = _sign;

  print("==================paramStr:" + url + "=>" + params.toString());
  dynamic res;
  if(method == "POST"){
    res = await NetUtils.post( url,params);
  }else if(method == "DELETE"){
    res = await NetUtils.delete( url,params);
  }else{
    res = await NetUtils.get( url,params);
  }
  print("++++++retun res:"+res.toString());
  return res;
}

String _nonce(num len){
  var alphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';
  String left = '';
  for (var i = 0; i < len; i++) {
    left = left + alphabet[Random().nextInt(alphabet.length)];
  }
  return left;
}
String _generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var md5 = crypto.md5;
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}