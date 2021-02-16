import 'package:cashcook/src/provider/provider.dart';
import 'package:cashcook/src/screens/main/home.dart';
import 'package:cashcook/src/screens/mypage/DrawComplete.dart';
import 'package:cashcook/src/screens/splash.dart';
import 'package:cashcook/src/services/User.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:provider/provider.dart' as provider;


class Withdraw extends StatefulWidget {
  final int authCheck;

  Withdraw({this.authCheck});

  @override
  _Withdraw createState() => _Withdraw();
}

class _Withdraw extends State<Withdraw>{


  UserProvider userProvider = null;
  bool isAgreeCheck = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = provider.Provider.of<UserProvider>(context,listen: false);
    AppBar appBar = AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
      ),
      title: Text("회원 탈퇴",
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
        body:
        SingleChildScrollView(
            child:
            Container(
              padding: EdgeInsets.only(top: 23, bottom: 8, left: 16, right: 16),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
              child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("회원탈퇴 시\n"
                        "데이터 삭제 안내",
                      style: Subtitle1,
                    ),
                    whiteSpaceH(23),
                    Text("회원탈퇴 시 보유하고 계신 성공스토어, 회원, 포인트, DL 등의 모든 내역이 삭제 됩니다.",
                        style: Body1.apply(
                            color: black
                        )
                    ),
                    Text("정말로 회원을 탈퇴 하시겠습니까?",
                        style: Body1.apply(
                            color: black
                        )
                    ),
                    whiteSpaceH(12),
                    Row(
                      children: [
                        Container(
                          child: Theme(
                              data: ThemeData(unselectedWidgetColor: Color(0xFFDDDDDD),),
                              child:
                              Checkbox(
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                activeColor: mainColor,
                                checkColor: white,
                                value: isAgreeCheck,
                                onChanged: (value) {
                                  setState(() {
                                    isAgreeCheck = value;
                                  });
                                },
                              )
                          ),
                        ),
                        Text("예, 모든 안내 내용을 숙지 하였습니다.",
                          style: Body1.apply(
                              color: third
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 52,
                      padding: EdgeInsets.only(top: 8),
                      child: RaisedButton(
                        child: Text("확인",
                          style: Subtitle2.apply(
                            fontWeightDelta: 1,
                            color: white
                          ),
                        ),
                        color: primary,
                        elevation: 0,
                        onPressed: () async {
                          if(!isAgreeCheck){
                            showToast("안내 내용을 모두 숙지 해주세요.");
                          } else {
                            await userProvider.DeleteUser();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => DrawComplete()
                              )
                            , (route) => false);
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6.0)
                          )
                        ),
                      ),
                    )
                  ]
              ),
            )
        ),
      );
  }

}