import 'dart:async';

import 'package:cashcook/src/utils/colors.dart';
import 'package:flutter/material.dart';

import 'login/login.dart';

class Splash extends StatefulWidget {
  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icon/splash.png",
              width: 56,
              fit: BoxFit.contain,
            )
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
