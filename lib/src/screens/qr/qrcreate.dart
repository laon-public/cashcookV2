import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/provider/QRProvider.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/qr/qrcheck.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/TextFieldWidget.dart';
import 'package:cashcook/src/widgets/showToast.dart';
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
  FocusNode payMove = FocusNode ();
  @override
  Widget build(BuildContext context) {
    StoreModel myStore = Provider.of<UserProvider>(context, listen: false).storeModel;
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
          widget.type == 0 ? "현장 결제" : "DL 결제",
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
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 6, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.type == 0
                          ? "현장결제의 경우, 반드시\n결제를 완료한 이후 진행 바랍니다."
                          : "DL결제의 경우, 반드시\n결제하기 이전에 진행 바랍니다.",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'noto', fontSize: 14, color: Color(0xFF222222)),
                    ),
                    whiteSpaceW(12),
                    Container(
                      child: Image.asset(
                        "assets/resource/public/payment.png",
                        width: 48,
                        height: 48,
                      ),
                    )
                  ],
                ),
              ),
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
                        focusNode: payMove,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        controller: payController,
                        style: TextStyle(
                            fontFamily: 'noto', color: Color(0xFF333333), fontSize: 14),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          if(int.parse(value) >= 100){
                            dlController.text =
                                (int.parse(value) / 100).toString().split(".").first;
                          } else {
                            dlController.text = "";
                          }
                        },
                        cursorColor: mainColor,
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                            hintText: widget.type == 0 ? "결제 금액은 1000원 단위로 해주세요." : "결제 금액은 100원 단위로 해주세요.",
                            filled: true,
                            suffixText: "KRW",
                            suffixStyle: TextStyle(
                                fontFamily: 'noto', color: Color(0xFF333333), fontSize: 14),
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
                            contentPadding: EdgeInsets.symmetric(horizontal: 8.0)),
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
                      color: Color(0xFF999999),
                      fontSize: 12,
                      fontFamily: 'noto'),
                  textAlign: TextAlign.end,
                ),
              ),
              whiteSpaceH(30.0),
              widget.type == 1
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "결제DL",
                              style: TextStyle(
                                  color: Color(0xFF888888),
                                  fontSize: 12,
                                  fontFamily: 'noto'),
                            ),
                            whiteSpaceW(10),
                            Text(
                              myStore.store.limitDL == null ? "결제한도가 없습니다." :
                              "결제한도 ${myStore.store.limitDL} DL",
                              style: TextStyle(
                                  color: mainColor,
                                  fontSize: 12,
                                  fontFamily: 'noto'),
                            ),
                          ],
                        ),
                        whiteSpaceH(4),
                        Row(
                          children: [
                            Image.asset("assets/icon/DL 2.png",
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
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontFamily: 'noto',
                                      color: Color(0xFF333333),
                                      fontSize: 14),
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
                                          fontSize: 14),
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
                                          EdgeInsets.symmetric(horizontal: 8.0)),
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
                                color: Color(0xFF999999),
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
              whiteSpaceH(24),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: RaisedButton(
                  onPressed: (widget.type == 0 && payController.text.isNotEmpty && int.parse(payController.text) >= 1000) ||
                      (widget.type == 1 && payController.text.isNotEmpty && int.parse(payController.text) >= 100) ? () async {

                    print(1112);
                    int price = int.parse(payController.text == "" ? 0: payController.text);
                    int dilling = widget.type == 0 ? 0 : int.parse(dlController.text == "" ? 0: dlController.text.split(".").first);
                    String payment = widget.type == 0 ? "NORMAL": "DILLING";
                    print(price);
                    print(dilling);
                    print("현재 상태 : ${ payment } ");
                    if( widget.type != 0 && myStore.store.limitDL != null ) {
                      if( int.parse(myStore.store.limitDL) < int.parse(dlController.text) ){
                        showToast("결제한도 보다 많습니다.");
                        return;
                      }
                    }
                    String uuid = await Provider.of<QRProvider>(context,listen: false).postCreateQR(price, dilling, payment);
                    print(uuid);
                    if(uuid == ""){
                      Fluttertoast.showToast(msg: "QR코드 생성에 실패하였습니다.");
                    }else {

                      if(  (widget.type == 0 && payController.text.length <= 2) || (widget.type == 1 && payController.text.length <= 2)){
                        FocusScope.of(context).requestFocus(payMove);
                        _showDialog();
                      }

                      if( widget.type == 0 ){
                          if(payController.text.substring( payController.text.length-3 , payController.text.length) != "000"){
                            print(" 100원 단위 있음 : ${payController.text.substring( payController.text.length-3 , payController.text.length)}");
                            FocusScope.of(context).requestFocus(payMove);
                            _showDialog();

                          }else{
                            print(" 100원 단위 없음 : ${payController.text.substring( payController.text.length-3 , payController.text.length)}");
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => QrCheck(uuid)));
                          }
                      } else if( widget.type == 1 ){
                        if(payController.text.substring( payController.text.length-2 , payController.text.length) != "00" ){
                          print(" 10원 단위 있음 : ${payController.text.substring( payController.text.length-3 , payController.text.length)}");
                          FocusScope.of(context).requestFocus(payMove);
                          _showDialog();

                        }else{
                          print(" 10원 단위 없음 : ${payController.text.substring( payController.text.length-2 , payController.text.length)}");
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => QrCheck(uuid)));
                        }
                      }
                    }

                  } : null,
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
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("${ widget.type == 0 ? "결제 금액은 1000원 단위로 해주세요." : "결제 금액은 100원 단위로 해주세요." }",
            style: TextStyle(
            fontSize: 14,
            color: Color(0xff333333),
              fontFamily: 'noto'
          ),),

          actions: <Widget>[
            FlatButton(
              color: mainColor,
              child: new Text("Close",
                style: TextStyle(
                  color: white,
                  fontSize: 12,
                  fontFamily: 'noto'
                ),
              ),
              onPressed: () {
                payController.text = '';
                Navigator.pop(context);

              },
            ),
          ],
        );
      },
    );
  }
}

