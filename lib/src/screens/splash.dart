import 'dart:async';

import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/screens/login/loginVerRest.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: black,
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(
               "assets/resource/main/splash_apple.png",
                fit: BoxFit.fill
              )
          ),
          Positioned.fill(
              child: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("실시간 스토어 할인 앱",
                        style: Subtitle2.apply(
                          color: white,
                          fontWeightDelta: 1
                        )
                      ),
                      Image.asset(
                      "assets/icon/cashcook_logo.png",
                      width: 180,
                      height: 53.33,
                      ),
                    ],
                    )
                ),
              )
          ),
          Positioned(
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.only(bottom: 45),
              child: Container(
                width: MediaQuery.of(context).size.width,
                  child: Text(
                      "Copyright ⓒ 2020 CashCook Inc. All Rights Reserved.",
                    textAlign: TextAlign.center,
                    style: Caption.apply(
                      color: white,
                      fontWeightDelta: 1
                    )
                  ),
               ),
              )
          )
        ],
      )
        );
  }

  pageMove() async {
    await Provider.of<StoreProvider>(context, listen: false).clearMap();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
        // .pushReplacement(MaterialPageRoute(builder: (context) => LoginVerRest()));
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
