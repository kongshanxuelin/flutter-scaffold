import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomActionSheet {
  static show(BuildContext context, List<String> data, {String title: '', Function callBack(int)}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              color: Color.fromRGBO(114, 114, 114, 1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //为了防止控件溢出
                  Flexible(
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.all(Radius.circular(14)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Container(
                              height: 40,
                              alignment: Alignment.center,
                              child: new Text(
                                title,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: Color(0xFF3F3F3F),
                            ),
                            Flexible(
                                child: ListView.builder(
                                  /**
                                      If you do not set the shrinkWrap property, your ListView will be as big as its parent.
                                      If you set it to true, the list will wrap its content and be as big as it children allows it to be. */
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: <Widget>[
                                        new ListTile(
                                          onTap: () {
                                            callBack(index);
                                            Navigator.pop(context);
                                          },

                                          title: new Text(
                                            data[index],
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        index == data.length - 1
                                            ? Container()
                                            : Divider(
                                          height: 1,
                                          color: Color(0xFF3F3F3F),
                                        ),
                                      ],
                                    );
                                  },
                                )),

                          ],
                        ),
                      )),
                  SizedBox(
                    height: 9,
                  ),
                  Container(
                    height: 56,
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(Radius.circular(14)),
                    ),
                    child: InkWell(
                      onTap: () {
                        //点击取消 弹层消失
                        Navigator.pop(context);
                      },
                      child: Text('取消',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            color: Color(0xFF007AFF),
                            fontSize: 17.0,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}