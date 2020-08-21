import 'package:cashcook/src/model/account.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DlSell extends StatefulWidget {
  @override
  _DlSell createState() => _DlSell();
}

class _DlSell extends State<DlSell> {
  AppBar appBar;
  TextEditingController dlController = TextEditingController();

  String quantity = "";

  @override
  void initState() {
    super.initState();
    UserProvider userProvider = Provider.of<UserProvider>(context,listen:false);
    for(AccountModel account in userProvider.account) {
      if (account.type == "DILLING"){
//        quantity = account.quantity.split(".").first;
        quantity = account.quantity;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
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
          "DL 판매하기",
          style: TextStyle(
              fontFamily: 'noto',
              fontSize: 14,
              color: black,
              fontWeight: FontWeight.w600),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          color: white,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              whiteSpaceH(4),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "보유 DL",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: black,
                            fontSize: 20,
                            fontFamily: 'noto'),
                      ),
                      whiteSpaceH(4),
                      Row(
                        children: [
                          Image.asset(
                            "assets/resource/public/dl_icon.png",
                            width: 24,
                            height: 24,
                          ),
                          whiteSpaceW(12),
                          Text(
                            "${numberFormat.format(double.parse(quantity))} DL",
                            style: TextStyle(
                                fontFamily: 'noto', fontSize: 12, color: black),
                          )
                        ],
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    width: 64,
                    height: 64,
                    color: Color(0xFFDDDDDD),
                  )
                ],
              ),
              whiteSpaceH(30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "판매수량",
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
                            onChanged: (value) {
                              setState(() {

                              });
                            },
                            cursorColor: mainColor,
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
                      "= ${numberFormat.format(dlController.text != "" ? int.parse(dlController.text) * 50 : 0 * 50)} 원\n1 DL = 50 원",
                      style: TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 12,
                          fontFamily: 'noto'),
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
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
                      "24시간 이내로\n가입 시 입력한 계좌로 입금됩니다.",
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
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context) => MainMap()
                    ), (route) => false);
                  },
                  elevation: 0.0,
                  color: mainColor,
                  child: Center(
                    child: Text(
                      "판매하기",
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
