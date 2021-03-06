import 'package:cashcook/src/provider/provider.dart';
import 'package:cashcook/src/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:cashcook/src/services/API.dart';

class Logout extends StatefulWidget {
  final int authCheck;

  Logout({this.authCheck});

  @override
  _Logout createState() => _Logout();
}

class _Logout extends State<Logout>{
  WebViewController webViewController;
  FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();

  bool clearCache = false;
  bool userCheck = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    flutterWebviewPlugin.onUrlChanged.listen((String s) async {
      print("flutterWebviewPlugin.onUrlChanged");

      if(webViewController != null) {
        webViewController.clearCache();
        webViewController.loadUrl(baseUrl + "/users/logout");
      }
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
                    print("onWebViewCreated123");
                    webViewController.loadUrl(baseUrl + "/users/logout");
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