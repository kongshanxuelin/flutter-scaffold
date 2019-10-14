import "package:flutter/material.dart";
import "home.dart";
import "timeline.dart";
import "body.dart";
import "me.dart";
import "test.dart";
import "../widgets/404.dart";
import '../widgets/webview_page.dart';

class SingleManagerWidgets {
  // 工厂模式
  factory SingleManagerWidgets() =>_getInstance();
  static SingleManagerWidgets get instance => _getInstance();
  static SingleManagerWidgets _instance;
  SingleManagerWidgets._internal() {
    // 初始化
  }
  static SingleManagerWidgets _getInstance() {
    if (_instance == null) {
      _instance = new SingleManagerWidgets._internal();
    }
    return _instance;
  }

  Widget getNotFound(){
    return WidgetNotFound();
  }
  Widget getHome(){
    return PageHome();
  }
  Widget getTimeline(){
    return PageTimeline();
  }
  Widget getBody(){
    return PageBody();
  }
  Widget getMe(){
    return PageMe();
  }
  Widget getTestPage(String title){
    return TestPage(title:title);
  }

  Widget webview(){
    return WebViewPage();
  }
}