
import 'dart:math';

import 'package:cashcook/src/provider/QRProvider.dart';
import 'package:cashcook/src/screens/bargain/bargainresult.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/screens/mypage/info/serviceList.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:cashcook/src/screens/mypage/points/pointMgmtUser.dart';
import 'package:cashcook/src/screens/qr/qr.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// QR코드로 진행한 실시간 흥정 게임
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
  bool isQuit = false;
  bool isReplay = false;
  int i = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    print("BargainGame Start");
    DefaultCacheManager().emptyCache();
    print("DefaultCacheManager().emptyCache()");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if(isQuit) {
        await Provider.of<QRProvider>(context,listen: false).confirmPayment(
          false,
          Provider.of<QRProvider>(context,listen: false).paymentModel.uuid
        );
        print("_unityWidgetController.pause()");
        _unityWidgetController.pause();

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ServiceList(
          isHome: true,
          afterGame : true,
        )), (route) => false);
        return;
      }

      if(isReplay) {
        bool res = await Provider.of<QRProvider>(context, listen: false)
            .discountPayment(
            Provider
                .of<QRProvider>(context, listen: false)
                .paymentModel
                .uuid
        );
        if (!res) {
          await Provider.of<QRProvider>(context, listen: false).confirmPayment(
            false,
              Provider
                  .of<QRProvider>(context, listen: false)
                  .paymentModel
                  .uuid
          );

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) =>
                  ServiceList(
                    isHome: true,
                    afterGame: true,
                  )), (route) => false);
        }
        return;
      }
    });
    return Scaffold(
      // body: SafeArea(
      body: SafeArea(
        bottom: false,
        key: _scaffoldKey,
        child:
        Consumer<QRProvider>(
          builder: (context, qrProvider, _) {
            String payDiscount = qrProvider.paymentModel.discount;
            print(payDiscount);
            int n_discount = int.parse(payDiscount);
            print(n_discount);
            percentage = n_discount.toDouble() * 0.01;
            print(percentage);

            print("game start!!!");
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
                  safeMode: true,
                ),
              ),
            );
          },
        ),
      ),
    );

  }

  void onUnityCreated(controller) {
    print("onUnityCreated1");
    this._unityWidgetController = controller;
    setState(() {
      print("onUnityCreated2");
      gameLoad = true;
    });
  }

  void onUnityUnloaded(controller){
    print("onUnityUnloaded");
    this._unityWidgetController = null;
  }

  void setSendMessage(price, discount, bza, rp) {
    print("sendStart");
    print(_unityWidgetController.toString());
    String message = price.toString() + "/" + discount.toString() + "/" + bza.toString() + "/" + rp.toString();
    _unityWidgetController.postMessage(
        'Main',
        'SetUserInfo_QR',
        message
    );
    print("sendEnd");

  }

  void onUnityMessage(controller, message) {
    if(message.toString() == "quit"){ //나가기
      print("나가기");

      if(this.mounted) {
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

}
