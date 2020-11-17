import 'package:cashcook/src/model/payment.dart';
import 'package:cashcook/src/provider/QRProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/bargain/bargaingame2.dart';
import 'package:cashcook/src/screens/mypage/info/serviceList.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/dialog.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QrPayment extends StatefulWidget {
  final String storeName;

  QrPayment({this.storeName});

  @override
  _QrPayment createState() => _QrPayment();
}

class _QrPayment extends State<QrPayment> {
  @override
  Widget build(BuildContext context) {
    final QRProvider qp = Provider.of<QRProvider>(context, listen: false);
    final Map<String, dynamic> pointMap = Provider.of<UserProvider>(context,listen: false).pointMap;

    AppBar appBar = AppBar(
          centerTitle: true,
          title: Text("${widget.storeName} 결제",
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'noto',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333)
              )
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Image.asset(
              "assets/resource/public/close.png",
              width: 24,
              height: 24,
            ),
          ),
          elevation: 0.5,
        );
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                whiteSpaceH(31.0),
                Text("${widget.storeName} 결제금액",
                  style: TextStyle(
                      fontFamily: 'noto',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333)
                  ),
                ),
                Text("${numberFormat.format(qp.paymentModel.price)} KRW",
                  style: TextStyle(
                      fontFamily: 'noto',
                      fontSize: 20,
                      color: Color(0xFF333333)
                  ),
                ),
                whiteSpaceH(20.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("현금결제 금액",
                        style: TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 12,
                            fontFamily: 'noto'
                        )
                    ),
                  ],
                ),
                whiteSpaceH(4.0),
                Row(
                  children: [
                    Image.asset(
                      "assets/resource/public/krw-coin.png",
                      width: 40,
                      height: 40,
                    ),
                    Flexible(
                      child: TextFormField(
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color:Color(0xFF333333),
                          fontFamily: 'noto',
                          fontSize: 16,
                        ),
                        readOnly: true,
                        controller: qp.paymentEditModel.priceCtrl,
                        cursorColor: Color(0xff000000),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffixText: " KRW",
                          suffixStyle: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 16,
                              fontFamily: 'noto'
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mainColor, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                whiteSpaceH(4),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child:Text("현금으로 결제할 금액을 입력해주세요.",
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'noto',
                          color: Color(0xFF999999)
                      ),
                      textAlign: TextAlign.end,
                    )
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("결제 DL",
                        style: TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 12,
                            fontFamily: 'noto'
                        )
                    ),
                    whiteSpaceW(5.0),
                    Text("* ${numberFormat.format(pointMap['DL'])} DL 보유 중",
                        style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'noto',
                            color: mainColor,
                            fontWeight: FontWeight.w600
                        )
                    )
                  ],
                ),
                whiteSpaceH(4.0),
                Row(
                      children: [
                        Image.asset(
                          "assets/icon/DL 2.png",
                          width: 40,
                          height: 40,
                        ),
                        Flexible(
                          child: TextFormField(
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color:Color(0xFF333333),
                              fontFamily: 'noto',
                              fontSize: 16,
                            ),
                            onChanged: (value) {
                              qp.changeDl();
                            },
                            cursorColor: Color(0xff000000),
                            controller: qp.paymentEditModel.dlCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              suffixText: " DL",
                              suffixStyle: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 16,
                                  fontFamily: 'noto'
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: mainColor, width: 1.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                ),
                whiteSpaceH(4),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                      qp.store.store.limitDL == null ?
                      "* 결제한도가 없는 매장 입니다."
                          :
                      "* 해당매장의 결제한도는 ${qp.store.store.limitDL}% DL 입니다.",
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'noto',
                          color: mainColor,
                          fontWeight: FontWeight.w600
                      ),
                    textAlign: TextAlign.end,
                  ),
                ),
                Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: RaisedButton(
                      elevation: 0.0,
                      onPressed: (qp.paymentModel.price < (int.parse(qp.paymentEditModel.dlCtrl.text == "" ? "0" : qp.paymentEditModel.dlCtrl.text) * 100))
                            || (qp.store.store.limitDL != null &&
                              (qp.paymentModel.price * int.parse(qp.store.store.limitDL) / 100).round() < (int.parse(qp.paymentEditModel.dlCtrl.text) * 100))?
                          null
                          :
                          () {
                            showPaymentDialog();
                          },
                      color: mainColor,
                      child: Text("결제하기",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'noto',
                              color: white
                          )
                      )
                  ),
                )
              ],
            )
        ),
      ),
    );
  }

  showPaymentDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Text("결제안내",
              style: TextStyle(
                color: Color(0xFF444444),
                fontSize: 14,
                fontFamily: 'noto',
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            content: Consumer<QRProvider>(
              builder: (context, qp, _){
                return Container(
                    width: 240,
                    height: 185,
                    child: Column(
                      children: [
                        Text("${qp.store.store.name}에서 ${numberFormat.format(qp.paymentModel.price)}원을\n"
                            "${numberFormat.format(int.parse(qp.paymentEditModel.priceCtrl.text))}원과 "
                            "${numberFormat.format(int.parse(qp.paymentEditModel.dlCtrl.text))}DL로 각각 결제합니다.",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'noto',
                            color: Color(0xFF333333)
                          ),
                          textAlign: TextAlign.center,
                        ),
                        whiteSpaceH(22),
                        Text("결제 후 게임하기를 진행하시겠습니까?",
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'noto',
                            decoration: TextDecoration.underline,
                            color: Color(0xFFCCCCCC)
                          )
                        ),
                        whiteSpaceH(22),
                        Container(
                          width: 240,
                          height: 76,
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    child: Center(
                                      child: Text("취소",
                                        style: TextStyle(
                                          color: white,
                                          fontSize: 14,
                                          fontFamily: 'noto',
                                        )
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Color(0xFF999999),
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    await qp.confirmPayment(true, qp.paymentModel.uuid);

                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ServiceList(
                                      isHome: true,
                                      afterGame : true,
                                    )), (route) => false);
                                  },
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    child: Center(
                                      child: Text("나중에",
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 14,
                                            fontFamily: 'noto',
                                          )
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: mainColor,
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    await qp.confirmPayment(true, qp.paymentModel.uuid);

                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => BargainGame2(
                                      orderPayment: int.parse(qp.paymentEditModel.priceCtrl.text),
                                    )), (route) => false);
                                  },
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    child: Center(
                                      child: Text("확인",
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 14,
                                            fontFamily: 'noto',
                                          )
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: subColor,
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                );
              },
            )
          );
        });
  }
}

