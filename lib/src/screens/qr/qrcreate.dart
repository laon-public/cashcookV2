import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/provider/QRProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/qr/qrcheck.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class QrCreate extends StatefulWidget {
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
          "결제하기",
          style: appBarDefaultText,
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
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 23, bottom: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "고객이 결제한\n금액을 입력해주세요.",
                      textAlign: TextAlign.start,
                      style: Subtitle1
                    ),
                  ],
                ),
              ),
              Text(
                "현장결제금액",
                style: Body2
              ),
              whiteSpaceH(8),
              Row(
                children: [
                  Image.asset("assets/resource/public/krw-coin.png",
                      width: 36, height: 36),
                  whiteSpaceW(12),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: TextFormField(
                        focusNode: payMove,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        controller: payController,
                        style: Subtitle2.apply(
                            fontWeightDelta: -2
                        ),
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
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                          filled: true,
                          suffixText: " 원",
                          suffixStyle: Subtitle2.apply(
                            fontWeightDelta: -2
                          ),
                          fillColor: white,
                          counterText: "",
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: black, width: 2.0),
                          ),
                        ),
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
                  style: Body2,
                  textAlign: TextAlign.end,
                ),
              ),
              whiteSpaceH(30.0),
              Expanded(
                child: Container(),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                padding: EdgeInsets.symmetric(vertical: 8),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6)
                    )
                  ),
                  onPressed: (payController.text.isNotEmpty && int.parse(payController.text) >= 1000)
                       ? () async {
                    int price = int.parse(payController.text == "" ? 0: payController.text);
                    int dilling = 0;
                    String payment = "NORMAL";
                    print(price);
                    print(dilling);
                    print("현재 상태 : ${ payment } ");
                    String uuid = await Provider.of<QRProvider>(context,listen: false).postCreateQR(price, dilling, payment);
                    print(uuid);
                    if(uuid == ""){
                      Fluttertoast.showToast(msg: "QR코드 생성에 실패하였습니다.");
                    }else {

                      if(  payController.text.length <= 2){
                        FocusScope.of(context).requestFocus(payMove);
                        _showDialog();
                      }


                          if(payController.text.substring( payController.text.length-3 , payController.text.length) != "000"){
                            print(" 100원 단위 있음 : ${payController.text.substring( payController.text.length-3 , payController.text.length)}");
                            FocusScope.of(context).requestFocus(payMove);
                            _showDialog();

                          }else{
                            print(" 100원 단위 없음 : ${payController.text.substring( payController.text.length-3 , payController.text.length)}");
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => QrCheck(uuid)));
                          }
                    }

                  } : null,
                  elevation: 0.0,
                  color: mainColor,
                  child: Center(
                    child: Text(
                      "QR코드 생성",
                      style: Subtitle2.apply(
                        color: white,
                        fontWeightDelta: 1
                      )
                    ),
                  ),
                ),
              ),
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
          title: Text("결제 금액은 1000원 단위로 해주세요.",
            style: Body1,),

          actions: <Widget>[
            FlatButton(
              color: mainColor,
              child: new Text("Close",
                style: Body2.apply(
                  color: white
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

