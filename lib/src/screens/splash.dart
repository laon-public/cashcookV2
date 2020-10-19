import 'dart:async';

import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login/login.dart';

class Splash extends StatefulWidget {
  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> {

  qrCreate(type) {
    print("type : " + type);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child:
             Center(
                child: Image.asset(
                  "assets/icon/splash2.png",
                  height: 249,
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ),
            )
//            Expanded(
//                child: dialog(
//                    title: "앱버전 안내",
//                    content: "최신버전이 있습니다.\n지금 업데이트 하시겠습니까?",
//                    sub: "",
//                    context: context,
//                    selectOneText: "예",
//                    selectTwoText: "아니요",
//                    selectOneVoid: () => qrCreate(0),
//                    selectTwoVoid: () => qrCreate(1)
//                ),
//            ),
        );
  }

  pageMove() async {
    await Provider.of<StoreProvider>(context, listen: false).clearMap();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(
        _duration, pageMove
        );
  }

  @override
  void initState() {
    super.initState();

    startTime();
  }
}
