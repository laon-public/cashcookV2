import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:cashcook/src/screens/referrermanagement/invitationlist.dart';
import 'package:flutter/material.dart';

class Invitation extends StatefulWidget {
  @override
  _Invitation createState() => _Invitation();
}

class _Invitation extends State {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          "추천회원 초대하기",
          style: TextStyle(
              color: white,
              fontSize: 14,
              fontFamily: 'noto',
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
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
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
        height: MediaQuery.of(context).size.height,
        color: mainColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            whiteSpaceH(24),
            Image.asset(
              "assets/resource/public/payment.png",
              width: 80,
              height: 80,
              fit: BoxFit.fill,
            ),
            whiteSpaceH(20),
            Text("휴대폰에 저장된 연락처를 가입자와 대조하여\n자동으로 나의 직접추천회원으로 등록해드립니다.",
                style: TextStyle(
                    color: white,
                    fontSize: 12,
                    fontFamily: 'noto',)),
          Spacer(),
          Container(
                width: MediaQuery.of(context).size.width,
                color: mainColor,
                padding: EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: RaisedButton(
                        onPressed: () async {
                          final bool result = await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => InvitationList())
                          );
                          if(result){
                            Navigator.of(context).pop();
                          }
                        },
                        elevation: 0.0,
                        color: subYellow,
                        child: Center(
                          child: Text(
                            "연락처 불러오기",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'noto',
                                fontSize: 12,
                                color: black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
