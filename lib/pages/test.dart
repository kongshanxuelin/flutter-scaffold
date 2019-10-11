import 'package:flutter/material.dart';
class TestPage extends StatelessWidget {
  TestPage({Key key, this.title}) : super(key: key);
  final String title;

  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;
    var _args = "";
    if(args is String){
      _args = args;
    }else if(args is Map){
      args.forEach((k,v) => _args += " ${k}:${v} ");
    }
    return new Scaffold(
      appBar: new AppBar(
          title: new Text(title)
      ),
      body: Padding(
          padding:const EdgeInsets.all(8.0),
          child:new Text("传入的参数："+_args)
      ),
    );
  }
}