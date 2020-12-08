
import 'dart:math';
import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cashcook/src/screens/mypage/info/serviceList.dart';
import 'dart:core';

// 선결제로 진행한 실시간 흥정 게임
class BargainGame2 extends StatefulWidget {
  int orderId;
  final int orderPayment;
  int totalCarat;

  BargainGame2({this.orderId=0, this.orderPayment, this.totalCarat});

  @override
  _BargainGame2 createState() => _BargainGame2();
}

class _BargainGame2 extends State<BargainGame2> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UnityWidgetController _unityWidgetController;
  int dl;
  int carat;

  List<int> values = List.generate(10, (index) => index);
  bool gameLoad = false;
  bool isQuit = false;
  bool isReplay = false;
  bool isShow = true;

  @override
  void dispose() {
    print("dispose");
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("BargainGame initState");
    print("orderPayment ${widget.orderPayment}");
    print("total_carat ${widget.totalCarat}");
    Provider.of<CenterProvider>(context, listen: false).enterGame();
    DefaultCacheManager().emptyCache();
    _unityWidgetController = null;
    gameLoad = false;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if(isQuit) {
        await Provider.of<StoreServiceProvider>(context, listen: false).confirmGame(
            orderId: widget.orderId,
            gameQuantity: dl
        );

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ServiceList(
          isHome: true,
          afterGame : true,
        )), (route) => false);

        return;
      }

      // 다시하기를 고려해 캐럿값은 미리구함
      carat = caratReword(widget.orderPayment);

      if(isReplay){
        bool res = await Provider.of<StoreServiceProvider>(context, listen: false).replayGame(
            orderId: widget.orderId
        );

        if(res) {
          // 다시하기 할때마다 캐럿값의 최신화
          print("replay carat : $carat");
          print("replay totalCarat : ${widget.totalCarat}");
          widget.totalCarat = widget.totalCarat - carat;
          print("replay2 totalCarat : ${widget.totalCarat}");
          setSendMessage();
        } else {
          _unityWidgetController.pause();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ServiceList(
            isHome: true,
            afterGame : true,
          )), (route) => false);
        }

        await Provider.of<CenterProvider>(context, listen: false).getFunds(widget.orderPayment);

        return;
      }

      if(gameLoad) {
        await Provider.of<CenterProvider>(context, listen: false).getFunds(widget.orderPayment);
        print("gameLoad Start");
        setSendMessage();
        return;
      }
    });


    return Scaffold(
      // body: SafeArea(
      body: SafeArea(
        bottom: false,
        key: _scaffoldKey,
        child:
        WillPopScope(
              onWillPop: () async {
                showToast("게임이 끝나고 나가실수 있습니다.");
                return Future.value(false);

              },
              child: isQuit ? Container() : Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                    color: black,
                    child: UnityWidget(
                      onUnityViewCreated: onUnityCreated,
                      onUnityMessage: onUnityMessage,
                      onUnityUnloaded: onUnityUnloaded,
                      safeMode: true,
                    ),
                  ),
                  ),
                  Consumer<CenterProvider>(
                    builder: (context, cp, _){
                      return Positioned(
                        top: 20,
                        child: Container(

                          padding: EdgeInsets.symmetric(horizontal: 22),
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "금일 재원 : ${numberFormat.format(int.parse(cp.hojoFunds == "" ? "0" : cp.hojoFunds))}원 ㆍ "
                                        "당첨 한도 : ${cp.limitGamePercentage}%",
                                    style: Body2.apply(
                                      color: white,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 1.0,
                                          color: black
                                        ),
                                      ]
                                    )
                                  ),
                                  Text("")
                                ],
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.topLeft,
                                  colors: [
                                    Colors.transparent,
                                    black.withOpacity(0.3),
                                    black.withOpacity(0.3),
                                    Colors.transparent,
                                  ]
                                ),
                              ),
                            ),
                          )
                        ),
                      );
                    },
                  ),
                  Consumer<CenterProvider>(
                    builder: (context, cp, _){
                      return Positioned(
                        top: 50,
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 22),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        "금일 이용자 수 : ${numberFormat.format(int.parse(cp.gameUserQuantity))}명",
                                        style: Body2.apply(
                                            color: white,
                                            shadows: [
                                              Shadow(
                                                  offset: Offset(1, 1),
                                                  blurRadius: 1.0,
                                                  color: black
                                              ),
                                            ]
                                        )
                                    ),
                                    Text("")
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.topLeft,
                                      colors: [
                                        Colors.transparent,
                                        black.withOpacity(0.3),
                                        black.withOpacity(0.3),
                                        Colors.transparent,
                                      ]
                                  ),
                                ),
                              ),
                            )
                        ),
                      );
                    },
                  ),
                  // (!gameLoad) ? Positioned.fill(
                  //     child: Opacity(
                  //       opacity: 0.7,
                  //       child: Container(
                  //           width: MediaQuery.of(context).size.width,
                  //           height: MediaQuery.of(context).size.height,
                  //           color: black
                  //       ),
                  //     )
                  // ) : Container(),
                  // (!gameLoad) ? Center(
                  //   child: Container(
                  //       width: MediaQuery.of(context).size.width * 3/4,
                  //       height: MediaQuery.of(context).size.height * 2/4,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.all(
                  //           Radius.circular(20.0)
                  //         ),
                  //         color: white,
                  //       ),
                  //       child: Center(
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             Image.asset(
                  //               "assets/icon/study_payment.png",
                  //               width: 100,
                  //               height: 100,
                  //               fit: BoxFit.fill,
                  //             ),
                  //             whiteSpaceH(16.0),
                  //             Text("게임이 켜지는 중 입니다.\n"
                  //                 "잠시만 기다려주세요.",
                  //                 style: TextStyle(
                  //                   fontSize: 14,
                  //                   fontFamily: 'noto',
                  //                   color: Color(0xFF333333),
                  //                 ),
                  //               textAlign: TextAlign.center,
                  //             )
                  //           ],
                  //         )
                  //       ),
                  //   ),
                  // ) : Container()
                ],
              )
            )
        ),
      );

  }

  void onUnityCreated(controller) {
    showToast("게임이 실행되는 중 입니다.");
    this._unityWidgetController = controller;

    if(this.mounted) {
      setState(() {
        gameLoad = true;
      });
    }
  }

  void onUnityUnloaded(controller){
    this._unityWidgetController = null;
  }

  void setSendMessage() async {
    final Random random = new Random();
    List<String> list = [];
    int limitPercentage = Provider.of<CenterProvider>(context, listen: false).limitGamePercentage;
    print("limitPercentage : $limitPercentage");
    Map<String, int> percentageMap = {};
    for(int per=10; per<=100; per += 10){
      if(per <= limitPercentage) {
        percentageMap.addAll({
          "$per": (((per - 1) / 30).floor()) + 1
        });
        list.add("$per");
      } else {
        break;
      }
    }
    print("percentageMap.toString");
    print(percentageMap.toString());

    String selRandom;
    do {
      selRandom = list[random.nextInt(list.length)];

      print("계산 값 : $selRandom");
      percentageMap[selRandom]--;
    } while(percentageMap[selRandom] != 0);
    String randomDiscount = selRandom;
    print("randomDiscount : $randomDiscount");
    double randomPercentage = int.parse(randomDiscount).toDouble() * 0.01;
    print("randomPercentage : $randomPercentage");

    dl = double.parse((widget.orderPayment * randomPercentage / 100).toString()).round();
    // rp = (widget.orderPayment / 100000).ceil() * 1000;
    // discount = demicalFormat.format(randomPercentage * 100);

    print("orderPayment : ${widget.orderPayment}");
    print("discount : $randomDiscount");
    print("dl : $dl");
    print("carat : $carat");
    print("total_carat : ${widget.totalCarat}");

    String message = widget.orderPayment.toString() + "/" + randomDiscount.toString() + "/" + dl.toString() + "/" + carat.toString() + "/" + widget.totalCarat.toString();
    _unityWidgetController.postMessage(
        'Main',
        'SetUserInfo_Pay',
        message
    );
    print("sendEnd");
  }

  void onUnityMessage(controller, message) async {
    if(message.toString() == "quit"){ //나가기
      print("나가기");
      if(this.mounted){
        setState(() {
          isReplay = false;
          isQuit = true;
        });
      }
    } else if(message.toString() == "Recharge") { // 캐럿 부족
      print("캐럿 부족");
    } else { // 한번더하기
      print("한번더");
      if(this.mounted) {
        setState(() {
          isReplay = true;
        });
      }

    }
  }

  int caratReword(orderPayment) {
    int carat;

    if(orderPayment < 30000){
      carat = 2;
    } else if(orderPayment < 50000){
      carat = 3;
    } else if(orderPayment < 100000){
      carat = 5;
    } else if(orderPayment < 500000){
      carat = 10;
    } else {
      carat = 20;
    }

    return carat;
  }

}