import "package:flutter/material.dart";

class PageTimeline extends StatefulWidget {
  @override
  _PageTimelineState createState() => _PageTimelineState();
}

class _PageTimelineState extends State<PageTimeline> {
  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Timeline")
          ],
        )
    );
  }
}
