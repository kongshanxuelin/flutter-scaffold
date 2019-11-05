library sumslack;

import 'dart:convert';
import 'package:convert/convert.dart';
import 'dart:math';
import 'NetUtils.dart';
import 'dart:collection';
import 'package:crypto/crypto.dart' as crypto;

var _API_BASE_URL = "http://wstest.idbhost.com/finIndex";
var _APPID = "894344910875";
var _APPSEC = "9ee3b6066bb55ac7aee3476dec29afbb";

init(appId,appSec){
  _APPID = appId;
  _APPSEC = appSec;
}

get(url,[Map<String, dynamic> params]) async{
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

  print("==================paramStr:" + (_API_BASE_URL + url) + "=>" + params.toString());
  var res = await NetUtils.get( _API_BASE_URL + url,params);
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