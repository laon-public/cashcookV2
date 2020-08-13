import 'dart:convert';

import 'package:cashcook/src/provider/RecoProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Recommendation extends StatefulWidget {
  @override
  _Recommendation createState() => _Recommendation();
}

class _Recommendation extends State<Recommendation> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactUsController = TextEditingController();
  FocusNode contactUsFocus = FocusNode();

  AppBar appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: true,
      appBar: appBar = AppBar(
        backgroundColor: white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          "추천인 등록하기",
          style: TextStyle(
              color: black,
              fontFamily: 'noto',
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
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
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - appBar.preferredSize.height,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                whiteSpaceH(24),

                whiteSpaceH(4),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(contactUsFocus);
                  },
                  cursorColor: mainColor,
                  decoration: InputDecoration(

                      counterText: "",
//                    hintStyle: TextStyle(
//                        fontSize: 16,
//                        color: Color.fromARGB(255, 167, 167, 167),
//                        fontFamily: 'noto'),
                      labelText: "이름",
                      labelStyle: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 167, 167, 167),
                          fontFamily: 'noto'),
//                    hintText: "이름",
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                          borderRadius: BorderRadius.circular(0)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: mainColor),
                          borderRadius: BorderRadius.circular(0)),
                      contentPadding: EdgeInsets.only(left: 10, right: 10)),
                ),
                whiteSpaceH(8),
                TextFormField(
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  controller: contactUsController,
                  focusNode: contactUsFocus,
                  cursorColor: mainColor,
                  decoration: InputDecoration(
                      counterText: "",
                      labelStyle: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 167, 167, 167),
                          fontFamily: 'noto'),
                      labelText: "연락처",
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                          borderRadius: BorderRadius.circular(0)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: mainColor),
                          borderRadius: BorderRadius.circular(0)),
                      contentPadding: EdgeInsets.only(left: 10, right: 10)),
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
                        "등록한 정보의 회원이 회원가입 시\n자동으로 나의 직추천인으로 등록됩니다.",
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
                      apply();
                    },
                    elevation: 0.0,
                    color: mainColor,
                    child: Center(
                      child: Text(
                        "등록하기",
                        style: TextStyle(
                            color: white,
                            fontSize: 14,
                            fontFamily: 'noto',
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                whiteSpaceH(40)
              ],
            ),
          ),
        ),
      ),
    );
  }

  apply() async {
    String name = nameController.text;
    String phone = contactUsController.text;
    String response = await Provider.of<RecoProvider>(context, listen: false).postReco(name, phone);

    if(response == "true"){
      Fluttertoast.showToast(msg: "등록이 완료되었습니다.");
    }else {
      Fluttertoast.showToast(msg: response);
    }

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainMap()), (route) => false);

  }

}
