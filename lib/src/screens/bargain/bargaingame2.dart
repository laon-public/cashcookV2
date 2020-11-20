
import 'dart:math';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
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
  final dynamic orderPayment;
  final dynamic totalCarat;

  BargainGame2({this.orderId=0, this.orderPayment, this.totalCarat});

  @override
  _BargainGame2 createState() => _BargainGame2();
}

class _BargainGame2 extends State<BargainGame2> {
  dynamic orderPayment;
  dynamic totalCarat;

  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UnityWidgetController _unityWidgetController;
  var price;
  var discount;
  var dl;
  var carat;

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
    print("BargainGame initState");
    orderPayment = widget.orderPayment;
    totalCarat = widget.totalCarat;
    print("orderPayment $orderPayment");
    print("total_carat $totalCarat");
    DefaultCacheManager().emptyCache();
    _unityWidgetController = null;
    super.initState();
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
          print("replay totalCarat : $totalCarat");
          totalCarat = totalCarat - carat;
          print("replay2 totalCarat : $totalCarat");
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
                    color: Colors.yellow,
                    child: UnityWidget(
                      onUnityViewCreated: onUnityCreated,
                      onUnityMessage: onUnityMessage,
                      onUnityUnloaded: onUnityUnloaded,
                      safeMode: true,
                    ),
                  ),
                  ),
                  // Positioned.fill(
                  //   child: Opacity(
                  //     opacity: 0.7,
                  //     child: Container(
                  //       color: Colors.black,
                  //     ),
                  //   )
                  // ),
                  // Center(
                  //           child: Container(
                  //               width: MediaQuery.of(context).size.width * 3/4,
                  //               height: MediaQuery.of(context).size.height * 2/4,
                  //               child: Center(
                  //                   child: CircularProgressIndicator(
                  //                       backgroundColor: mainColor,
                  //                       valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
                  //                   )
                  //               ),
                  //             decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //               borderRadius: BorderRadius.all(
                  //                 Radius.circular(20.0)
                  //               )
                  //             ),
                  //
                  //     )
                  // )
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

  void setSendMessage() {
    final _random = new Random();
    var randomDiscount = this.list[_random.nextInt(list.length)];
    print("randomDiscount : $randomDiscount");
    var randomPercentage = int.parse(randomDiscount).toDouble() * 0.01;
    print("randomPercentage : $randomPercentage");

    dl = double.parse((widget.orderPayment * randomPercentage / 100).toString()).round();
    // rp = (widget.orderPayment / 100000).ceil() * 1000;
    discount = demicalFormat.format(randomPercentage * 100);

    print("orderPayment : ${widget.orderPayment}");
    print("discount : $discount");
    print("dl : $dl");
    print("carat : $carat");
    print("total_carat : $totalCarat");

    String message = widget.orderPayment.toString() + "/" + discount.toString() + "/" + dl.toString() + "/" + carat.toString() + "/" + totalCarat.toString();
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


    } else{ // 한번더하기
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