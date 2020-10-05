import 'dart:convert';

import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/RecoProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/screens/referrermanagement/firstBizSelect.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/model/recomemberlist.dart';
import 'dart:math';

import '../../provider/UserProvider.dart';
import '../../provider/UserProvider.dart';
import '../../widgets/showToast.dart';
import '../../widgets/whitespace.dart';
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
        backgroundColor: Colors.amberAccent,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            "회원등급 선택",
            style: TextStyle(
                color: black,
                fontFamily: 'noto',
                fontSize: 16,
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
                        InkWell(
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
                          child: whiteBox("일반", 1),
                        )
                      ]
                  ),
                ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
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
                        child: whiteBox("총판", 2),
                      ),
                      InkWell(
                        onTap: () async {
                              Navigator.of(context)
                                  .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => FirstBizSelect()), (route) => false);
                          },
                        child: whiteBox("대리점", 2),
                      )
                    ]
                ),
              ),
              whiteSpaceH(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "*매장 회원등록은 일반회원으로 가입 후 마이페이지에서"
                  ),
                  Text(
                      "매장등록을 하면 매장회원으로 등록됩니다."
                  )
                ]
              )

          ]
        )
    );
  }

  Widget whiteBox(text, divide) {
    return
      Center(
        child:Container(
          width: 275 / divide,
          height: 135,
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(5,5)
                )
              ]
          ),
        ),
      );
  }
}