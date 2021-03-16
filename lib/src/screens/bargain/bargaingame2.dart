
import 'dart:async';
import 'dart:math';
import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
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

  Timer _timer;
  var _time = 0;
  var _isLoading = true;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("BargainGame initState");
    print("orderPayment ${widget.orderPayment}");
    print("total_carat ${widget.totalCarat}");
    DefaultCacheManager().emptyCache();
    _unityWidgetController = null;
    gameLoad = false;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if(isQuit) {
        print("나가기 들어옴");
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


    return
      Scaffold(
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
                    _isLoading ? Positioned.fill(
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
          ),
        );

  }

  void onUnityCreated(controller) {
    showToast("게임이 실행되는 중 입니다.");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<CenterProvider>(context, listen: false).enterGame();
      setState(() {
        gameLoad = true;
      });
    });
    this._unityWidgetController = controller;

  }

  void onUnityUnloaded(controller){
    this._unityWidgetController = null;
    print("들어옴");
  }

  void setSendMessage() async {
    final Random random = new Random();
    List<String> list = [];
    int limitPercentage = Provider.of<CenterProvider>(context, listen: false).limitGamePercentage;
    String _userQuantity = Provider.of<CenterProvider>(context, listen: false).gameUserQuantity;
    String funds = Provider.of<CenterProvider>(context, listen: false).hojoFunds;
    print("limitPercentage : $limitPercentage");

    String userQuantity = (int.parse(_userQuantity) % 500).toString();


    // 추가해야 하는 부분
    // 재원 안에서 터지기
    // 100 단위로 고정 percentage
    print("======================new Game_Version2=========================");

    userQuantity = (int.parse(_userQuantity) % 500).toString();
    Map<String, String> userQuantityPercentageMapV2 = {
      "100" : "5",
      "200" : "6",
      "300" : "7",
      "400" : "8",
      "0" : "9",
    };

    String initPerV2 = "1";
    if(userQuantityPercentageMapV2[userQuantity] != null && (int.parse(userQuantityPercentageMapV2[userQuantity]) + 10) <= limitPercentage) {
      initPerV2 = userQuantityPercentageMapV2[userQuantity];
    }

    List<String> tenPerList = ["1","2","3","4","5","6","7","8","9","10"];
    List<int> onePerList = [0,1,2,3,4,5,6,7,8,9];
    Map<String, int> perMapV2 = {
      "1" : 1,
      "2" : 1,
      "3" : 1,
      "4" : 2,
      "5" : 2,
      "6" : 2,
      "7" : 3,
      "8" : 3,
      "9" : 3,
      "10" : 4
    };

    String tenPerInit;
    if(initPerV2 != "1"){
      // 고정 퍼센트가 정해진거 (Case 2)
      tenPerInit = initPerV2;

      if(tenPerInit == "9") {
        onePerList = [0,1,2,3,4,5,6,7,8,9,10];
      } else {
        onePerList = [0,1,2,3,4,5,6,7,8,9];
      }
    } else {
      // 재원 안에서 터지도록 list 구성 (아직 안됨)
      tenPerList.clear();
      for(int i=10;i< limitPercentage; i++){
        tenPerList.add((i/10).ceil().toString());
      }

      String randomPick;
      do {
        randomPick = tenPerList[random.nextInt(tenPerList.length)];

        perMapV2[randomPick]--;
      } while(perMapV2[randomPick] != 0);
      tenPerInit = randomPick;
    }

    int onePerInit = onePerList[random.nextInt(onePerList.length)];
    int resPer;

    if(tenPerInit == "10") {
      resPer = 100;
    } else {
      resPer = (int.parse(tenPerInit) * 10) + onePerInit;
    }

    dl = ((widget.orderPayment * 1 / 100) * resPer / 100).round();

    print("총 결제 ===> ${widget.orderPayment.toString()}");
    print("할인율 ===> $resPer");
    print("DL ===> $dl");


    String message = widget.orderPayment.toString() + "/" + resPer.toString() + "/" + dl.toString() + "/" + carat.toString() + "/" + widget.totalCarat.toString() + "/" + funds + "/" + limitPercentage.toString();
    _unityWidgetController.postMessage(
        'Main',
        'SetUserInfo_Pay',
        message
    );
    _start();
  }

  void onUnityMessage(controller, message) async {
    if(message.toString() == "quit"){ //나가기
      print("나가기");
      if(this.mounted) {
        setState(() {
          isReplay = false;
          isQuit = true;
        });
      }
    } else if(message.toString() == "Recharge") { // 캐럿 부족
      print("캐럿 부족");
    } else if(message.toString() == "LoadingComplete"){
      _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
        if(timer.tick >= 1) {
          if(this.mounted){
            setState(() {
              _isLoading = false;
              _timer.cancel();
            });
          }
        }
      });
    } else { // 한번더하기
      print("한번더");
      if(mounted){
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

  void _start() {
    setState(() {
      _isLoading = true;
      isReplay = false;
      gameLoad = false;
    });
    // _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
    //   if(timer.tick == 5) {
    //     setState(() {
    //       _isLoading = false;
    //       _timer.cancel();
    //     });
    //   }
    // });
  }
}