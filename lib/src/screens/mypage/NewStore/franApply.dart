import 'dart:io';

import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/provider/StoreApplyProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FranApply extends StatefulWidget {
  @override
  _FranApply createState() => _FranApply();
}

class _FranApply extends State<FranApply> {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      elevation: 0.5,
      title: Text("성공스토어 신청",
          style: appBarDefaultText
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24, color: black,),
      ),
    );
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      appBar: appBar,
      resizeToAvoidBottomInset: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("사업자 정보",
                      style: Subtitle2.apply(
                        fontWeightDelta: 1
                      )
                    ),
                    whiteSpaceH(4.0),
                    Text("사업자등록증의 정보와 동일하게 입력해주세요.",
                      style: Body2
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("상호명",
                      style: Body2
                    ),
                    TextField(
                      style: Subtitle2.apply(
                        fontWeightDelta: 1
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: black, width: 2.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("상호명",
                        style: Body2
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(12),
                            child: Text("ooo.pdf",
                              style: Body1.apply(
                                fontWeightDelta: 3
                            )),
                            decoration: BoxDecoration(
                              color: Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6.0),
                                  bottomLeft: Radius.circular(6.0)
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 96,
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: RaisedButton(
                            elevation: 0.0,
                            onPressed: () {},
                            color: primary,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text("파일첨부",
                              style:Body1.apply(
                                color: white,
                                fontWeightDelta: 1
                              )
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6.0),
                                  bottomRight: Radius.circular(6.0)
                                ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(6.0),
                                bottomRight: Radius.circular(6.0)
                            ),
                            border: Border.all(
                              color: Color(0xFF)
                            )
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("사업자 번호",
                        style: Body2
                    ),
                    TextField(
                      style: Subtitle2.apply(
                          fontWeightDelta: 1
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: black, width: 2.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("대표자 명",
                        style: Body2
                    ),
                    TextField(
                      style: Subtitle2.apply(
                          fontWeightDelta: 1
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: black, width: 2.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 12),
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text("대표자 정보",
                  style: Subtitle2.apply(
                    fontWeightDelta: 1
                  )
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("담당자 연락처",
                        style: Body2
                    ),
                    TextField(
                      style: Subtitle2.apply(
                          fontWeightDelta: 1
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: black, width: 2.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("이메일 주소",
                        style: Body2
                    ),
                    TextField(
                      style: Subtitle2.apply(
                          fontWeightDelta: 1
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: black, width: 2.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("계좌 정보",
                        style: Body2
                    ),
                    whiteSpaceH(4.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton(
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: black,),
                        iconSize: 24,
                        elevation: 16,
                        underline: Container(
                          color: Colors.transparent
                        ),
                        value: null ,
                        hint: Text("은행을 선택해주세요.",
                          style: Subtitle2.apply(
                            fontWeightDelta: -1,
                            color: third
                          ),
                        ),
                        items: ["우리은행", "SC제일은행", "하나은행", "신한은행", "국민은행"].map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value,
                              style: Subtitle2.apply(
                                  fontWeightDelta: 1
                              ),
                            ),
                          );
                        }
                        ).toList(),
                        onChanged: (value){
                        },
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: deActivatedGrey,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4)
                        )
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      style: Subtitle2.apply(
                          fontWeightDelta: 1
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: black, width: 2.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              whiteSpaceH(40.0),
              InkWell(
                onTap: () {
                },
                child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xFFDDDDDD),
                                    width: 1
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(2.0)
                                )
                            ),
                            child: Theme(
                              data: ThemeData(unselectedWidgetColor: Colors.transparent,),
                              child: Checkbox(
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                activeColor: primary,
                                checkColor: primary,
                                value: false,
                                onChanged: (value){
                                },
                              ),
                            )
                        ),
                        whiteSpaceW(12),
                        Text("개인정보 제 3자 제공 및 위탁동의",style: Body2,)
                      ],
                    )
                ),
              ),
              whiteSpaceH(53.0),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: RaisedButton(
                  elevation: 0.0,
                  onPressed: () {},
                  color: primary,
                  padding: EdgeInsets.symmetric(vertical: 11),
                  child: Text("신청하기",
                      style: Subtitle2.apply(
                        color: white,
                        fontWeightDelta: 1
                      ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6)
                    )
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Consumer<StoreApplyProvider>(
                        builder: (context, sap, _) {
                          return
                            Row(
                              children: sap.imageList.map((e) =>
                                InkWell(
                                  onTap: () async {
                                      await Provider.of<StoreApplyProvider>(context, listen: false).deleteImg(e);
                                  },
                                  child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 8),
                                      width: 96,
                                      height: 96,
                                      color: deActivatedGrey,
                                      child: Center(
                                          child: Image.file(
                                            File(e.path),
                                            width: 96,
                                            height: 96,
                                            fit: BoxFit.fitWidth,
                                          )
                                      )
                                  ),
                                )
                              ).toList(),
                            );
                        },
                      ),
                      InkWell(
                        onTap: () async {
                          await Provider.of<StoreApplyProvider>(context, listen: false).insertImg();
                        },
                        child:
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            width: 96,
                            height: 96,
                            color: deActivatedGrey,
                            child: Center(
                              child: Image.asset(
                                "assets/resource/public/plus.png",
                                width: 48,
                                height: 48,
                              ),
                            )
                        ),
                      ),
                    ],
                  )
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: RaisedButton(
                  elevation: 0.0,
                  onPressed: () {
                    Provider.of<StoreApplyProvider>(context, listen: false).submitImg();
                  },
                  color: primary,
                  padding: EdgeInsets.symmetric(vertical: 11),
                  child: Text("사진 테스팅",
                    style: Subtitle2.apply(
                        color: white,
                        fontWeightDelta: 1
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(6)
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}