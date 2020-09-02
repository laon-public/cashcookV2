import 'dart:async';
import 'dart:convert';

import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/provider/provider.dart';
import 'package:cashcook/src/screens/RecoSelectFirst.dart';
import 'package:cashcook/src/screens/login/login.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/screens/mypage/mypage.dart';
import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:cashcook/src/utils/webViewScroll.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart' as P;
import 'package:webview_flutter/webview_flutter.dart';

class MyUpdate extends StatefulWidget {
  final int authCheck;

  MyUpdate({this.authCheck});

  @override
  _MyUpdate createState() => _MyUpdate();
}

class _MyUpdate extends State<MyUpdate> {
  WebViewController webViewController;
//  String url =
//      "http://auth.cashlink.kr/auth_api/oauth/authorize?client_id=cashcook&redirect_uri=https://naver.com&response_type=code";
  String url =
//      "http://192.168.100.226:8080/auth_api/users/modify/modifyInfo?client_id=cashcook";
        "http://auth.cashlink.kr/auth_api/users/modify/modifyInfo?client_id=cashcook";

  bool clearCache = false;

  bool userCheck = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    P.Provider.of<UserProvider>(context, listen: false).fetchMyInfo(context);
//    mainMapMove();
  }

  mainMapMove() {
    return Timer(Duration(seconds: 0), route);
  }

  route() {
    Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainMap()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top,bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Stack(
            children: [
              WebView(
//                gestureRecognizers: [
//                  Factory(() => PlatformViewVerticalGestureRecognizer()),
//                ].toSet(),
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (webViewController) {
                  print("갑니다!");
                  if (!clearCache) {
                    webViewController.clearCache();
                    clearCache = true;
                  }
                  UserProvider userProvider = P.Provider.of<UserProvider>(context,listen: false);
                  UserCheck userCheck = userProvider.loginUser;
                  print("요기");
                  print(userCheck.name);
//                  webViewController.loadUrl(url + "&username=${userCheck.username}",
                  webViewController.loadUrl(baseUrl + "users/modify/modifyInfo?client_id=cashcook" + "&username=${userCheck.username}",
                      headers: {"Authorization": "BEARER ${dataStorage.token}"});
                  this.webViewController = webViewController;
                },

                onPageStarted: (url) {
//                  if (url == "http://gateway.cashlink.kr/auth_api/") {
                  print("onPageStarted");
                  if (url == baseUrl) {
//                  webViewController.clearCache();
                    webViewController.loadUrl(baseUrl + "users/modify/modifyInfo?client_id=cashcook");
                    if (widget.authCheck != 1) {
                      showToast("회원정보수정에 실패하였습니다.");
                    }
                  }
                },
                onPageFinished: (url) async {
                  print("onPageFinished");
                  print("url : $url");
                  List<String> code = List();
//                  if (url == "http://192.168.100.226:8080/auth_api/users/modify/success") {
//                  if (url == "http://auth.cashlink.kr/auth_api/users/modify/success") {
                    if (url == baseUrl + "users/modify/success") {
                    print(dataStorage.token);
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
