
import 'dart:math';

import 'package:cashcook/src/provider/QRProvider.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:cashcook/src/screens/mypage/points/pointMgmtUser.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cashcook/src/screens/mypage/info/serviceList.dart';

// 선결제로 진행한 실시간 흥정 게임
class BargainGame2 extends StatefulWidget {
  int orderId;
  final dynamic orderPayment;

  BargainGame2({this.orderId=0, this.orderPayment});

  @override
  _BargainGame2 createState() => _BargainGame2();
}

class _BargainGame2 extends State<BargainGame2> {
  dynamic orderPayment;

  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UnityWidgetController _unityWidgetController;
  var price;
  var discount;
  var bza;
  var rp;


  var list = ['10','20','30','40','50','60','70','80','90','100'];
  final random = new Random();
  var randomDiscount;
  var randomPercentage;

  double percentage;

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
    print("BargainGame2 Start");
    orderPayment = widget.orderPayment;
    print("orderPayment");
    print(orderPayment);
    DefaultCacheManager().emptyCache();
    print("DefaultCacheManager().emptyCache()");
    _unityWidgetController = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if(isQuit) {
        await Provider.of<StoreServiceProvider>(context, listen: false).confirmGame(
            orderId: widget.orderId,
            gameQuantity: int.parse(bza.toString())
        );

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ServiceList(
          isHome: true,
          afterGame : true,
        )), (route) => false);

        return;
      }

      if(isReplay){
        bool res = await Provider.of<StoreServiceProvider>(context, listen: false).replayGame(
            orderId: widget.orderId
        );

        if(res) {
          setSendMessage();
        } else {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ServiceList(
            isHome: true,
            afterGame : true,
          )), (route) => false);
        }

        return;
      }

      if(gameLoad) {
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
              child: isQuit ? Container() : Container(
                color: Colors.yellow,
                child: UnityWidget(
                  onUnityViewCreated: onUnityCreated,
                  onUnityMessage: onUnityMessage,
                  onUnityUnloaded: onUnityUnloaded,
                  safeMode: true,
                ),
              ),
            )
        ),
      );

  }

  void onUnityCreated(controller) {
    showToast("게임이 실행되는 중 입니다.");
    this._unityWidgetController = controller;

    setState(() {
      gameLoad = true;
    });
  }

  void onUnityUnloaded(controller){
    this._unityWidgetController = null;
  }

  void setSendMessage() {
    final _random = new Random();
    var randomDiscount = this.list[_random.nextInt(list.length)];
    var randomPercentage = int.parse(randomDiscount).toDouble() * 0.01;
    bza = demicalFormat.format(widget.orderPayment * randomPercentage / 100);
    rp = (widget.orderPayment / 100000).ceil() * 1000;
    discount = demicalFormat.format(randomPercentage * 100);

    print(widget.orderPayment.toString());
    print(randomDiscount.toString());
    print((widget.orderPayment * randomPercentage / 100).toString());
    print(rp.toString());

    String message = widget.orderPayment.toString() + "/" + discount.toString() + "/" + bza.toString() + "/" + rp.toString();
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

      setState(() {
        isReplay = false;
        isQuit = true;
      });

    } else{ // 한번더하기
      print("한번더");

      setState(() {
        isReplay = true;
      });
    }
  }

}
