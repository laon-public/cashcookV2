import 'dart:convert';

import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/services/IMPort.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:provider/provider.dart' as P;
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cashcook/src/screens/bargain/bargaingame2.dart';
import 'package:cashcook/src/screens/mypage/info/serviceList.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

class Buy extends StatefulWidget {
  final String name;
  final int pay;
  String id;
  String point;
  int quantity;
  String paymentType;
  int dl;
  bool isPlayGame;

  Buy({this.name, this.pay, this.id, this.point, this.quantity,
      this.paymentType, this.dl, this.isPlayGame = false}); //  Buy({this.name, this.pay});


  @override
  _Buy createState() => _Buy();
}

class _Buy extends State<Buy> {
  AppBar appBar;

  String buyerName = "";
  String buyerTel = "";
  String buyerEmail = "";
  WebViewController webViewController;

  IMPortService imPortService;

  bool ispOn = false;

  @override
  void initState() {
    super.initState();
    buyerName = widget.name;
    UserProvider userProvider = P.Provider.of<UserProvider>(context,listen: false);
    UserCheck user = userProvider.loginUser;

    buyerName = user.name;
    buyerTel = user.phone;

    imPortService = IMPortService();
  }

  dialogPop() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (context) => MainMap()
    ), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return IamportPayment(
      appBar: appBar = AppBar(
        backgroundColor: white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
        ),
        centerTitle: true,
        elevation: 1.0,
        title: Text("결제하기",
            style: appBarDefaultText
        ),
      ),
      initialChild: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom -
            appBar.preferredSize.height,
        child: Center(
          child: ispOn
              ? Center(
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
                    )
                )
              : Container(),
        ),
      ),
      userCode: 'imp05615202',
      data: PaymentData.fromJson({
        'pg': 'inicis',
        'payMethod': 'card',
        'name': (widget.paymentType.contains("ORDER")) ? '캐시쿡 결제' : '${widget.point} 카드 충전',
        'merchantUid': 'mid_${DateTime.now().millisecondsSinceEpoch}',
        'amount': widget.pay,
        'buyerName': buyerName,
        'buyerTel': buyerTel,
        'buyerEmail': "",
        'buyerAddr': "주소",
        'buyerPostcode': "",
        'appScheme': "cashcook"
      }),
      callback: (Map<String, String> result) async {
        if (result['imp_success'] == "true") {
          setState(() {
            ispOn = true;
          });

          print("IMPORT UID!!!! ${result['imp_uid']}");
          print("IMPORT 주문번호!!! ${result['merchant_uid']}");
          print(widget.id);
          print(widget.quantity);
          print(widget.paymentType);

          dynamic response = await imPortService.getIMPORTToken();
          Map<String, dynamic> json = jsonDecode(response);

          String token = json['response']['access_token'];
          response = await imPortService.getIMPortHistory(result['imp_uid'], token);

          json = jsonDecode(response);
          String cardName = json['response']['card_name'];
          String cardNumber = json['response']['card_number'];

          P.Provider.of<StoreServiceProvider>(context, listen: false).setBankInfo(cardName, cardNumber);

          if(widget.paymentType.contains("ORDER")) {
            await Provider.of<StoreServiceProvider>(context, listen: false).setOrderMap(widget.id, "ORDER").then((value) {
              if (value) {
                Provider.of<StoreServiceProvider>(context, listen: false).orderComplete();
                Fluttertoast.showToast(msg: "결제가 완료되었습니다.");
              } else {
                Fluttertoast.showToast(msg: "에러");
              }
            });

            Map<String, dynamic> pointMap =  Provider.of<UserProvider>(context, listen: false).pointMap;
            if(widget.isPlayGame){
              print("CARAT : ${pointMap['CARAT']}");
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (context) => BargainGame2(
                  orderPayment: widget.pay,
                  totalCarat: pointMap['CARAT']
                )
              ), (route) => false);
            } else {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (context) => ServiceList(
                    isHome : true, afterGame : true,
              )), (routes) => false);
            }
          } else {
            bool response =
            await Provider.of<UserProvider>(context, listen: false)
                .postCharge(
                widget.id, widget.point, widget.quantity, widget.paymentType, widget.dl);
            if (!response) {
              Fluttertoast.showToast(msg: "에러");
            } else {
              await Provider.of<UserProvider>(context, listen:false).fetchMyInfo();
              await Provider.of<UserProvider>(context, listen: false).getAccountsHistory(widget.point, 0);

              Fluttertoast.showToast(msg: "충전이 완료되었습니다.");
            }

            Navigator.of(context).pop();
          }

        } else {
          showToast("결제를 실패하였습니다.");
          Navigator.of(context).pop();
        }
      },
    );
  }
}
