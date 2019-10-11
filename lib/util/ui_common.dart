import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import "../components/bottom_sheet.dart";
import "../components/toast_widget.dart";

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
                Navigator.of(context).pop();
                if(callback!=null){
                  callback(false);
                }
              }, child: Text("取消")),
              new FlatButton(onPressed: (){
                Navigator.of(context).pop();
                if(callback!=null){
                  callback(true);
                }
              }, child: Text("确定"))
            ],
          );
        }
    );
  }
  static ToastView preToast;
  static toast(BuildContext context,String msg){
    preToast?.dismiss();
    preToast = null;

    var overlayState = Overlay.of(context);
    var controllerShowAnim = new AnimationController(
      vsync: overlayState,
      duration: Duration(milliseconds: 250),
    );
    var controllerShowOffset = new AnimationController(
      vsync: overlayState,
      duration: Duration(milliseconds: 350),
    );
    var controllerHide = new AnimationController(
      vsync: overlayState,
      duration: Duration(milliseconds: 250),
    );
    var opacityAnim1 =
    new Tween(begin: 0.0, end: 1.0).animate(controllerShowAnim);
    var controllerCurvedShowOffset = new CurvedAnimation(
        parent: controllerShowOffset, curve: BounceOutCurve.A());
    var offsetAnim =
    new Tween(begin: 30.0, end: 0.0).animate(controllerCurvedShowOffset);
    var opacityAnim2 = new Tween(begin: 1.0, end: 0.0).animate(controllerHide);

    OverlayEntry overlayEntry;
    overlayEntry = new OverlayEntry(builder: (context) {
      return ToastWidget(
        opacityAnim1: opacityAnim1,
        opacityAnim2: opacityAnim2,
        offsetAnim: offsetAnim,
        child: _buildToastLayout(msg),
      );
    });
    var toastView = ToastView();
    toastView.overlayEntry = overlayEntry;
    toastView.controllerShowAnim = controllerShowAnim;
    toastView.controllerShowOffset = controllerShowOffset;
    toastView.controllerHide = controllerHide;
    toastView.overlayState = overlayState;

    preToast = toastView;
    toastView.show();
  }

  static showActionSheet(BuildContext context,List<String> menus,Function callback,{title:""}){
    BottomActionSheet.show(context, menus,title: title,callBack:(i) {
      callback(i);
      return;
    });
  }

  static close(BuildContext context){
    Navigator.of(context).pop();
  }

  static copyToClip(String msg){
    Clipboard.setData(ClipboardData(text:msg));
  }

  static Future<String> copyFromClip() async{
    ClipboardData r =  await Clipboard.getData(Clipboard.kTextPlain);
    return r.text;
  }

  //private
  static LayoutBuilder _buildToastLayout(String msg) {
    return LayoutBuilder(builder: (context, constraints) {
      return IgnorePointer(
        ignoring: true,
        child: Container(
          child: Material(
            color: Colors.white.withOpacity(0),
            child: Container(
              child: Container(
                child: Text(
                  "${msg}",
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              margin: EdgeInsets.only(
                bottom: constraints.biggest.height * 0.15,
                left: constraints.biggest.width * 0.2,
                right: constraints.biggest.width * 0.2,
              ),
            ),
          ),
          alignment: Alignment.bottomCenter,
        ),
      );
    });
  }
}