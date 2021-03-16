import 'dart:async';

import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/provider/GameProvider.dart';
import 'package:cashcook/src/screens/main/home.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:provider/provider.dart';

class NewBargain extends StatefulWidget {
  @override
  NewBargainState createState() => NewBargainState();
}

class NewBargainState extends State<NewBargain> {
  Timer _timer;
  UnityWidgetController _unityWidgetController;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // body: SafeArea(
      body: Consumer<GameProvider>(
        builder: (context, gp, _){
          // 나가기
          if(gp.isQuit) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => Home()
                  ), (route) => false
              );
            });
          }

          // 리플레이
          if(gp.isReplay) {
            String message = "10000/10000/1/1/1/1/1/1";
            _unityWidgetController.postMessage(
                'Main',
                'SetUserInfo_Pay',
                message
            );
          }

          return SafeArea(
              bottom: false,
              child:
              WillPopScope(
                  onWillPop: () async {
                    showToast("게임이 끝나고 나가실수 있습니다.");
                    return Future.value(true);
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          color: black,
                          child: UnityWidget(
                            onUnityViewCreated: onUnityCreated,
                            onUnityMessage: onUnityMessage,
                            safeMode: true,
                          ),
                        ),
                      ),
                      gp.isLoading ? Positioned.fill(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset("assets/icon/game-loading.png",
                                  width: 208,
                                  height: 193,
                                ),
                                whiteSpaceH(40),
                                CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(white)
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: primary
                            ),
                          )
                      ) : Container()
                    ],
                  )
              )
          );
        },
      ),
    );
  }

  void onUnityCreated(controller) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<CenterProvider>(context, listen: false).enterGame();
    });

    this._unityWidgetController = controller;
  }

  void onUnityMessage(controller, message) async {
    if (message.toString() == "quit") { //나가기
      print("나가기");
      if (mounted) {
        Provider.of<GameProvider>(context, listen: false).quitGame();
      }
    } else if (message.toString() == "Recharge") { // 캐럿 부족
      print("캐럿 부족");
    } else if (message.toString() == "LoadingComplete") {
      print("로딩 완료");
      _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
        if (timer.tick >= 3) {
          if (mounted) {
            print("돈다");
            Provider.of<GameProvider>(context, listen: false).stopLoading();
            setState(() {
              _timer.cancel();
            });
          }
        }
      });
    } else { // 한번더하기
      print("한번더");
      if (mounted) {
        print("돈다");
        Provider.of<GameProvider>(context, listen: false).replayGame();
      }
    }
  }
}