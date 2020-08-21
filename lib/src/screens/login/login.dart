import 'dart:async';
import 'dart:convert';

import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/provider/provider.dart';
import 'package:cashcook/src/screens/RecoSelectFirst.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:cashcook/src/utils/webViewScroll.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart' as P;
import 'package:webview_flutter/webview_flutter.dart';

class Login extends StatefulWidget {
  final int authCheck;

  Login({this.authCheck});

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  WebViewController webViewController;
  FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();
//  String url =
//      "http://auth.cashlink.kr/auth_api/oauth/authorize?client_id=cashcook&redirect_uri=https://naver.com&response_type=code";
  String url =
//      "http://192.168.100.237/auth_api/oauth/authorize?client_id=cashcook&redirect_uri=https://m.naver.com&response_type=code";
        "http://192.168.100.226/auth_api/oauth/authorize?client_id=cashcook&redirect_uri=https://m.naver.com&response_type=code";

//  String logoutUrl = "http://auth.cashlink.kr/auth_api/users/logout";
//  String logoutUrl = "http://192.168.100.237/auth_api/users/logout";
    String logoutUrl = "http://192.168.100.226/auth_api/users/logout";

  bool clearCache = false;

  bool userCheck = false;

  @override
  void initState() {
    print("initState123");
    // TODO: implement initState
    super.initState();
//    mainMapMove();
  flutterWebviewPlugin.onUrlChanged.listen((String url) async {
    if (url == "http://192.168.100.226/auth_api/") {
      print("로그인실패123");
                  webViewController.clearCache();
      webViewController.loadUrl(this.url);
      print("test012345");
      print(this.url);
      print(widget.authCheck);
      if (widget.authCheck != 1) {
        showToast("로그인에 실패하였습니다.");
      }
    }
    print("로그인실패x");
    print("url : $url");
    List<String> code = List();
    if (url.contains("code") && !url.contains("oauth")) {
      print("아래if문");
      setState(() {
        userCheck = true;
      });
      code = url.split("=");
      dataStorage.oauthCode = code[1];

      await provider.authToken().then((value) async {
        print("authToken123");
        dynamic authToken = json.decode(value);
        print("authToken : ${authToken['access_token']}");
        dataStorage.token = authToken['access_token'];
        // 유저 정보 가져오고 회원정보 있는지 확인 후 홈으로 보낼 지 기본 회원 정보 받는 곳으로 이동할 지 결정

        if (authToken['access_token'] != null) {
          print("access_token123");
          await provider
              .authCheck(authToken['access_token'])
              .then((value) async {
            dynamic authCheck = json.decode(value)['data']['user'];
            int sex = 0;
            print(authCheck);

            if ("MAN" == authCheck['sex']) {
              sex = 0;
            } else {
              sex = 1;
            }
            List<String> phoneSplit = List();
            phoneSplit = authCheck['phone'].toString().split("-");

            UserCheck userCheck;
            if (authCheck['phone'].toString().contains("-")) {
              userCheck = UserCheck(
                  username: authCheck['username'],
                  name: authCheck['name'],
                  phone: phoneSplit[0] + phoneSplit[1] + phoneSplit[2],
                  birth: authCheck['birth'],
                  token: authCheck['token'],
                  gender: sex,
                  isFirstLogin: authCheck['isFirstLogin']);
            } else {
              userCheck = UserCheck(
                  username: authCheck['username'],
                  name: authCheck['name'],
                  phone: authCheck['phone'],
                  birth: authCheck['birth'],
                  token: authCheck['token'],
                  gender: sex,
                  isFirstLogin: authCheck['isFirstLogin']);
            }

            print(authCheck['token']);

            print(userCheck.username);
            print(userCheck.isFirstLogin);

            print(authCheck);

            if (userCheck.username != "") {
              dynamic franchise = json.decode(value)['data']['franchise'];
              if(franchise != null){
                P.Provider.of<UserProvider>(context,listen: false).setStoreModel(StoreModel.fromJson(franchise));
              }

              P.Provider.of<UserProvider>(context,listen: false).setLoginUser(userCheck);
//              await P.Provider.of<UserProvider>(context, listen: false).userSync();
//                            if(userCheck.isFirstLogin) {
////                              P.Provider.of<UserProvider>(context,listen: false).postReco();
//                              Navigator.of(context)
//                                  .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RecoFrst()), (route) => false);
//                            }else {
              Navigator.of(context)
                  .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainMap()), (route) => false);
//                            }
            }

//                          await provider
//                              .selectUser(userCheck.username)
//                              .then((value) {
//                            print(value);
//                            dynamic selectUser = json.decode(value);
//                            if (selectUser['data'] != null) {
//                              User user = User.fromJson(selectUser['data']);
//
//                              dataStorage.user = user;
//
//                              Navigator.of(context).pushAndRemoveUntil(
//                                  MaterialPageRoute(
//                                      builder: (context) => Home()),
//                                      (Route<dynamic> route) => false);
//                            } else {
//                              Navigator.of(context).pushAndRemoveUntil(
//                                  MaterialPageRoute(
//                                      builder: (context) => NewSignUp(
//                                        userCheck: userCheck,
//                                      )),
//                                      (Route<dynamic> route) => false);
//                            }
//                          });
          });
        }
      });
    }
    });
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
    print("buildUrl : " + url);
    print("아래 widget.authCheck");
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
              WebviewScaffold(
//                gestureRecognizers: [
//                  Factory(() => PlatformViewVerticalGestureRecognizer()),
//                ].toSet(),
//                initialUrl: widget.authCheck == 1 ? logoutUrl : url,
//                javascriptMode: JavascriptMode.unrestricted,
                url: widget.authCheck == 1 ? logoutUrl : url,
//                onWebViewCreated: (webViewController) {
//                  if (!clearCache) {
//                    webViewController.clearCache();
//                    clearCache = true;
//                  }
//                  this.webViewController = webViewController;
//                },
//                onPageStarted: (url) {
////                  if (url == "http://gateway.cashlink.kr/auth_api/") {
////                if (url == "http://192.168.100.237/auth_api/") {
//                  if (url == "http://192.168.100.215/auth_api/") {
////                  webViewController.clearCache();
//                    webViewController.loadUrl(this.url);
//                    print("test012345");
//                    print(this.url);
//                    print(widget.authCheck);
//                    if (widget.authCheck != 1) {
//                      showToast("로그인에 실패하였습니다.");
//                    }
//                  }
//                },
//                onPageFinished: (url) async {
//                  print("url : $url");
//                  List<String> code = List();
//                  if (url.contains("code") && !url.contains("oauth")) {
//                    setState(() {
//                      userCheck = true;
//                    });
//                    code = url.split("=");
//                    dataStorage.oauthCode = code[1];
//
//                    await provider.authToken().then((value) async {
//                      dynamic authToken = json.decode(value);
//                      print("authToken : ${authToken['access_token']}");
//                      dataStorage.token = authToken['access_token'];
//                      // 유저 정보 가져오고 회원정보 있는지 확인 후 홈으로 보낼 지 기본 회원 정보 받는 곳으로 이동할 지 결정
//
//                      if (authToken['access_token'] != null) {
//                        await provider
//                            .authCheck(authToken['access_token'])
//                            .then((value) async {
//                          dynamic authCheck = json.decode(value)['data']['user'];
//                          int sex = 0;
//                          print(authCheck);
//
//                          if ("MAN" == authCheck['sex']) {
//                            sex = 0;
//                          } else {
//                            sex = 1;
//                          }
//                          List<String> phoneSplit = List();
//                          phoneSplit = authCheck['phone'].toString().split("-");
//
//                          UserCheck userCheck;
//                          if (authCheck['phone'].toString().contains("-")) {
//                            userCheck = UserCheck(
//                                username: authCheck['username'],
//                                name: authCheck['name'],
//                                phone: phoneSplit[0] + phoneSplit[1] + phoneSplit[2],
//                                birth: authCheck['birth'],
//                                token: authCheck['token'],
//                                gender: sex,
//                                isFirstLogin: authCheck['isFirstLogin']);
//                          } else {
//                            userCheck = UserCheck(
//                                username: authCheck['username'],
//                                name: authCheck['name'],
//                                phone: authCheck['phone'],
//                                birth: authCheck['birth'],
//                                token: authCheck['token'],
//                                gender: sex,
//                                isFirstLogin: authCheck['isFirstLogin']);
//                          }
//
//                          print(authCheck['token']);
//
//                          print(userCheck.username);
//                          print(userCheck.isFirstLogin);
//
//                          print(authCheck);
//
//                          if (userCheck.username != "") {
//                            dynamic franchise = json.decode(value)['data']['franchise'];
//                            if(franchise != null){
//                              P.Provider.of<UserProvider>(context,listen: false).setStoreModel(StoreModel.fromJson(franchise));
//                            }
//
//                            P.Provider.of<UserProvider>(context,listen: false).setLoginUser(userCheck);
//                            await P.Provider.of<UserProvider>(context, listen: false).userSync();
////                            if(userCheck.isFirstLogin) {
//////                              P.Provider.of<UserProvider>(context,listen: false).postReco();
////                              Navigator.of(context)
////                                  .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RecoFrst()), (route) => false);
////                            }else {
//                              Navigator.of(context)
//                                  .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainMap()), (route) => false);
////                            }
//                          }
//
////                          await provider
////                              .selectUser(userCheck.username)
////                              .then((value) {
////                            print(value);
////                            dynamic selectUser = json.decode(value);
////                            if (selectUser['data'] != null) {
////                              User user = User.fromJson(selectUser['data']);
////
////                              dataStorage.user = user;
////
////                              Navigator.of(context).pushAndRemoveUntil(
////                                  MaterialPageRoute(
////                                      builder: (context) => Home()),
////                                      (Route<dynamic> route) => false);
////                            } else {
////                              Navigator.of(context).pushAndRemoveUntil(
////                                  MaterialPageRoute(
////                                      builder: (context) => NewSignUp(
////                                        userCheck: userCheck,
////                                      )),
////                                      (Route<dynamic> route) => false);
////                            }
////                          });
//                        });
//                      }
//                    });
//                  }
//                },
              ),
              userCheck
                  ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: white,
                child: Center(
                  child: SpinKitFadingCircle(
                    color: mainColor,
                    size: 80.0,
                  ),
                ),
              )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
