import 'package:cashcook/src/provider/provider.dart';
import 'package:cashcook/src/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/utils/datastorage.dart';

class Logout extends StatefulWidget {
  final int authCheck;

  Logout({this.authCheck});

  @override
  _Logout createState() => _Logout();
}

class _Logout extends State<Logout>{
  WebViewController webViewController;
  FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();

  String logoutUrl = "http://192.168.100.219/auth_api/users/logout";
//  String logoutUrl = "http://auth.cashlink.kr/auth_api/users/logout";
  bool clearCache = false;
  bool userCheck = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    flutterWebviewPlugin.onUrlChanged.listen((String logoutUrl) async {
      print("flutterWebviewPlugin.onUrlChanged");
      webViewController.clearCache();
      webViewController.loadUrl(this.logoutUrl);
//        await provider.authToken().then((value) async {
//            dynamic authToken = null;
//            dataStorage.token = authToken['access_token'];
//          }
      });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("Widget build123");
    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: true,
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
                  onWebViewCreated: (webViewController) {
                    webViewController.loadUrl("http://192.168.100.219/auth_api/users/logout");
//                    webViewController.loadUrl("http://auth.cashlink.kr/auth_api/users/logout");
                  },

                  onPageStarted: (url) {
                    dataStorage.token = null;
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) => Splash()));
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

}