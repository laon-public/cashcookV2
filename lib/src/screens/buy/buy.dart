import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/bargain/bargain.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/dialog.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Buy extends StatefulWidget {

  final String name;
  final int pay;
   String id;
   int quantity;
  String paymentType;

  Buy({this.name, this.pay, this.id, this.quantity,
      this.paymentType}); //  Buy({this.name, this.pay});


  @override
  _Buy createState() => _Buy();
}

class _Buy extends State<Buy> {
  AppBar appBar;
  String buyerName = "테스트";
  String buyerTel = "010-1234-5678";
  WebViewController webViewController;

  bool ispOn = false;

  @override
  void initState() {
    super.initState();
    buyerName = widget.name;

  }

  dialogPop() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (context) => MainMap()
    ), (route) => false);
  }

  bargainMove() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (context) => Bargain()
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
        title: Text("결제하기", style: TextStyle(
          fontSize: 14, fontFamily: 'noto', fontWeight: FontWeight.w600, color: black
        ),),
      ),
      initialChild: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom -
            appBar.preferredSize.height,
        child: Center(
          child: ispOn
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                )
              : Container(),
        ),
      ),
      userCode: "imp95610586",
      data: PaymentData.fromJson({
        'pg': 'inicis',
        'payMethod': 'card',
        'name': '캐시쿡 결제',
        'merchantUid': 'mid_${DateTime.now().millisecondsSinceEpoch}',
        'amount': 100,
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
          print(widget.id);
          print(widget.quantity);
          print(widget.paymentType);
          bool response =
          await Provider.of<UserProvider>(context, listen: false)
              .postCharge(
              widget.id, widget.quantity, widget.paymentType);
          if (!response) {
            Fluttertoast.showToast(msg: "에러");
          } else {
            Fluttertoast.showToast(msg: "충전이 완료되었습니다.");
          }
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MainMap()),
                  (route) => false);
//          dialog(
//              title: "결제안내",
//              context: context,
//              content: "라온치킨에서\n${numberFormat.format(10000)}원을 결제하셨습니다.",
//              sub: "실시간 흥정하기로 가시겠습니까?",
//              selectOneText: "취소",
//              selectOneVoid: () => dialogPop(),
//              selectTwoText: "결제",
//              selectTwoVoid: () => bargainMove()
//          );

        } else {
          showToast("결제를 실패하였습니다.");
          Navigator.of(context).pop();
        }
      },
    );
  }
}
