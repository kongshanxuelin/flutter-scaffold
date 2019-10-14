
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {

  final Completer<WebViewController> _controller = Completer<WebViewController>();
  String _title;
  String _url;
  @override
  Widget build(BuildContext context) {

    var args = ModalRoute.of(context).settings.arguments;
    var _args = "";
    if(args is Map){
      args.forEach((k,v) => _args += " ${k}:${v} ");
      _title = args["title"]??="";
      _url = args["url"];
    }else{
      throw Exception("调用浏览器控件必须传入url，可选传入title");
    }

    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (context, snapshot) {
          return WillPopScope(
            onWillPop: () async {
              if (snapshot.hasData){
                bool canGoBack = await snapshot.data.canGoBack();
                if (canGoBack){
                  // 网页可以返回时，优先返回上一页
                  snapshot.data.goBack();
                  return Future.value(false);
                }
                return Future.value(true);
              }
              return Future.value(true);
            },
            child: Scaffold(
                appBar: AppBar(
                  title: Text(_title),
                ),
                body: WebView(
                  initialUrl: _url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                )
            ),
          );
        }
    );
  }

}
