import 'dart:io';

import 'package:cashcook/src/model/store/menuedit.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/screens/referrermanagement/franBizSelect.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/utils/geocoder.dart';
import 'package:cashcook/src/widgets/TextFieldWidget.dart';
import 'package:cashcook/src/widgets/TextFieldssWidget.dart';
import 'package:cashcook/src/widgets/TextFieldsWidget.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class StoreApplyThirdStep extends StatefulWidget {
  @override
  _StoreApplyThirdStepState createState() => _StoreApplyThirdStepState();
}

class _StoreApplyThirdStepState extends State<StoreApplyThirdStep> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<StoreProvider>(context, listen: false).clearBigMenu();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("매장 정보 2/3", style:
        TextStyle(
            color: black,
            fontSize: 14,
            fontFamily: 'noto'
        )),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: SafeArea(top: false, child: body(context)),
    );
  }


  Widget body(context) {
    return
      Stack(
        children:[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(bottom: 50.0),
            child:SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(right: 15.0, left: 15.0),
                  child: Consumer<StoreProvider>(
                      builder: (context, sp, _) {
                        int bigIdx = 0;
                        return
                          Column(
                              children:[
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:
                                    sp.menuList.map((bm) {
                                      return bigMenuItem(bigIdx++,bm);
                                    }
                                    ).toList()
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  child:RaisedButton(
                                    color: mainColor,
                                    onPressed: () {
                                      Provider.of<StoreProvider>(context, listen: false).appendBigMenu();
                                    },
                                    child: Text(
                                        "대분류 추가",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'noto',
                                          color: white,
                                        )
                                    ),
                                  ),
                                ),
                              ]
                          )
                        ;
                      }
                  )
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
              child:
              RaisedButton(
                color: mainColor,
                onPressed: () {
                  Provider.of<StoreProvider>(context, listen: false).bak_menu();

                  Navigator.of(context).pushNamed("/store/apply4");
                },
                child: Text(
                    "다음",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'noto',
                      color: white,
                    )
                ),
              )
            )
          )
        ]
      );
  }

  Widget bigMenuItem(int bigIdx,BigMenuEditModel bme) {
    int idx = 0;
    return Container(
        padding: EdgeInsets.only(top: 30.0, bottom: 5.0),
        child:
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("메뉴분류",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'noto',
                        color: Color(0xFF888888)
                    )),
                TextFormField(
                  autofocus: false,
                  controller: bme.nameCtrl,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'noto',
                      color: black
                  ),
                  decoration: InputDecoration(
                    hintText: '메뉴 대분류를 작성해주세요.',
                    suffixIcon: InkWell(
                        onTap: () {
                          Provider.of<StoreProvider>(context, listen: false).removeBigMenu(bigIdx);
                        },
                        child: Image.asset(
                          "assets/icon/delete.png",
                          width: 24,
                          height: 24,
                        )
                    ),
                    border: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(0xffdddddd), width: 1.0),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: mainColor, width: 3.0),
                    ),
                  ),
                ),
                Column(
                  children: bme.menuEditList.map((m){
                    return MenuItem(bigIdx,idx++,m);
                  }).toList()
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      decoration: BoxDecoration(
                          color: Color(0xFFF1F1F1),
                        shape: BoxShape.circle,
                      ),
                      child:InkWell(
                          onTap: () {
                            Provider.of<StoreProvider>(context, listen: false).appendMenu(bigIdx);
                          },
                          child: Image.asset(
                            "assets/icon/plus.png",
                            width: 24,
                            height: 24,
                          )
                      ),
                    ),
                    whiteSpaceW(10),
                    Text(
                      "메뉴추가",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'noto',
                        color: Color(0xFF444444)
                      )
                    )
                  ]
                ),
              ],
            )
    );
  }

  Widget MenuItem(int bigIdx,int idx,MenuEditModel me) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 18.0, bottom: 7.0),
            height: 40,
            alignment: Alignment.centerLeft,
            child: TextFormField(
              autofocus: false,
              controller: me.nameCtrl,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'noto',
                color: black
              ),
              decoration: InputDecoration(
                suffixIcon: InkWell(
                  onTap: () {
                    Provider.of<StoreProvider>(context, listen: false).removeMenu(bigIdx, idx);
                  },
                  child: Image.asset(
                  "assets/icon/delete.png",
                  width: 24,
                  height: 24,
                )
                ),
                hintText: "메뉴명을 입력해주세요.",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffdddddd), width: 2.0),
                ),
                focusedBorder:
                OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor, width: 2.0),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 7.0, bottom: 7.0),
            height: 40,
            child:TextFormField(
              autofocus: false,
              controller: me.priceCtrl,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'noto',
                color: black
              ),
              decoration: InputDecoration(
                hintText: "가격",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffdddddd), width: 2.0),
                ),
                focusedBorder:
                OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor, width: 2.0),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}

