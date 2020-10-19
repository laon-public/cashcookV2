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
        body: Column(
            children: [
              Container(
                height: 70,
                child: Center(
                    child:Text(
                      "가입하는 회원등급을 선택해주세요.",
                      style: TextStyle(
                          color: black,
                          fontFamily: 'noto',
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                    )
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
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
                            child: whiteBox("일반"),
                          )
                        )

                      ]
                  ),
                ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
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
                          child: whiteBox("총판"),
                        ),
                      ),
                      Expanded(
                          child:InkWell(
                            onTap: () async {
                              Navigator.of(context)
                                  .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => FirstBizSelect()), (route) => false);
                            },
                            child: whiteBox("대리점"),
                          )
                      )
                    ]
                ),
              ),
              whiteSpaceH(50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "*매장 회원등록은 일반회원으로 가입 후 마이페이지에서",
                    style: TextStyle(
                      color: black,
                      fontSize: 12,
                      fontFamily: 'noto'
                    ),
                  ),
                  Text(
                      "매장등록을 하면 매장회원으로 등록됩니다.",
                      style: TextStyle(
                          color: black,
                          fontSize: 12,
                          fontFamily: 'noto'
                      ),
                  )
                ]
              )

          ]
        )
    );
  }

  Widget whiteBox(text) {
    return Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (text == "일반") ?
              Container(
                height: 74,
                width: 60,
                transform: Matrix4.rotationZ(pi / 25),
                child: Image.asset(
                  "assets/icon/maru.png",
                  width: 60,
                  height: 74,
                  fit: BoxFit.contain,
                ),
              )
              : Container(),
              Text(
                text,
                style: TextStyle(
                    fontSize: (text == "일반") ? 36 : 24,
                    color: Colors.black,
                    fontFamily: 'noto',
                    fontWeight: FontWeight.w600
                ),
              ),
              (text != "일반") ?
              Container(
                height: 66,
                width: 64,
                child: Image.asset(
                  (text == "총판") ? "assets/resource/public/payment.png" : "assets/icon/cookie.png",
                  width: 66,
                  height: 64,
                  fit: BoxFit.contain,
                ),
              )
                  : Container(),
            ],
          ),
          decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
      padding: EdgeInsets.only(top:30, bottom:30),
        );
  }
}