import 'package:flutter/material.dart';
import "../components/bottom_sheet.dart";

class SsUI{
  static alert(BuildContext context,String msg,{String title,Function callback}){
    showDialog(
        context:context,
        builder: (BuildContext context){
          return AlertDialog(
            title : Text(title!=null ? title:"系统消息"),
            content: Text(msg),
            actions: <Widget>[
              new FlatButton(onPressed: (){
                if(callback!=null){
                  var isClose = callback();
                  if(isClose){
                    Navigator.pop(context);
                  }
                }else {
                  Navigator.pop(context);
                }
              }, child: Text("确定"))
            ],
          );
        }
    );
  }

  static confirm(BuildContext context,String msg,{String title,Function callback}){
    showDialog(
        context:context,
        builder: (BuildContext context){
          return AlertDialog(
            title : Text(title!=null ? title:"系统消息"),
            content: Text(msg),
            actions: <Widget>[
              new FlatButton(onPressed: (){
                if(callback!=null){
                  callback(false);
                }
                Navigator.of(context).pop();
              }, child: Text("取消")),
              new FlatButton(onPressed: (){
                if(callback!=null){
                  callback(true);
                }
                Navigator.of(context).pop();
              }, child: Text("确定"))
            ],
          );
        }
    );
  }

  static showActionSheet(BuildContext context,List<String> menus,Function callback,{title:""}){
    BottomActionSheet.show(context, menus,title: title,callBack:(i) {
      callback(i);
      return;
    });
  }
}