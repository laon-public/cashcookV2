import 'package:cashcook/src/services/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Login3 extends StatefulWidget {
  @override
  _Login3 createState() => _Login3();
}

class _Login3 extends State<Login3> {
  bool viewWeb = false;
  FlutterWebviewPlugin flutterWebviewPlugin;
  CookieManager cookieManager = CookieManager();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cookieManager.clearCookies();

    flutterWebviewPlugin = FlutterWebviewPlugin();

    // Plugin 메커니즘 정의
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      switch(url) {
        case loginSuccessUrl :


      }
    });


    viewWeb = true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: viewWeb ?
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: WebviewScaffold(
          url : baseUrl + "oauth/authorize?client_id=cashcook&redirect_uri=" + loginSuccessUrl + "&response_type=code",
          clearCookies: false,
        )
      )
          :
      Container(),
    );
  }
}