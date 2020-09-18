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
