import 'dart:async';

import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/dialog.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Colors.yellow,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Center(
//                mainAxisAlignment: MainAxisAlignment.center,
//                crossAxisAlignment: CrossAxisAlignment.center,
              child: Image.asset(
                "assets/icon/splash.png",
                height: 150,
                width: 200,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                "assets/icon/dog.png",
                alignment: Alignment.bottomRight,
                height: 200,
                width: 250,
                fit: BoxFit.contain,
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
          ],
        ),
      ),
    );
  }

  pageMove() {
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
