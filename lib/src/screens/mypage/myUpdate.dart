import 'dart:async';

import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as P;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cashcook/src/utils/TextStyles.dart';


class MyUpdate extends StatefulWidget {
  final int authCheck;

  MyUpdate({this.authCheck});

  @override
  _MyUpdate createState() => _MyUpdate();
}

class _MyUpdate extends State<MyUpdate> {
  WebViewController webViewController;

  String url =
        "http://auth.cashlink.kr/auth_api/users/modify/modifyInfo?client_id=cashcook";

  bool isFirstPage = false;
  bool clearCache = false;

  bool userCheck = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    P.Provider.of<UserProvider>(context, listen: false).fetchMyInfo();
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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
        ),
        title: Text("회원정보 수정",
          style: appBarDefaultText
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          //padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top,bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Stack(
            children: [
              WebView(
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (webViewController) {
                  if (!clearCache) {
                    webViewController.clearCache();
                    clearCache = true;
                  }
                  UserProvider userProvider = P.Provider.of<UserProvider>(context,listen: false);
                  UserCheck userCheck = userProvider.loginUser;
                  print(userCheck.name);
                  webViewController.loadUrl(baseUrl + "/users/modify/modifyInfo?client_id=cashcook" + "&username=${userCheck.username}",
                      headers: {"Authorization": "BEARER ${dataStorage.token}"});
                  this.webViewController = webViewController;
                },

                onPageStarted: (url) {
                  if(url == baseUrl && isFirstPage) {
                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      isFirstPage = !isFirstPage;
                    });
                  }
                  print("onPageStarted");
                  print(webViewController.canGoBack().toString());
                  if (url == baseUrl) {
//                  webViewController.clearCache();
                    webViewController.loadUrl(baseUrl + "/users/modify/modifyInfo?client_id=cashcook");
                    if (widget.authCheck != 1) {
                      showToast("회원정보수정에 실패하였습니다.");
                    }
                  }
                },
                onPageFinished: (url) async {
                  print("onPageFinished");
                  print("url : $url");
                  List<String> code = List();
                    if (url == baseUrl + "/users/modify/success") {
                    print(dataStorage.token);
                    Navigator.of(context).pop();
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