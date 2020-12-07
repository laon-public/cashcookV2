import 'dart:io';

import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Login2 extends StatefulWidget {
  @override
  _Login2 createState() => _Login2();
}

class _Login2 extends State<Login2> {
  bool viewWeb = false;
  WebviewCookieManager cookieManager = WebviewCookieManager();
  WebViewController webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewWeb = true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: viewWeb ?
      WebView(
          initialUrl: baseUrl + "oauth/authorize?client_id=cashcook&redirect_uri=" + loginSuccessUrl + "&response_type=code",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            this.webViewController = controller;
          },
          onPageStarted: (url) async {
            print("Page Started");
            print("now Page ===> $url");

            if(url.contains("?") && url.split("?")[0] == loginSuccessUrl) {
              // List<Cookie> cookies = await cookieManager.getCookies(url);
              // for(Cookie cookie in cookies) {
              //   print("${cookie.name} ===> ${cookie.value}");
              //
              //   if(cookie.name == "remember-me") {
              //     print("자동 로그인 확인용");
              //     break;
              //   }
              // }

              Uri uri = Uri.parse(url);
              String code = uri.queryParameters['code'];

              print(code);
            }
          },
          onPageFinished: (url) {
            print("Page Finished");
          },
      )
          :
      Container(),
    );
  }
}