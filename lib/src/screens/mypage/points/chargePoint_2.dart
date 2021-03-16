import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/buy/buy.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

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
    (widget.pointType == "CARAT") ? payLimit = 1: payLimit = 500000;
    (widget.pointType == "CARAT") ? rate = 100 : rate = 1;
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
        title: Text("${widget.pointType} 충전",
          style: appBarDefaultText
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
        ),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: Container(
        child: SingleChildScrollView(
          child:
          Consumer<UserProvider>(
            builder: (context, up, _){
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 26),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("현재 보유 ${widget.pointType}",
                          style: Body1.apply(
                              color: secondary
                          ),
                        ),
                        whiteSpaceH(4.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("${numberFormat.format(point[widget.pointType])} ",
                              style: Subtitle1.apply(
                                  fontWeightDelta: 2
                              ),
                            ),
                            Text("${widget.pointType}",
                              style: Subtitle2.apply(
                                  fontWeightDelta: 1
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("충전수량",
                            style: Body2
                        ),
                        whiteSpaceH(8.0),
                        Row(
                          children: [
                            Image.asset(
                              widget.pointType == "CARAT" ? "assets/icon/carat.jpg" : "assets/icon/adp.png",
                              width: 40,
                              height: 40,
                            ),
                            whiteSpaceW(12),
                            Expanded(
                              child: TextFormField(
                                textAlign: TextAlign.end,
                                style: Subtitle2.apply(
                                  fontWeightDelta: -2
                                ),
                                onChanged: (value) {
                                  up.setChargePay(rate);
                                },
                                cursorColor: Color(0xff000000),
                                controller: up.chargeQuantityCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  suffixText: widget.pointType == "CARAT" ? " CARAT" : " ADP",
                                  suffixStyle: Subtitle2.apply(
                                    fontWeightDelta: -2
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: black, width: 2.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        whiteSpaceH(6.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                                "= ${numberFormat.format(up.chargePay)} 원",
                                style: Body2
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 24),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "DL 결제 수량",
                          style: Body1.apply(
                            color: black,
                            fontWeightDelta: 1
                          )
                        ),
                        whiteSpaceW(12),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(2)
                            ),
                            side: BorderSide(
                              color: up.dlQuantityCtrl.text == "" ? Color(0xFFDDDDDD) : primary,
                              width: 1,
                            )
                          ),
                          color: up.dlQuantityCtrl.text == "" ? white : primary,
                          elevation: 0.0,
                          onPressed: () {
                            showDLDialog();
                          },
                          child: Text(
                              up.dlQuantityCtrl.text == "" ? "DL 사용" : "${up.dlQuantityCtrl.text}DL",
                            style: Body1.apply(
                              color:  up.dlQuantityCtrl.text == "" ? secondary : white
                            )
                          ),
                        ),
                        Spacer(),
                        Text("- ${numberFormat.format(up.dlPay * 100)}원",
                          style: Body1.apply(
                            color: secondary,
                            fontWeightDelta: 1
                          )
                        ),
                      ],
                    ),
                  ),
                  whiteSpaceH(12),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                        children: [
                          Text(
                            "최종 결제 금액",
                            style: Body1.apply(
                              color: black,
                              fontWeightDelta: 1
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Spacer(),
                          Text(
                            ((up.chargePay - (up.dlPay * 100))) < 0 ?
                            "결제금액보다 많을 수 없습니다."
                                :
                            (point['DL'] < up.dlPay) ?
                            "보유DL보다 많습니다."
                                :
                            "${numberFormat.format((up.chargePay - (up.dlPay * 100)))}원",
                            style: Subtitle2.apply(
                                color: primary,
                              fontWeightDelta: 1
                            ),
                            textAlign: TextAlign.end,
                          )
                        ]
                    ),
                  ),
                  whiteSpaceH(12),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 8,
                    color: Color(0xFFF2F2F2),
                  ),
                  whiteSpaceH(12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "결제방식",
                            style: Subtitle2,
                          ),
                      ),
                      whiteSpaceH(12.0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: method("신용카드",0),
                            ),
                            Expanded(
                              child: method("무통장입금", 1),
                            ),
                          ],
                        )
                      ),
                      whiteSpaceH(20.0),
                    ],
                  ),
                  methodType == 1 ?
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButton(
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down, color: black,),
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(
                            height: 1,
                            color: Color(0xFFDDDDDD),
                          ),
                          value: "하나은행 / (주)캐시쿡 / 332-910043-16604",
                          items: ["하나은행 / (주)캐시쿡 / 332-910043-16604"].map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }
                          ).toList(),
                          onChanged: (value){
                          },
                        ),
                      )
                      : Container(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("* 최소 충전금액은 ${numberFormat.format(payLimit * rate)}원 입니다.",
                          style: Body1.apply(
                            color: secondary
                          )
                        ),
                        (widget.pointType == "CARAT") ?
                        Container()
                        :
                        Text("* 현금/카드 결제시 20%ADP가 추가지급됩니다.",
                            style: Body1.apply(
                              color: secondary
                            )
                        ),
                      ]
                    ),
                  ),
                  agreePolicy(),
                  whiteSpaceH(53.0),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: RaisedButton(
                      color: primary,
                      elevation: 0.0,
                      disabledColor: Color(0xFFDDDDDD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0))
                      ),
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
                              await Provider.of<UserProvider>(context, listen:false).fetchMyInfo();
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
                            await Provider.of<UserProvider>(context, listen:false).fetchMyInfo();
                            await Provider.of<UserProvider>(context, listen: false).getAccountsHistory(widget.pointType, 0);
                            showToast("충전이 완료되었습니다.");
                          }
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text("완료",
                        style: Subtitle2.apply(
                          color: white,
                          fontWeightDelta: 1
                        )
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
      margin: EdgeInsets.only(top:12),
      child: InkWell(
        onTap: () {
          setState(() {
            isAgree = !isAgree;
          });
        },
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
                style: Body1.apply(
                  color: third
                )
            )
          ],
        ),
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
                  primary
                  :
                    deActivatedGrey
            )),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                width: methodType == this.methodType ? 20 : 0,
                height: methodType == this.methodType ? 16 : 0,
                child: Theme(
                  data: ThemeData(
                    unselectedWidgetColor: Colors.transparent,
                  ),
                  child:
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: Colors.transparent,
                    checkColor: primary,
                    value: methodType == this.methodType,
                    onChanged: (value) {},
                  ),
                ),
                duration: Duration(milliseconds: 300),
              ),

              Text(
                text,
                style: Body1.apply(
                    color: methodType == this.methodType
                        ? black
                        : third
                )
              ),
            ],
          )
        ),
      ),
    );
  }

  showDLDialog() {
    Map<String, dynamic> pointMap =  Provider.of<UserProvider>(context, listen: false).pointMap;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Text("DL 사용",
              style: Body1.apply(
                  fontWeightDelta: 3
              ),
              textAlign: TextAlign.center,
            ),
            content:
            Container(
              width: 240,
              height: 220,
              child: Column(
                children: [
                  Consumer<UserProvider>(
                    builder: (context, up, _){
                      return Text(
                        "총 충전 금액 ${numberFormat.format(up.chargePay)}원 중\n"
                            + "DL로 결제할 수량을 입력하세요.",
                        style: Body1,
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  Consumer<UserProvider>(
                    builder: (context, up, _) {
                      return Container(
                        margin: EdgeInsets.only(top: 25.0, bottom: 20.0),
                        width: 192,
                        height: 44,
                        child:
                        TextFormField(
                          cursorColor: Color(0xff000000),
                          controller: up.dlQuantityCtrl,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            up.setDlPay();
                          },
                          style: Subtitle2.apply(
                              fontWeightDelta: -2
                          ),
                          decoration: InputDecoration(
                            suffixText: "개",
                            suffixStyle: Body1.apply(
                                color: secondary
                            ),
                            contentPadding: EdgeInsets.all(12.0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFDDDDDD)
                                )
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: primary
                                )
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  whiteSpaceH(20),
                  Consumer<UserProvider>(
                    builder: (context, up, _) {
                      return Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                                child:Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                      color: white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Color(0xFFDDDDDD),
                                          width: 1
                                      )
                                  ),
                                  child: Center(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("취소",
                                              style:Body1.apply(
                                                  color: secondary,
                                                  fontWeightDelta: 3
                                              )
                                          ),
                                        ),
                                      )
                                  ),
                                )
                            ),
                            whiteSpaceW(20.0),

                            ClipOval(
                                child:Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                      color:mainColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: primary,
                                          width: 1
                                      )
                                  ),
                                  child: Center(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            if(pointMap['DL'] < int.parse(up.dlQuantityCtrl.text)){
                                              showToast("보유 DL보다 많습니다.");
                                            } else if((int.parse(up.dlQuantityCtrl.text) * 100) > up.chargePay) {
                                              showToast("결제금액 보다 많습니다.");
                                            } else {
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Text("확인",
                                              style:Body1.apply(
                                                  color: white,
                                                  fontWeightDelta: 3
                                              )
                                          ),
                                        ),
                                      )
                                  ),
                                )
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}
