import 'package:cashcook/src/screens/main/home.dart';
import 'package:cashcook/src/screens/referrermanagement/firstBizSelect.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';

import '../../provider/UserProvider.dart';
import '../../widgets/showToast.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'firstrecommendation.dart';
import 'package:cashcook/src/screens/mypage/store/store.dart';

class FirstBiz extends StatefulWidget {
  @override
  _FirstBiz createState() => _FirstBiz();
}



class _FirstBiz extends State<FirstBiz> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            "회원등급 선택",
            style: appBarDefaultText,
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child:
          Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 40.0, bottom: 10.0),
                    child: Text(
                      "가입하는 회원등급을\n"
                          "선택해주세요.",
                      style: TextStyle(
                          color: Color(0xFF222222),
                          fontFamily: 'noto',
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.start,
                    )
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      "매장 회원등록은 일반회원으로 가입 후 마이페이지에서\n"
                          "매장등록을 하면 매장회원으로 등록됩니다.",
                      style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12,
                          fontFamily: 'noto'
                      ),
                      textAlign: TextAlign.start,
                    ),
                ),
               Container(
                    height: 88,
                    child:InkWell(
                      onTap: () async {
                        await Provider.of<UserProvider>(context,listen: false).recognitionSelect().then((value) async =>
                        {
                          if(value == 0){
                            showToast("추천자가 없습니다."),
                            await Provider.of<UserProvider>(context, listen: false).withoutReco(),

                            Navigator.of(context)
                                .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (route) => false),
                          } else {
                            Navigator.of(context)
                                .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => FirstRecommendation(type: "NORMAL")), (route) => false),
                          }
                        }
                        );
                      },
                      child: whiteBox("일반"),
                    )
                ),
                Container(
                  height: 88,
                  child:InkWell(
                    onTap: () async {
                      await Provider.of<UserProvider>(context,listen: false).recognitionSelect().then((value) async =>
                      {
                        if(value == 0){
                          showToast("추천자가 없습니다."),
                          await Provider.of<UserProvider>(context, listen: false).withoutRecoDis(),

                          // Navigator.of(context)
                          //     .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (route) => false),
                          Navigator.of(context)
                                .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => StoreApplyFirstStep()), (route) => false),
                        } else {
                          Navigator.of(context)
                              .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => FirstRecommendation(type:"AGENCY")), (route) => false),
                        }
                      }
                      );
                    },
                    child: whiteBox("제휴업체"),
                  ),
                ),
              ]
          ),
        )

    );
  }

  Widget whiteBox(text) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF333333),
                    fontFamily: 'noto',
                    fontWeight: FontWeight.w600
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: 12.0),
                child: Image.asset(
                  "assets/resource/public/small-arrow-right.png",
                  width: 24,
                  height: 24,
                ),
              )
            ]
          ),
    );
  }
}