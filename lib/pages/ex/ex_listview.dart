import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ssi/util/NetUtils.dart';
import 'package:ssi/util/ui_common.dart';
import 'dart:convert';
class ExListViewPage extends StatefulWidget {
  @override
  _ExListViewPageState createState() => _ExListViewPageState();
}

class _ExListViewPageState extends State<ExListViewPage> {
  List<Model> _items = new List();
  ScrollController _scrollController = ScrollController();
  int _page = 1; //加载的页数
  bool isLoading = false; //是否正在加载数据

  @override
  void initState() {
    super.initState();
    _getListDate();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("用户列表"),
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: new ListView.builder(
            itemCount: _items.length + 1,
            itemBuilder: itemView,
            controller: _scrollController,),
        )
    );
  }

  Widget _getMoreWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '加载中...     ',
              style: TextStyle(fontSize: 16.0),
            ),
            CircularProgressIndicator(strokeWidth: 1.0,)
          ],
        ),
      ),
    );
  }

  Widget itemView(BuildContext context,int index){
    if(index < _items.length) {
      Model model = this._items[index];
      if (index.isOdd) return new Divider(height: 2.0);
      return new Container(
          color: Color.fromARGB(0x22, 0x49, 0x49, 0x8d),
          child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Column(
                    children: <Widget>[
                      new Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage.assetNetwork(
                                  placeholder: "/images/logo57.png",
                                  width: 50,
                                  height: 50,
                                  image: '${model.avator}',
                                  fit: BoxFit.cover,),),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                   Container(
                                     width: 260,
                                     child:  new Text("${model.nickname}",
                                       maxLines: 1,
                                       overflow: TextOverflow.ellipsis,
                                       style: new TextStyle(fontSize: 22.0),),
                                   ),
                                    Text(
                                      "${model.modify_time}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: new TextStyle(
                                          fontSize: 16.0, color: Colors.grey),),
                                  ],
                                )
                            ),

                          ]
                      )
                    ],
                  )
              )
          )
      );
    }
    return _getMoreWidget();
  }

  Future<Null> _onRefresh() async {
    _page = 1;
    _getListDate();
  }
  Future _getMoreData() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      _page++;
      String items = await NetUtils.get("http://wx.sumslack.com/restful/stat/userList.jhtml?p=" + _page.toString());
      final dynamic dataJson = json.decode(items);
      final List resultList = dataJson['result'];
      resultList.forEach((dynamic _user)  {
        num _time = _user["modify_time"]*1000;
        var dt = DateFormat.yMMMd().add_Hms().format(new DateTime.fromMicrosecondsSinceEpoch(_time));
        _items.add(new Model(_user["uid"],_user["nickname"],_user["avator"],dt));
      });
      isLoading = false;
    }
  }
  void _getListDate({Function ff}) async{
        //列表来自http请求
      String items = await NetUtils.get("http://wx.sumslack.com/restful/stat/userList.jhtml?p=" + _page.toString());
      print("######:" + items.toString());
      List<Model> widgets =  [];
      final dynamic dataJson = json.decode(items);
      final List resultList = dataJson['result'];
      resultList.forEach((dynamic _user)  {
          print(_user["nickname"]);
          num _time = _user["modify_time"]*1000;
          var dt = DateFormat.yMMMd().add_Hms().format(new DateTime.fromMicrosecondsSinceEpoch(_time));
          widgets.add(new Model(_user["uid"],_user["nickname"],_user["avator"],dt));
        });
      setState(() {
          _items= widgets;
      });
  }
}


class Model {
  String uid;
  String nickname;
  String avator;
  String modify_time;
  Model(this.uid,this.nickname,this.avator,this.modify_time);
}