import 'dart:io';

import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/TextFieldWidget.dart';
import 'package:cashcook/src/widgets/TextFieldsWidget.dart';
import 'package:cashcook/src/widgets/TextFieldssWidget.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
// import 'package:file_picker/file_picker.dart';
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
  String bank = null; //은행명
  TextEditingController accountCtrl = TextEditingController(); //계좌번호
  String blUri;

  bool isAgreeCheck = false;


  setBlUri(uri) {
    blUri = uri;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("성공스토어 신청",
          style: appBarDefaultText),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
        ),
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
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("사업자 정보",
                    style: Subtitle2.apply(
                      fontWeightDelta: 1
                    )
                  ),
                  whiteSpaceH(4),
                  Text("사업자등록증의 정보와 동일하게 입력해주세요.",
                    style: Body2
                  )
                ],
              ),
            ),
            textField(
                "상호명", "사업자등록증의 상호명을 입력해주세요.", nameCtrl, TextInputType.text),
            BusinessNumber(onSetUri: setBlUri,),
            textField(
                "사업자번호", "사업자등록증의 내용으로 입력해주세요.", bnCtrl, TextInputType.text),
            textField(
                "대표자 명", "사업자등록증의 내용으로 입력해주세요.", ownerCtrl, TextInputType.text),
            whiteSpaceH(38),
            Text("대표자 정보",
              style: Subtitle2.apply(
                fontWeightDelta: 1
              )
            ),
            whiteSpaceH(30),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(child: Text("담당자 연락처",
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
                  whiteSpaceH(20)
                ]
            ),
            textField("이메일 주소", "사업자등록증의 상호명을 입력해주세요.", emailCtrl,
                TextInputType.emailAddress),
            BackInfo(),
            whiteSpaceH(40),
            InkWell(
              onTap: () {
                setState(() {
                  isAgreeCheck = !isAgreeCheck;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: mainColor,
                      value: isAgreeCheck,
                      onChanged: (value){
                        setState(() {
                          isAgreeCheck = value;
                        });
                      },
                    ),
                  ),
                  whiteSpaceW(12),
                  Text("개인정보 제 3자 제공 및 위탁동의",style: TextStyle(fontSize: 14, color: third),)
                ],
              ),
            ),
            whiteSpaceH(52),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 5),
              child: nextBtn(context),
            ),
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
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Align(child: Text("계좌정보",
              style: Body2,),
              alignment: Alignment.centerLeft,),
          ),
          Container(
            padding: EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: deActivatedGrey,
                width: 1
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(4)
              ),
              color: Color(0xFFF7F7F7)
            ),
            child: DropdownButton(
              isExpanded: true,
              style: Subtitle2.apply(
                  fontWeightDelta: -2,
                  color: black
              ),
              icon: Icon(Icons.arrow_drop_down, color: black,),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                color: Colors.transparent,
              ),
              value: bank ,
              hint: Text("은행을 선택해주세요.",
                style: Subtitle2.apply(
                  fontWeightDelta: -2,
                  color: third
                ),
              ),
              items: ["광주은행", "국민은행", "기업은행", "NH농협", "대구은행", "부산은행", "MG새마을금고", "SH수협",
                "SC은행", "신한은행", "외환은행", "우체국", "우리은행", "전북은행", "제주은행", "하나은행",].map((value) {
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
          ),
          SizedBox(height: 24,),
          TextFormField(
            controller: accountCtrl,
            cursorColor: Color(0xff000000),
            style: Subtitle2.apply(
                color: black,
              fontWeightDelta: 1
            ),
            decoration: InputDecoration(
              hintText: "계좌번호를 입력해주세요.",
              hintStyle: Subtitle2.apply(
                  color: third,
                  fontWeightDelta: -2
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 4),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: deActivatedGrey, width: 1.0),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: black, width: 2.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget nextBtn(context) {
    return Container(
      width: double.infinity,
      height: 44,
      child: RaisedButton(
        onPressed: () async {
          if(isAgreeCheck){
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
            } else if (emailCtrl.text == '' || emailCtrl.text == null) {
              Fluttertoast.showToast(msg: "이메일주소를 입력해 주세요");
            } else if (bank == null) {
              Fluttertoast.showToast(msg: "은행명을 선택해 주세요");
            } else if (accountCtrl.text == '' || accountCtrl.text == null) {
              Fluttertoast.showToast(msg: "계좌번호를 입력해 주세요");
            } else {
              await Provider.of<StoreProvider>(context, listen: false).clearSuccess();
              await Provider.of<StoreServiceProvider>(context, listen: false).fetchCategory("01");
              Navigator.of(context).pushNamed("/store/apply2", arguments: args);
            }
          } else {
            showToast("개인정보 이용동의를 해주셔야 합니다.");
          }
        },
        child: Text("신청하기",
          style: Subtitle2.apply(
            color: white,
            fontWeightDelta: 1
          )
        ),
        elevation: 0,
        textColor: Colors.white,
        color: primary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(6.0)
            )
        ),
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
    // FilePickerResult result = await FilePicker.platform.pickFiles();

    setState(() {
      _image = File(pickedFile.path);
      filePath = pickedFile.path.split("/").last;
      widget.onSetUri(_image.absolute.path);
      // filePath = pickedFile.path
      // widget.onSetUri(result.files.single.path);
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
            height: 44,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffdddddd)),
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    height: 44,
                    color: Color(0xFFF7F7F7),
                    child: Align(alignment: Alignment.centerLeft,child: Text(filePath.split("/").last,style: Subtitle2.apply(color:secondary, fontWeightDelta: 1),overflow: TextOverflow.ellipsis,)),
                    padding: EdgeInsets.only(left: 16),
                  ),
                ),
                InkWell(
                  child: Container(
                    width: 96,
                    height: 46,
                    child: Center(child: Text("파일첨부", style:
                      Body1.apply(
                        color: white,
                        fontWeightDelta: 1
                      )
                    ),
                    ),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(6.0),
                        bottomRight: Radius.circular(6.0)
                      )
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

