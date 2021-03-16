import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:cashcook/src/screens/referrermanagement/invitationlist.dart';
import 'package:flutter/material.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

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
        title: Text(
          "추천회원 초대하기",
          style: appBarDefaultText,
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
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
        height: MediaQuery.of(context).size.height,
        color: white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            whiteSpaceH(24),
            Row(
              children: [
                Text(
                  "초대할 추천회원\n친구를 불러옵니다.",
                  style: Subtitle2.apply(
                    fontWeightDelta: -1
                  )
                ),
              ],
            ),
            whiteSpaceH(20),
            Text("휴대폰에 저장된 연락처를 선택해주세요.\n자동으로 나의 가입대기회원으로 등록이 됩니다.",
                style: Body2
            ),
          Spacer(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              padding: EdgeInsets.symmetric(vertical: 8),
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
                color: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6.0)
                  )
                ),
                child: Center(
                  child: Text(
                      "확인",
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
    );
  }
}
