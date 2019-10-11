import 'dart:convert';

import "package:flutter/material.dart";
import '../util/MyIcons.dart';
import '../routes/routers.dart';
import "../util/ui_common.dart";
import "../util/NetUtils.dart";
import 'package:dio/dio.dart';

class PageHome extends StatefulWidget{
  @override
  _PageHomeState createState() => _PageHomeState();
}
var menus = [
  {"route":Routes.exApi,"title":"基本API","icon":MyIcons.qingjia,"isnew":true},
  {"route":"/timeline","title":"Bus切换","icon":MyIcons.fabu},
];
class _PageHomeState extends State<PageHome> {
  doAjax(BuildContext context) async{
    String str = await NetUtils.get("http://wx.sumslack.com/restful/stat/stat.jhtml",{"a":1});
    SsUI.alert(context, str);
    //可利用：json.decode(str)转成map或list对象后取值
  }
  @override
  Widget build(BuildContext context) {
    //根据分类列表初始化首页内容
    return new Center(
        child: GridView(
          children: menus.map((Map s) => GestureDetector(
            onTap:(){
              String router = s["route"];
              Routes.nav(context,router);
            },
            child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 0.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Icon(s["icon"],size: 30,color: Colors.lightGreen.shade900,),
                          Container(
                            margin:const EdgeInsets.only(top: 6.0),
                            child: Text(s["title"],style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16.0,
                            )),
                          )
                        ],
                      ),
                    ),
                    _buildNew(s.containsKey("isnew") && s["isnew"])
                  ],
                )
            ),
          )).toList(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:4,
              mainAxisSpacing:0.3,
              crossAxisSpacing: 0.8,
              childAspectRatio:1.0),
        )
    );
  }
  Widget _buildNew(bool isnew){
    if(!isnew){
      return Container();
    }
    return Positioned(
      right: 4,
      top: 4,
      child: Icon(MyIcons.xin,size: 15,color: Colors.red,),
    );
  }
}
