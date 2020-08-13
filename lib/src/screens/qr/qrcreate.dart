import 'package:cashcook/src/provider/QRProvider.dart';
import 'package:cashcook/src/screens/qr/qrcheck.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class QrCreate extends StatefulWidget {
  final int type; // 0 = 일반결제 1 = DL 결제

  QrCreate({this.type});

  @override
  _QrCreate createState() => _QrCreate();
}

class _QrCreate extends State<QrCreate> {
  AppBar appBar;

  TextEditingController payController = TextEditingController();
  TextEditingController dlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: true,
      appBar: appBar = AppBar(
        backgroundColor: white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset(
            "assets/resource/public/prev.png",
            width: 24,
            height: 24,
          ),
        ),
        title: Text(
          widget.type == 0 ? "일반 결제" : "DL 결제",
          style: TextStyle(
              fontFamily: 'noto',
              fontSize: 14,
              color: black,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              whiteSpaceH(40),
              Text(
                "결제금액",
                style: TextStyle(
                    color: Color(0xFF888888), fontSize: 12, fontFamily: 'noto'),
              ),
              whiteSpaceH(4),
              Row(
                children: [
                  Image.asset("assets/resource/public/krw-coin.png",
                      width: 40, height: 40),
                  whiteSpaceW(8),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        controller: payController,
                        style: TextStyle(
                            fontFamily: 'noto', color: black, fontSize: 16),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          dlController.text =
                              (double.parse(value) / 100).toString();
                          if (value.length == 0) {
                            setState(() {
                              dlController.text = "";
                            });
                          }
                        },
                        cursorColor: mainColor,
                        decoration: InputDecoration(
                            filled: true,
                            suffixText: "KRW",
                            suffixStyle: TextStyle(
                                fontFamily: 'noto', color: black, fontSize: 16),
                            fillColor: white,
                            enabledBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide:
                                    BorderSide(color: Color(0xFFDDDDDD))),
                            counterText: "",
                            border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFDDDDDD)),
                                borderRadius: BorderRadius.circular(0)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: mainColor),
                                borderRadius: BorderRadius.circular(0)),
                            contentPadding: EdgeInsets.only(left: 0, right: 0)),
                      ),
                    ),
                  )
                ],
              ),
              whiteSpaceH(4),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "고객이 결제한 금액을 입력해주세요.",
                  style: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 12,
                      fontFamily: 'noto'),
                  textAlign: TextAlign.end,
                ),
              ),
              widget.type == 1
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "결제DL",
                          style: TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 12,
                              fontFamily: 'noto'),
                        ),
                        whiteSpaceH(4),
                        Row(
                          children: [
                            Image.asset("assets/resource/public/dl_icon.png",
                                width: 40, height: 40),
                            whiteSpaceW(8),
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                child: TextFormField(
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.number,
                                  controller: dlController,
                                  style: TextStyle(
                                      fontFamily: 'noto',
                                      color: black,
                                      fontSize: 16),
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  cursorColor: mainColor,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      filled: true,
                                      suffixText: "DL",
                                      suffixStyle: TextStyle(
                                          fontFamily: 'noto',
                                          color: black,
                                          fontSize: 16),
                                      fillColor: white,
                                      enabledBorder: UnderlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          borderSide: BorderSide(
                                              color: Color(0xFFDDDDDD))),
                                      counterText: "",
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFDDDDDD)),
                                          borderRadius:
                                              BorderRadius.circular(0)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: mainColor),
                                          borderRadius:
                                              BorderRadius.circular(0)),
                                      contentPadding:
                                          EdgeInsets.only(left: 0, right: 0)),
                                ),
                              ),
                            )
                          ],
                        ),
                        whiteSpaceH(4),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "100 원 = 1 DL",
                            style: TextStyle(
                                color: Color(0xFF888888),
                                fontSize: 12,
                                fontFamily: 'noto'),
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    )
                  : Container(),
              Expanded(
                child: Container(),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 72,
                padding: EdgeInsets.only(top: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.type == 0
                          ? "일반결제의 경우, 반드시\n결제를 완료한 이후 진행 바랍니다."
                          : "DL결제의 경우, 반드시\n결제하기 이전에 진행 바랍니다.",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontFamily: 'noto', fontSize: 14, color: black),
                    ),
                    whiteSpaceW(12),
                    Container(
                      width: 48,
                      height: 48,
                      color: Color(0xFFDDDDDD),
                    )
                  ],
                ),
              ),
              whiteSpaceH(24),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: RaisedButton(
                  onPressed: () async{
                    print(111);
                    int price = int.parse(payController.text == "" ? 0: payController.text);
                    int dilling = widget.type == 0 ? 0 : int.parse(dlController.text == "" ? 0: dlController.text.split(".").first);
                    String payment = widget.type == 0 ? "NORMAL": "DILLING";
                    print(price);
                    print(dilling);
                    print(payment);
                    String uuid = await Provider.of<QRProvider>(context,listen: false).postCreateQR(price, dilling, payment);
                    print(uuid);
                    if(uuid == ""){
                      Fluttertoast.showToast(msg: "QR코드 생성에 실패하였습니다.");
                    }else {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => QrCheck(uuid)));
                    }

                  },
                  elevation: 0.0,
                  color: mainColor,
                  child: Center(
                    child: Text(
                      "QR코드 생성",
                      style: TextStyle(
                          color: white, fontSize: 14, fontFamily: 'noto'),
                    ),
                  ),
                ),
              ),
              whiteSpaceH(56)
            ],
          ),
        ),
      ),
    );
  }
}
