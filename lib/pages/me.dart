import "package:flutter/material.dart";

class PageMe extends StatefulWidget {
  @override
  _PageMeState createState() => _PageMeState();
}

class _PageMeState extends State<PageMe> {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("我的页面")
        ],
      )
    );
  }
}
