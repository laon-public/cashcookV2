import 'dart:convert';

import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/AuthProvider.dart';
import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/center/appConfirm.dart';
import 'package:cashcook/src/screens/referrermanagement/firstbiz.dart';
import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
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
    // 로그인 CSS 확인할 때 사용
    // cookieManager.clearCookies();

    flutterWebviewPlugin = FlutterWebviewPlugin();

    // Plugin 메커니즘 정의
    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      String chkUrl = url;
      print(url);
      if(chkUrl.contains("?"))
        chkUrl = chkUrl.split("?")[0];

      switch(chkUrl) {
        case loginSuccessUrl :
          Uri uri = Uri.parse(url);
          String code = uri.queryParameters['code'];

          String response = await Provider.of<AuthProvider>(context, listen: false).authToken(code);
          Map<String, dynamic> json = jsonDecode(response);
          if(json['access_token'] != null) {
            dataStorage.token = json['access_token'];

            await Provider.of<UserProvider>(context, listen: false)
                .fetchMyInfo();

            UserCheck user = Provider
                .of<UserProvider>(context, listen: false)
                .loginUser;

            FirebaseMessaging fcm = FirebaseMessaging();
            String fcmToken = await fcm.getToken();
            print(fcmToken);
            if(user.fcmToken == "" || user.fcmToken != fcmToken) {
              await Provider.of<UserProvider>(context, listen: false).patchFcmToken(fcmToken);
            }

            if (user.isFirstLogin != true) {
              Provider.of<CenterProvider>(context, listen: false)
                  .startLoading();
              Navigator.of(context)
                  .pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => AppConfirm()), (
                  route) => false);
            } else {
              Navigator.of(context)
                  .pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => FirstBiz()), (
                  route) => false);
            }
          } else {
            flutterWebviewPlugin.launch(baseUrl + "/oauth/authorize?client_id=cashcook&redirect_uri=" + loginSuccessUrl + "&response_type=code");
          }
          break;

        case baseUrl + "/":
          showToast("페이지를 불러오는데 실패했습니다.\n로그인 페이지로 이동합니다.");
          flutterWebviewPlugin.reloadUrl(baseUrl + "/oauth/authorize?client_id=cashcook&redirect_uri=" + loginSuccessUrl + "&response_type=code");

          break;
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
          url : baseUrl + "/oauth/authorize?client_id=cashcook&redirect_uri=" + loginSuccessUrl + "&response_type=code",
          clearCookies: false,
        )
      )
          :
      Container(),
    );
  }
}