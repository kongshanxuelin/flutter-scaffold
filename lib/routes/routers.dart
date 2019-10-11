import 'package:flutter/material.dart';
import '../pages/SingleManagerWidgets.dart';
import '../event/ApplicationEvent.dart';
import "../pages/ex/ex_api.dart";

class Routes {
  static String root = "/";
  static String home = "/home";
  static String timeline = "/timeline";
  static String body = "/body";
  static String me = "/me";

  static String login = "/login";
  static String webViewPage = '/web-view-page';
  static String loginPage = '/loginpage';

  //demo例子
  static final exApi = "/ex/api";

  static String test1 = '/test1';
  static String test2 = '/test2';
  static String test3 = '/test3';

  static Map<String,WidgetBuilder> routeTable = <String, WidgetBuilder>{
    //也可以不定义home属性，用/启动首页
    //"/": (BuildContext context) => new MyPage(title: '首页'),
    login: (BuildContext context) => SingleManagerWidgets.instance.getLogin(),
    home: (BuildContext context) => SingleManagerWidgets.instance.getHome(),
    timeline: (BuildContext context) => SingleManagerWidgets.instance.getTimeline(),
    body: (BuildContext context) => SingleManagerWidgets.instance.getBody(),
    me:(BuildContext context) => SingleManagerWidgets.instance.getMe(),

    exApi:(BuildContext context) => ExApiWidget(),
    //3个测试页面
    test1:(BuildContext context) => SingleManagerWidgets.instance.getTestPage("测试1"),
    test2:(BuildContext context) => SingleManagerWidgets.instance.getTestPage("测试2"),
    test3:(BuildContext context) => SingleManagerWidgets.instance.getTestPage("测试3"),
  };

  static Map<String,WidgetBuilder> getRoutes(){
      return routeTable;
  }

  static WidgetBuilder getRouteWidget(String routeName){
    if(routeTable.containsKey(routeName)){
      return routeTable[routeName];
    }
    return null;
  }

  static nav(BuildContext context,String name,{Map<String,dynamic> args}){
    print("导航到页面：" + name);
    if(name == timeline){
      ApplicationEvent.event.fire(EvtHomeNavChange(1));
      return;
    }
    if(args != null) {
      Navigator.of(context).pushNamed(name, arguments: args);
    }else{
      Navigator.of(context).pushNamed(name);
    }
  }
}