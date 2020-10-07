import 'dart:convert';

import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/RecoProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
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
import '../../provider/UserProvider.dart';
import '../../widgets/showToast.dart';
import 'firstrecommendation.dart';

class FranBizSelect extends StatefulWidget {
  @override
  _FranBizSelect createState() => _FranBizSelect();
}

class _FranBizSelect extends State<FranBizSelect> {
  bool userCheck = false;

  AppBar appBar;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context,listen: false).selectDisAge();
    });
    
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      resizeToAvoidBottomInset: true,
      appBar: appBar = AppBar(
        backgroundColor: Colors.amberAccent,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          "총판 / 대리점 입력",
          style: TextStyle(
              color: black,
              fontFamily: 'noto',
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
      ),
      body:

      Consumer<UserProvider>(
        builder: (context, user, _) {
          return (user.isLoading) ?
              Center (
                child:
                  CircularProgressIndicator()
              )
              :
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - appBar.preferredSize.height,
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    whiteSpaceH(24),
                    Text('총판회원',
                      style: TextStyle(
                          fontFamily: 'noto', fontSize: 14, color: Colors.red),
                    ),
                    whiteSpaceH(4),
                    SizedBox(
                      child: DropdownButton(
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        underline: Container(
                            height: 2,
                            color: Colors.red
                        ),
                        value: user.disSelected ,
                        items: user.disList.map(
                                (value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }
                        ).toList(),
                        onChanged: (value){
                          if(value != "총판"){
                            Provider.of<UserProvider>(context, listen: false).selectAge(value);
                          } else {
                            Provider.of<UserProvider>(context, listen: false).clearAge(value);
                          }
                        },
                      ),
                    ),
                    Text('대리점회원',
                      style: TextStyle(
                          fontFamily: 'noto', fontSize: 14, color: Colors.red),
                    ),
                    whiteSpaceH(4),
                    SizedBox(
                      child: DropdownButton(
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        underline: Container(
                            height: 2,
                            color: Colors.red
                        ),
                        value: user.ageSelected ,
                        items: user.ageList.map(
                                (value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }
                        ).toList(),
                        onChanged: (value){
                          Provider.of<UserProvider>(context, listen: false).setAgeSelected(value);
                        },
                      ),
                    ),
                    whiteSpaceH(8),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '상위 총판 / 대리점을 선택해주세요.',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontFamily: 'noto', fontSize: 14, color: black),
                          ),
                          whiteSpaceW(12),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 72,
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "상위 총판을 선택해 주세요.",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontFamily: 'noto', fontSize: 14, color: black),
                          ),
                          whiteSpaceW(12),
                          Container(
                            child: Image.asset(
                              "assets/resource/public/payment.png",
                              width: 48,
                              height: 48,
                            ),
                          )
                        ],
                      ),
                    ),
                    whiteSpaceH(24),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: RaisedButton(
                        onPressed: () async {
                          await Provider.of<UserProvider>(context, listen: false).insertDisAge();

                          Navigator.of(context).pop();
                        },
                        elevation: 0.0,
                        color: mainColor,
                        child: Center(
                          child: Text(
                            "확인",
                            style: TextStyle(
                                color: white,
                                fontSize: 14,
                                fontFamily: 'noto',
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    whiteSpaceH(40)
                  ],
                ),
              ),
            ),
          );
        }
      )
    );
  }
}