import 'dart:math';

import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:cashcook/src/screens/referrermanagement/invitationlist.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class Invitation extends StatefulWidget {
  @override
  _Invitation createState() => _Invitation();
}

class _Invitation extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "추천회원 초대하기",
          style: TextStyle(
              color: black,
              fontSize: 14,
              fontFamily: 'noto',
              fontWeight: FontWeight.w600),
        ),
        elevation: 2.0,
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.amber,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            whiteSpaceH(24),
            Image.asset(
              "assets/resource/public/payment.png",
              width: 200,
              height: 200,
            ),
            Padding(
              padding: EdgeInsets.only(top: 24, left: 20, right: 20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: white,
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text("휴대폰에 저장된 연락처를 가입자와 대조하여\n자동으로 나의 직접추천회원으로 등록해드립니다.",
                        style: TextStyle(
                            color: black,
                            fontSize: 12,
                            fontFamily: 'noto',
                            fontWeight: FontWeight.w600)),
                    whiteSpaceH(4),
                    whiteSpaceH(4),
                    whiteSpaceH(40),
                    whiteSpaceH(20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => InvitationList()));
                        },
                        elevation: 0.0,
                        color: mainColor,
                        child: Center(
                          child: Text(
                            "연락처 불러오기",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'noto',
                                fontSize: 14,
                                color: white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
