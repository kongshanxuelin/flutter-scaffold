import 'package:flutter/material.dart';
import "app.dart";
import "util/sp.dart";
import 'util/db.dart';
import 'package:amap_base/amap_base.dart';
import 'util/sumslack_api.dart' as sumslack;

SpUtil sp;
var db;

void main() async {
  await AMap.init("f3951fe8b1ca3f39f8346bbfe19fef5a");
  //初始化本地数据库
  final provider = new Provider();
  await provider.init(true);
  //初始化个性化设置
  sp = await SpUtil.getInstance();

  //从线上拉取首页导航项
  db = Provider.db;

  //初始化Sumslack云API
  sumslack.init("xxxx", "yyy");

  runApp(Navigation());
}


