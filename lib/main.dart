import 'package:flutter/material.dart';
import "app.dart";
import "util/sp.dart";
import 'util/db.dart';

SpUtil sp;
var db;

void main() async {
  //初始化本地数据库
  final provider = new Provider();
  await provider.init(true);
  //初始化个性化设置
  sp = await SpUtil.getInstance();

  //从线上拉取首页导航项
  db = Provider.db;

  runApp(Navigation());
}


