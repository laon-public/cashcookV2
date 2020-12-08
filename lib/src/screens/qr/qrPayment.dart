import 'package:cashcook/src/provider/QRProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/bargain/bargaingame2.dart';
import 'package:cashcook/src/screens/mypage/info/serviceList.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

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
              style: appBarDefaultText
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
                  style: Body1.apply(
                    fontWeightDelta: 1
                  )
                ),
                Text("${numberFormat.format(qp.paymentModel.price)} 원",
                  style: Subtitle2
                ),
                whiteSpaceH(20.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("현금결제 금액",
                        style: Body2
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
                        style: Subtitle2.apply(
                          fontWeightDelta: -1
                        ),
                        readOnly: true,
                        controller: qp.paymentEditModel.priceCtrl,
                        cursorColor: Color(0xff000000),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffixText: " 원",
                          suffixStyle: Subtitle2.apply(
                              fontWeightDelta: -1
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
                      style: Body2,
                      textAlign: TextAlign.end,
                    )
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("결제 DL",
                        style: Body2
                    ),
                    whiteSpaceW(5.0),
                    Text("* ${numberFormat.format(pointMap['DL'])} DL 보유 중",
                        style: TabsTagsStyle.apply(
                          color: primary,
                          fontWeightDelta: 1
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
                            style: Subtitle2.apply(
                              fontWeightDelta: -1
                            ),
                            onChanged: (value) {
                              qp.changeDl();
                            },
                            cursorColor: Color(0xff000000),
                            controller: qp.paymentEditModel.dlCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              suffixText: " DL",
                              suffixStyle: Subtitle2.apply(
                                  fontWeightDelta: -1
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
                      qp.store.store.limitType == "NONE" ?
                      "* 결제한도가 없는 매장 입니다."
                          :
                      "* 해당매장의 결제한도는 ${(qp.store.store.limitType == "PERCENTAGE") ? "${qp.store.store.limitDL}%" : "${numberFormat.format(int.parse(qp.store.store.limitDL))}"} DL 입니다.",
                      style: Body2.apply(
                        color: primary
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
                            || (qp.store.store.limitDL != "NONE" &&
                              ( qp.store.store.limitType == "CASH" &&
                                  (int.parse(qp.store.store.limitDL) < (int.parse(qp.paymentEditModel.dlCtrl.text)))) ||
                              ( qp.store.store.limitType == "PERCENTAGE" &&
                                  (qp.paymentModel.price * int.parse(qp.store.store.limitDL) / 100).round() < (int.parse(qp.paymentEditModel.dlCtrl.text) * 100)))?
                          null
                          :
                          () {
                            showPaymentDialog();
                          },
                      color: mainColor,
                      child: Text("결제하기",
                          style: Body1.apply(
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
                  borderRadius: BorderRadius.all(
                      Radius.circular(20.0)
                  )
              ),
            title: Text("결제안내",
              style: Body1.apply(
                color: black,
                fontWeightDelta: 3
              ),
              textAlign: TextAlign.center,
            ),
            content: Consumer<QRProvider>(
              builder: (context, qp, _){
                return Container(
                    width: 240,
                    height: 230,
                    child: Column(
                      children: [
                        Text("${qp.store.store.name}에서 ${numberFormat.format(qp.paymentModel.price)}원을\n"
                            "${numberFormat.format(int.parse(qp.paymentEditModel.priceCtrl.text))}원과 "
                            "${numberFormat.format(int.parse(qp.paymentEditModel.dlCtrl.text))}DL로 각 각 결제합니다.",
                          style: Body1,
                          textAlign: TextAlign.center,
                        ),
                        whiteSpaceH(22),
                        Text("실시간 흥정 게임으로 이동하시겠습니까?",
                            style: Body2
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
                                          style: Body1.apply(
                                              color: secondary,
                                              fontWeightDelta: 3
                                          )
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Color(0xFFDDDDDD),
                                            width: 1
                                        )
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
                                          style: Body1.apply(
                                              color: primary,
                                              fontWeightDelta: 3
                                          )
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Color(0xFFDDDDDD),
                                            width: 1
                                        )
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    await qp.confirmPayment(true, qp.paymentModel.uuid);

                                    Map<String, dynamic> pointMap =  Provider.of<UserProvider>(context, listen: false).pointMap;
                                    print("CARAT : ${pointMap['CARAT']}");

                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => BargainGame2(
                                      orderPayment: int.parse(qp.paymentEditModel.priceCtrl.text),
                                      totalCarat: pointMap['CARAT']
                                    )), (route) => false);
                                  },
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    child: Center(
                                      child: Text("예",
                                          style: Body1.apply(
                                              color: white,
                                              fontWeightDelta: 3
                                          )
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: primary,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: primary,
                                            width: 1
                                        )
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

