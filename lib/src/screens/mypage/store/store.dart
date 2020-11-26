import 'dart:io';

import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/TextFieldWidget.dart';
import 'package:cashcook/src/widgets/TextFieldsWidget.dart';
import 'package:cashcook/src/widgets/TextFieldssWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class StoreApplyFirstStep extends StatefulWidget {
  @override
  _StoreApplyFirstStep createState() => _StoreApplyFirstStep();
}
class _StoreApplyFirstStep extends State<StoreApplyFirstStep> {
  TextEditingController nameCtrl = TextEditingController(); //상호명
  TextEditingController bnCtrl = TextEditingController(); //사업자번호
  TextEditingController ownerCtrl = TextEditingController(); //대표자명

  TextEditingController telCtrl1 = TextEditingController(); //연락처1
  TextEditingController telCtrl2 = TextEditingController(); //연락처2
  TextEditingController telCtrl3 = TextEditingController(); //연락처3

  TextEditingController emailCtrl = TextEditingController(); //이메일주소
  String bank = "은행명"; //은행명
  TextEditingController accountCtrl = TextEditingController(); //계좌번호
  String blUri;


  setBlUri(uri) {
    blUri = uri;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("사업자 정보",
          style: appBarDefaultText),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(top: false, child: body(context)),
    );
  }

  Widget body(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            textField(
                "상호명", "사업자등록증의 상호명을 입력해주세요.", nameCtrl, TextInputType.text),
            BusinessNumber(onSetUri: setBlUri,),
            textField(
                "사업자번호", "사업자등록증의 내용으로 입력해주세요.", bnCtrl, TextInputType.text),
            textField(
                "대표자명", "사업자등록증의 내용으로 입력해주세요.", ownerCtrl, TextInputType.text),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(child: Text("연락처",
                    style: Body2,),
                    alignment: Alignment.centerLeft,),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: textFieldss(telCtrl1, TextInputType.phone)),
                        Text("-", style: Body2,),
                        Expanded(
                            child: textFields(telCtrl2, TextInputType.phone)),
                        Text("-", style: Body2,),
                        Expanded(
                            child: textFields(telCtrl3, TextInputType.phone)),
                      ]
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Align(child: Text("연락가능한 연락처를 입력하여주세요",
                      style: Body2
                    ),
                      alignment: Alignment.centerRight,),
                  ),

                ]
            ),
            textField("이메일 주소", "사업자등록증의 상호명을 입력해주세요.", emailCtrl,
                TextInputType.emailAddress),
            BackInfo(),
            Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 40),
              child: nextBtn(context),
            )
          ],
        ),
      ),
    );
  }


  Widget BackInfo() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Align(child: Text("계좌정보",
              style: Body2,),
              alignment: Alignment.centerLeft,),
          ),
          DropdownButton(
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: primary,),
              iconSize: 24,
              elevation: 16,
              underline: Container(
              height: 2,
              color: Color(0xFFDDDDDD),
              ),
              value: bank ,
              items: ["은행명","우리은행", "SC제일은행", "하나은행", "신한은행", "국민은행"].map((value) {
                  return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
                }
              ).toList(),
              onChanged: (value){
                setState(() {
                  bank = value;
                });
              },
          ),
          SizedBox(height: 24,),
          TextFormField(
            controller: accountCtrl,
            cursorColor: Color(0xff000000),
            decoration: InputDecoration(
              hintText: "계좌번호",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffdddddd), width: 2.0),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primary, width: 2.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Align(child: Text("본인 명의의 계좌를 입력해주세요.",
              style: Body2,),
              alignment: Alignment.centerRight,),
          )
        ],
      ),
    );
  }

  Widget nextBtn(context) {
    return Container(
      width: double.infinity,
      height: 40,
      child: RaisedButton(
        onPressed: () async {
          Map<String, dynamic> args = {
            "company_name": nameCtrl.text,
            "license_number": bnCtrl.text,
            "representative": ownerCtrl.text,
            "tel": telCtrl1.text + telCtrl2.text + telCtrl3.text,
            "email": emailCtrl.text,
            "bank": bank,
            "account": accountCtrl.text,
            "bl": blUri
          };
          if (nameCtrl.text == '' || nameCtrl.text == null) {
            Fluttertoast.showToast(msg: "상호명을 입력해 주세요");
          } else if (blUri == '' || blUri == null) {
            Fluttertoast.showToast(msg: "사업자 등록증을 첨부해 주세요");
          } else if (bnCtrl.text == '' || bnCtrl.text == null) {
            Fluttertoast.showToast(msg: "사업자번호를 입력해 주세요");
          } else if (ownerCtrl.text == '' || ownerCtrl.text == null) {
            Fluttertoast.showToast(msg: "대표자명을 입력해 주세요");
          } else if (telCtrl1.text == '' || telCtrl1.text == null ||
              telCtrl2.text == '' || telCtrl2.text == null ||
              telCtrl3.text == '' || telCtrl3.text == null) {
            Fluttertoast.showToast(msg: "연락처를 입력해 주세요");
          } else if(telCtrl1.text.length < 3 || telCtrl2.text.length < 4 || telCtrl3.text.length < 4){
            Fluttertoast.showToast(msg: "전화 번호의 자릿수가 부족 합니다.");
          } else if (emailCtrl.text == '' || emailCtrl.text == null) {
            Fluttertoast.showToast(msg: "이메일주소를 입력해 주세요");
          } else if (bank == '은행명') {
            Fluttertoast.showToast(msg: "은행명을 선택해 주세요");
          } else if (accountCtrl.text == '' || accountCtrl.text == null) {
            Fluttertoast.showToast(msg: "계좌번호를 입력해 주세요");
          } else {
            await Provider.of<StoreServiceProvider>(context, listen: false).fetchCategory("01");
            Navigator.of(context).pushNamed("/store/apply2", arguments: args);
          }
        },
        child: Text("다음"),
        textColor: Colors.white,
        color: primary,
      ),
    );
  }
}




class BusinessNumber extends StatefulWidget {

  final Function(String uri) onSetUri;

  BusinessNumber({this.onSetUri});

  @override
  _BusinessNumberState createState() => _BusinessNumberState();
}

class _BusinessNumberState extends State<BusinessNumber> {

  final picker = ImagePicker();
  File _image;
  String filePath = "";
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
      filePath = pickedFile.path.split("/").last;
      widget.onSetUri(_image.absolute.path);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:5.0,bottom: 5.0),
            child: Align(child: Text("사업자등록증",style: Body2,),alignment: Alignment.centerLeft,),
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffdddddd))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    height: 40,
                    color: Color(0xffeeeeee),
                    child: Align(alignment: Alignment.centerLeft,child: Text(filePath,overflow: TextOverflow.ellipsis,)),
                  ),
                ),
                InkWell(
                  child: Container(
                    width: 90,
                    color: primary,
                    child: Center(child: Text("파일첨부", style:
                      Body2.apply(
                        color: white
                      )
                    ),
                    ),
                  ),
                  onTap: (){
                    getImage();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:5.0),
            child: Align(child: Text("저해상도의 경우 승인 거부의 사유가 될 수 있습니다.",style: Body2,),alignment: Alignment.centerRight,),
          )
        ],
      ),
    );
  }

}

