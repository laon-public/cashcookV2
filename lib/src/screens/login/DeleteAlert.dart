import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteAlert extends StatefulWidget {
  @override
  DeleteAlertState createState() => DeleteAlertState();
}

class DeleteAlertState extends State<DeleteAlert> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("회원탈퇴 안내",
            style: appBarDefaultText
        ),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            whiteSpaceH(MediaQuery.of(context).size.height * 1 / 6),
            Image.asset(
              "assets/resource/character/popup_03 1.png",
              width: 140,
              height: 120,
            ),
            whiteSpaceH(16),
            Text("탈퇴 처리 된 회원 아이디 입니다.\n"
                "서비스센터로 문의주세요.",
                style: Subtitle2.apply(
                    color: black,
                    fontWeightDelta: 3
                ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: RaisedButton(
                child: Text("완료",
                  style: Subtitle2.apply(
                      fontWeightDelta: 1,
                      color: white
                  ),
                ),
                color: primary,
                elevation: 0,
                onPressed: () async {
                  Navigator.of(context).pushNamedAndRemoveUntil("/logout", (route) => false);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(6.0)
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}