import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';

class DrawComplete extends StatefulWidget {
  @override
  DrawCompleteState createState() => DrawCompleteState();
}

class DrawCompleteState extends State<DrawComplete> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AppBar appBar = AppBar(
      title: Text("탈퇴완료",
          style: appBarDefaultText
      ),
      centerTitle: true,
      elevation: 1.0,
    );

    // TODO: implement build
    return
      Scaffold(
        backgroundColor: white,
        resizeToAvoidBottomInset: true,
        appBar: appBar,
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
              Text("회원탈퇴가 완료되었습니다.",
                style: Subtitle2.apply(
                  color: black,
                  fontWeightDelta: 3
                )
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