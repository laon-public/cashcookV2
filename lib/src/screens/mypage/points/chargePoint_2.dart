import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/buy/buy.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChargePoint2 extends StatefulWidget {
  final String pointType;

  ChargePoint2({this.pointType});

  @override
  _ChargePoint2State createState() => _ChargePoint2State();
}

class _ChargePoint2State extends State<ChargePoint2> {
  TextEditingController adpQuantityCtrl = TextEditingController();

  bool isAgree = false;
  int methodType = 0;
  int payLimit = 0;
  int pay;
  int rate;

  Map<int, String> paymentType = {
    0: "CREDIT_CARD",
    1: "WITHOUT_BANK",
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adpQuantityCtrl.text = "";
    (widget.pointType == "RP") ? payLimit = 100 : payLimit = 500000;
    (widget.pointType == "RP") ? rate = 10 : rate = 1;
  }

  @override
  Widget build(BuildContext context) {
    UserCheck my = Provider.of<UserProvider>(context, listen: false).loginUser;
    Map<String, int> point = Provider.of<UserProvider>(context, listen: false).pointMap;

    print(adpQuantityCtrl.text);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("포인트 충전",
          style: TextStyle(
            color: Color(0xFF444444),
            fontSize: 14,
            fontFamily: 'noto',
            fontWeight: FontWeight.w600
          )
        ),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 16, left: 16, bottom: 16),
        child: SingleChildScrollView(
          child:
          Consumer<UserProvider>(
            builder: (context, up, _){
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 104,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("보유 ${widget.pointType == "RP" ? "CP" : "ADP"}",
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 20,
                                fontFamily: 'noto',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            whiteSpaceH(4.0),
                            Row(
                              children: [
                                Image.asset(
                                  widget.pointType == "RP" ? "assets/icon/rp-coin.png" : "assets/icon/adp.png",
                                  width: 24,
                                  height: 24,
                                ),
                                whiteSpaceW(12.0),
                                Text("${numberFormat.format(point[widget.pointType])} ${widget.pointType == "RP" ? "CP" : "ADP"}",
                                  style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 12,
                                      fontFamily: 'noto'
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Spacer(),
                        Image.asset(
                          "assets/icon/study_payment.png",
                          width: 64,
                          height: 64,
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 94,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("충전수량",
                            style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 12,
                                fontFamily: 'noto'
                            )
                        ),
                        whiteSpaceH(4.0),
                        Row(
                          children: [
                            Image.asset(
                              widget.pointType == "RP" ? "assets/icon/rp-coin.png" : "assets/icon/adp.png",
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
                                  up.setChargePay(rate);
                                },
                                cursorColor: Color(0xff000000),
                                controller: up.chargeQuantityCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  suffixText: widget.pointType == "RP" ? "CP" : "ADP",
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
                        whiteSpaceH(3.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                                "= ${numberFormat.format(up.chargePay)} 원",
                                style: TextStyle(
                                    color: Color(0xFF999999),
                                    fontSize: 12,
                                    fontFamily: 'noto'
                                )
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 30.0),
                    width: MediaQuery.of(context).size.width,
                    height: 94,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("DL결제",
                                style: TextStyle(
                                    color: Color(0xFF999999),
                                    fontSize: 12,
                                    fontFamily: 'noto'
                                )
                            ),
                            whiteSpaceW(5.0),
                            Text("* ${numberFormat.format(point['DL'])} BZA 보유 중",
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
                              "assets/icon/bza.png",
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
                                  up.setDlPay();
                                },
                                cursorColor: Color(0xff000000),
                                controller: up.dlQuantityCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  suffixText: " BZA",
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
                        whiteSpaceH(3.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                                "= ${numberFormat.format(up.dlPay)} BZA",
                                style: TextStyle(
                                    color: Color(0xFF999999),
                                    fontSize: 12,
                                    fontFamily: 'noto'
                                )
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1,
                    color: Color(0xFFDDDDDD),
                  ),
                  whiteSpaceH(8),
                  Container(
                    padding: EdgeInsets.only(bottom: 30.0),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                        children: [
                          Expanded(
                            flex:1,
                              child: Text(
                                "총 결제 금액",
                                style: TextStyle(
                                    fontFamily: 'noto',
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600
                                ),
                                textAlign: TextAlign.start,
                              )
                          ),
                          Expanded(
                            flex: 2,
                              child: Text(
                                ((up.chargePay - (up.dlPay * 100))) < 0 ?
                                "결제금액보다 많을 수 없습니다."
                                :
                                (point['DL'] < up.dlPay) ?
                                "보유DL보다 많습니다."
                                :
                                "${numberFormat.format((up.chargePay - (up.dlPay * 100)))}원",
                                style: TextStyle(
                                    fontFamily: 'noto',
                                    fontSize: 16,
                                    color: mainColor,
                                    fontWeight: FontWeight.w600
                                ),
                                textAlign: TextAlign.end,
                              )
                          )
                        ]
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "결제방식",
                          style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 16,
                              fontFamily: 'noto',
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        whiteSpaceH(9.0),
                        Row(
                          children: [
                            Expanded(
                              child: method("신용카드",0),
                            ),
                            Expanded(
                              child: method("무통장입금", 1),
                            ),
                          ],
                        ),
                        whiteSpaceH(20.0),
                      ],
                    ),
                  ),
                  methodType == 1 ?
                      DropdownButton(
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: mainColor,),
                        iconSize: 24,
                        elevation: 16,
                        underline: Container(
                          height: 2,
                          color: Color(0xFFDDDDDD),
                        ),
                        value: "우리은행 / (주)트라이아트 / 00-000000-000",
                        items: ["우리은행 / (주)트라이아트 / 00-000000-000"].map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }
                        ).toList(),
                        onChanged: (value){
                        },
                      ): Container(),
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("* 최소 충전금액은 ${numberFormat.format(payLimit * rate)}원 입니다.",
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 14,
                            fontFamily: 'noto'
                          )
                        ),
                        (widget.pointType == "RP") ?
                        Container()
                        :
                        Text("* 현금/카드 결제시 20%ADP가 추가지급됩니다.",
                            style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 14,
                                fontFamily: 'noto'
                            )
                        ),
                      ]
                    ),
                  ),
                  agreePolicy(),
                  whiteSpaceH(24.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    color: mainColor,
                    child: RaisedButton(
                      color: mainColor,
                      disabledColor: Color(0xFFDDDDDD),
                      onPressed: up.chargePay < payLimit || !isAgree || ((up.chargePay - (up.dlPay * 100))) < 0 || (point['DL'] < up.dlPay)? null : () async {
                        if (paymentType[methodType] == "CREDIT_CARD") {
                          if((up.chargePay - (up.dlPay * 100)) <= 0){
                            bool response =
                            await Provider.of<UserProvider>(context, listen: false)
                                .postCharge(
                              "1",
                              widget.pointType,
                              int.parse(up.chargeQuantityCtrl.text),
                              paymentType[methodType],
                              int.parse(up.dlQuantityCtrl.text == "" ? "0" : up.dlQuantityCtrl.text),
                            );
                            if (!response) {
                              showToast("에러");
                            } else {
                              await Provider.of<UserProvider>(context, listen:false).fetchMyInfo(context);
                              await Provider.of<UserProvider>(context, listen: false).getAccountsHistory(widget.pointType, 0);
                              showToast("충전이 완료되었습니다.");
                            }
                          } else {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    Buy(
                                      name: Provider.of<UserProvider>(context, listen: false)
                                          .loginUser
                                          .name,
                                      point: widget.pointType,
                                      pay: (up.chargePay - (up.dlPay * 100)),
                                      id: "1",
                                      quantity: int.parse(up.chargeQuantityCtrl.text),
                                      paymentType: paymentType[methodType],
                                      dl: int.parse(up.dlQuantityCtrl.text == "" ? "0" : up.dlQuantityCtrl.text),
                                    )));
                          }

                          Navigator.of(context).pop();
                        }
                        else {
                          bool response =
                              await Provider.of<UserProvider>(context, listen: false)
                              .postCharge(
                                "1",
                                widget.pointType,
                                int.parse(up.chargeQuantityCtrl.text),
                                paymentType[methodType],
                                int.parse(up.dlQuantityCtrl.text == "" ? "0" : up.dlQuantityCtrl.text),
                              );
                          if (!response) {
                            showToast("에러");
                          } else {
                            await Provider.of<UserProvider>(context, listen:false).fetchMyInfo(context);
                            await Provider.of<UserProvider>(context, listen: false).getAccountsHistory(widget.pointType, 0);
                            showToast("충전이 완료되었습니다.");
                          }
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text("결제하기",
                        style: TextStyle(
                          color: white,
                          fontSize: 14,
                          fontFamily: 'noto'
                        ),
                      ),
                    )
                  )
                ],
              );
            },
          )
        ),
      ),
    );
  }

  Widget agreePolicy() {

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // 전체선택
          Theme(
            data: ThemeData(unselectedWidgetColor: Color(0xFFDDDDDD),  ),
            child:
            Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: mainColor,
              checkColor: mainColor,
              value: isAgree,
              onChanged: (value) {
                setState(() {
                  isAgree = value;
                });
              },
            ),
          ),
          Text(
            "개인정보 제 3자 제공 및 위탁동의",
            style: TextStyle(fontSize: 12, color: Color(0xff999999),fontFamily: 'noto'),
          )
        ],
      ),
    );
  }

  Widget method(String text, int methodType) {
    return InkWell(
      onTap: () {
        setState(() {
          this.methodType = methodType;
        });
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: BoxDecoration(
            border: Border.all(
                color: this.methodType == methodType ?
                  mainColor
                  :
                    Color(0xFFDDDDDD)
            )),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: this.methodType == methodType ?
                mainColor
                    :
                Color(0xFFDDDDDD)
            ),
          ),
        ),
      ),
    );
  }
}
