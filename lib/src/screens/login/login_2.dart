import 'dart:convert';

import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/AuthProvider.dart';
import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/center/appConfirm.dart';
import 'package:cashcook/src/screens/referrermanagement/firstbiz.dart';
import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
              Uri uri = Uri.parse(url);
              String code = uri.queryParameters['code'];

              String response = await Provider.of<AuthProvider>(context, listen: false).authToken(code);
              Map<String, dynamic> json = jsonDecode(response);
              if(json['access_token'] != null){
                dataStorage.token = json['access_token'];

                await Provider.of<UserProvider>(context, listen: false).fetchMyInfo();

                UserCheck user = Provider.of<UserProvider>(context, listen: false).loginUser;

                if(user.isFirstLogin != true) {
                  Provider.of<CenterProvider>(context, listen: false).startLoading();
                  Navigator.of(context)
                  // .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainMap()), (route) => false);
                  // .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (route) => false);
                      .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AppConfirm()), (route) => false);
                } else {
                  Navigator.of(context)
                      .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => FirstBiz()), (route) => false);
                }
              } else {
                // 토큰 얻기 실패
                await cookieManager.clearCookies();
                this.webViewController.loadUrl(baseUrl + "oauth/authorize?client_id=cashcook&redirect_uri=" + loginSuccessUrl + "&response_type=code");
              }
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