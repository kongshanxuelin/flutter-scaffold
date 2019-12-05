import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../config.dart' as C;

Map<String, dynamic> optHeader = {
  'accept-language': 'zh-cn',
  'content-type': 'application/json',
  'ss-agent': 'ss-flutter'
};

var dio = new Dio(BaseOptions(connectTimeout: 30000, headers: optHeader));

class NetUtils {
  static void setHeader(String name,String v){
    optHeader[name] = v;
    dio = new Dio(BaseOptions(connectTimeout: 30000, headers: optHeader));
  }
  static void removeHeader(String name){
    optHeader.remove(name);
    dio = new Dio(BaseOptions(connectTimeout: 30000, headers: optHeader));
  }
  static dynamic get(String url, [Map<String, dynamic> params]) async {
    var response;
    if (params != null) {
      response = await dio.get(url, queryParameters: params);
    } else {
      response = await dio.get(url);
    }
    return response.data;
  }

  static dynamic post(String url, [Map<String, dynamic> params]) async {
    var response = await dio.post(url, data: params);
    return response.data;
  }

  static dynamic delete(String url, [Map<String, dynamic> params]) async {
    var response = await dio.delete(url, data: params);
    return response.data;
  }
}
