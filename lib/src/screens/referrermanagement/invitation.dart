import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class Invitation extends StatefulWidget {
  @override
  _Invitation createState() => _Invitation();
}

class _Invitation extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.0,
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
        color: white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            whiteSpaceH(24),
            Image.asset(
              "assets/needsclear/resource/home/reco/invite.png",
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
                    Text("나의 친구들에게도",
                        style: TextStyle(
                            color: black,
                            fontSize: 20,
                            fontFamily: 'noto',
                            fontWeight: FontWeight.w600)),
                    whiteSpaceH(4),
                    RichText(
                      text: TextSpan(
                          text: "캐시쿡",
                          style: TextStyle(
                              fontFamily: 'noto',
                              fontWeight: FontWeight.w600,
                              color: mainColor,
                              fontSize: 20),
                          children: <TextSpan>[
                            TextSpan(
                                text: "를 추천해보세요.",
                                style: TextStyle(
                                    fontFamily: 'noto',
                                    fontSize: 20,
                                    color: black,
                                    fontWeight: FontWeight.w600))
                          ]),
                    ),
                    whiteSpaceH(40),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: RaisedButton(
                        onPressed: () {
                          Share.share("캐시쿡을 사용해보세요.");
                        },
                        elevation: 0.0,
                        color: mainColor,
                        child: Center(
                          child: Text(
                            "초대하기",
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
