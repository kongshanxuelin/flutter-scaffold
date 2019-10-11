import 'package:flutter/material.dart';

import '../../util/MyIcons.dart';
import '../../routes/routers.dart';
import "../../util/ui_common.dart";
import "../../util/NetUtils.dart";
import "../../components/bottom_sheet.dart";

class ExApiWidget extends StatelessWidget {
  static const String ID_ALERT = "alert";
  static const String ID_CONFIRM = "confirm";
  static const String ID_TOAST = "toast";
  static const String ID_ACITONSHEET = "actionsheet";
  static const String ID_CLIP = "clipboard";
  static const String ID_NAV = "nav";
  static const String ID_CLOSE = "close";
  static const String ID_GET = "get";
  static const String ID_POST = "post";
  static const String ID_JPUSH = "jpush";

  List items = [
    {"title":ID_ALERT,"d":"弹出警告框"},
    {"title":ID_CONFIRM,"d":"弹出确认框"},
    {"title":ID_TOAST,"d":"简单提示框显示"},
    {"title":ID_ACITONSHEET,"d":"弹出底部菜单"},
    {"title":ID_CLIP,"d":"剪贴板操作"},
    {"title":ID_NAV,"label":"跳转页面","d":"路由到某个页面，并且我们传了json给下一个页面"},
    {"title":ID_CLOSE,"d":"关闭当前页面"},
    {"title":ID_GET,"d":"网络get请求"},
    {"title":ID_POST,"d":"网络post请求"},
    {"title":ID_JPUSH,"label":"极光推送","d":"极光推送测试，发送的请求会以Notification的形式返回"},
  ];

  _itemClick(BuildContext context,Map item) async{
    var _title = item["title"];
    switch(_title){
      case ID_ALERT:
        SsUI.alert(context,"警告对话框测试",callback:(){
          return true;
        });
        break;
      case ID_CONFIRM:
        SsUI.confirm(context,"是否确定删除",callback:(isok){
           if(isok){
             SsUI.alert(context,"true");
           }else{
             SsUI.alert(context,"false");
           }
        });
        break;
      case ID_TOAST:
        SsUI.toast(context, "测试的一条提示信息！！！！");
        break;
      case ID_ACITONSHEET:
        SsUI.showActionSheet(context, [
          "Menu1","Menu2","Menu3"
        ], (item){
          SsUI.toast(context, "选中第 ${item+1} 项菜单！");
        },title:"下拉菜单");
        break;
      case ID_CLIP:
        SsUI.copyToClip("复制到剪贴板内容");
        SsUI.copyFromClip().then( (String s){
          SsUI.toast(context,"获取到剪贴板内容： "+s );
        });

        break;
      case ID_NAV:
        Routes.nav(context, "/test1",args:{"arg":"xxxx"});
        break;
      case ID_CLOSE:
        SsUI.close(context);
        break;
      case ID_GET:
        String str = await NetUtils.get("http://wx.sumslack.com/restful/stat/stat.jhtml",{"a":1});
        SsUI.alert(context, str);
        break;
      case ID_POST:
        String str = await NetUtils.post("http://wx.sumslack.com/restful/stat/stat.jhtml",{"a":1});
        SsUI.alert(context, str);
        break;
      case ID_JPUSH:
        await NetUtils.get("http://192.168.1.154:6060/report/jpush/msg?title=flutter scaffold&msg=Hello,World!");
        SsUI.toast(context, "请观察提醒栏是否收到一条新通知！");
        break;
    }
  }
  @override
  Widget build(BuildContext context) {

    Widget divider1=Divider(color: Colors.blue,);
    Widget divider2=Divider(color: Colors.grey);

    return Scaffold(
      appBar: AppBar(
        title: Text("基础API示例"),
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
//            separatorBuilder: (BuildContext context,int index){
//              return index%2==0?divider1:divider2;
//            },
            itemBuilder: (BuildContext context, int index) {
              Map item = items.elementAt(index);
              return ListTile(
                  trailing: new Icon(Icons.keyboard_arrow_right),
                  leading: Container(child: new Icon(Icons.title,size: 40,),padding: EdgeInsets.all(0),),
                  contentPadding: EdgeInsets.symmetric(horizontal: 6.0,vertical: 0.0),
                  onTap: (){
                    _itemClick(context,item);
                  },
                  title:Text(item["label"]??=item["title"]),
                  subtitle: Padding(child:Text(item["d"],style: TextStyle(fontSize: 12,color:Colors.grey),),padding: EdgeInsets.only(left:0))
              );
            },
        ),
      ),
    );
  }
}
