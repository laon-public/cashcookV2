import 'dart:math';

import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/screens/referrermanagement/firstBizSelect.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';

import '../../provider/UserProvider.dart';
import '../../widgets/showToast.dart';
import '../../widgets/whitespace.dart';
import 'firstrecommendation.dart';

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
            style: TextStyle(
                color: black,
                fontFamily: 'noto',
                fontSize: 14,
                fontWeight: FontWeight.w600),
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
                                .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainMap()), (route) => false),
                          } else {
                            Navigator.of(context)
                                .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => FirstRecommendation(type: "NORMAL")), (route) => false),
                          }
                        }
                        );
                      },
                      child: whiteBox("일반","assets/icon/maru.png"),
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

                          Navigator.of(context)
                              .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainMap()), (route) => false),
                        } else {
                          Navigator.of(context)
                              .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => FirstRecommendation(type:"DISTRIBUTOR")), (route) => false),
                        }
                      }
                      );
                    },
                    child: whiteBox("총판","assets/resource/public/payment.png"),
                  ),
                ),
                Container(
                    height: 88,
                    child:InkWell(
                      onTap: () async {
                        Navigator.of(context)
                            .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => FirstBizSelect()), (route) => false);
                      },
                      child: whiteBox("대리점","assets/icon/cookie.png"),
                    )
                ),
              ]
          ),
        )

    );
  }

  Widget whiteBox(text, imagePath) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 84,
                height: 84,
                margin: EdgeInsets.only(top: 4.0, left: 4.0, bottom: 4.0, right: 12.0),
                child: Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
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