
import 'dart:math';

import 'package:cashcook/src/provider/QRProvider.dart';
import 'package:cashcook/src/screens/bargain/bargainresult.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:cashcook/src/screens/mypage/points/pointMgmtUser.dart';
import 'package:cashcook/src/screens/qr/qr.dart';

class BargainGame extends StatefulWidget {
  @override
  _BargainGame createState() => _BargainGame();
}

class _BargainGame extends State<BargainGame> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UnityWidgetController _unityWidgetController;
  var price;
  var discount;
  var bza;
  var rp;

  double percentage;

  List<int> values = List.generate(10, (index) => index);
  bool gameLoad = false;
  int i = 0;
  bool isShow = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: SafeArea(
      body: SafeArea(
        bottom: false,
        key: _scaffoldKey,
        child: Consumer<QRProvider>(
          builder: (context, qrProvider, _) {
            String payDiscount = qrProvider.paymentModel.discount;
            int n_discount = int.parse(payDiscount);
            percentage = n_discount.toDouble() * 0.01;

            print("game start!!!");
            // print("price : ${numberFormat.format(qrProvider.paymentModel.price)}");
            print("price : ${qrProvider.paymentModel.price}");
            print("discount : ${qrProvider.paymentModel.discount}");
            print("bza : ${demicalFormat.format(qrProvider.paymentModel.price * percentage / 100)}");
            print("rp : ${(qrProvider.paymentModel.price / 100000).ceil()*1000}");

            price = qrProvider.paymentModel.price;
            discount = qrProvider.paymentModel.discount;
            bza = demicalFormat.format(qrProvider.paymentModel.price * percentage / 100);
            rp = (qrProvider.paymentModel.price / 100000).ceil() * 1000;
            String temp = price.toString() + "/" + discount.toString() + "/" + bza.toString() + "/" + rp.toString();
            print(temp);
            if(gameLoad) {
              setSendMessage(price, discount, bza, rp);
            }

            // print("^^^");

            return WillPopScope(
              onWillPop: () async {
                showToast("게임이 끝나고 나가실수 있습니다.");
                return Future.value(false);

              },
              child: Container(
                color: Colors.yellow,
                child: UnityWidget(
                  onUnityViewCreated: onUnityCreated,
                  onUnityMessage: onUnityMessage,
                  onUnityUnloaded: onUnityUnloaded,
                ),
              ),
            );
          },
        ),
      ),
    );

  }

  void onUnityCreated(controller) {
    this._unityWidgetController = controller;
    setState(() {
      gameLoad = true;
    });
  }

  void onUnityUnloaded(controller){
    this._unityWidgetController = null;
  }

  void setSendMessage(price, discount, bza, rp) {
    print("sendStart");
    String message = price.toString() + "/" + discount.toString() + "/" + bza.toString() + "/" + rp.toString();
    _unityWidgetController.postMessage(
        'Main',
        'SetUserInfo',
        message
    );
    print("sendEnd");
  }

  void onUnityMessage(controller, message) {
    if(message.toString() == "quit"){ //나가기
      print("나가기");
       Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => pointMgmtUser(
            afterGame: true,
          )),);
    } else{ // 한번더하기
      print("한번더");
      var list = ['10','20','30','40','50','60','70','80','90','100'];
      final _random = new Random();
      var randomDiscount = list[_random.nextInt(list.length)];
      var randomPercentage = int.parse(randomDiscount).toDouble() * 0.01;
      print(price.toString());
      print(randomDiscount.toString());
      print((price * randomPercentage / 100).toString());
      print(rp.toString());

      setSendMessage(price.toString(), randomDiscount.toString(), demicalFormat.format(price * randomPercentage / 100).toString(), rp.toString());
    }
  }

}
