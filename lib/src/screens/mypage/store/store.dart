import 'dart:io';

import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/TextFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StoreApplyFirstStep extends StatelessWidget {
  TextEditingController nameCtrl = TextEditingController(); //상호명
  TextEditingController bnCtrl = TextEditingController(); //사업자번호
  TextEditingController ownerCtrl = TextEditingController(); //대표자명
  TextEditingController telCtrl = TextEditingController(); //연락처
  TextEditingController emailCtrl = TextEditingController(); //이메일주소
  TextEditingController bankCtrl = TextEditingController(); //은행명
  TextEditingController accountCtrl = TextEditingController(); //계좌번호
  String blUri;

  setBlUri(uri){
    blUri = uri;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("가맹점 등록하기 1/2"),
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
            textField("상호명", "사업자등록증의 상호명을 입력해주세요.", nameCtrl, TextInputType.text),
            BusinessNumber(onSetUri: setBlUri,),
            textField("사업자번호", "사업자등록증의 내용으로 입력해주세요.", bnCtrl,TextInputType.text),
            textField("대표자명", "사업자등록증의 내용으로 입력해주세요.", ownerCtrl,TextInputType.text),
            textField("연락처", "연락가능한 연락처를 입력하여주세요.", telCtrl,TextInputType.phone),
            textField("이메일 주소", "사업자등록증의 상호명을 입력해주세요.", emailCtrl,TextInputType.emailAddress),
            BackInfo(),
            Padding(
              padding: const EdgeInsets.only(top:40.0,bottom: 40),
              child: nextBtn(context),
            )
          ],
        ),
      ),
    );
  }


  Widget BackInfo(){
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:5.0),
            child: Align(child: Text("계좌정보",style: TextStyle(fontSize: 12, color: Color(0xff888888)),),alignment: Alignment.centerLeft,),
          ),
          TextFormField(
            controller: bankCtrl,
            cursorColor: Color(0xff000000),
            decoration: InputDecoration(
              hintText: "은행명",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffdddddd), width: 2.0),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: mainColor, width: 2.0),
              ),
            ),
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
                borderSide: BorderSide(color: mainColor, width: 2.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:5.0),
            child: Align(child: Text("본인 명의의 계좌를 입력해주세요.",style: TextStyle(fontSize: 12, color: Color(0xff888888)),),alignment: Alignment.centerRight,),
          )
        ],
      ),
    );
  }

  Widget nextBtn(context){
    return Container(
      width: double.infinity,
      height: 40,
      child: RaisedButton(
        onPressed: (){
          Map<String, dynamic> args = {
            "company_name": nameCtrl.text,
            "license_number": bnCtrl.text,
            "representative": ownerCtrl.text,
            "tel":telCtrl.text,
            "email": emailCtrl.text,
            "bank": bankCtrl.text,
            "account": accountCtrl.text,
            "bl":blUri
          };
          Navigator.of(context).pushNamed("/store/apply2",arguments: args);
        },
        child: Text("다음"),
        textColor: Colors.white,
          color: mainColor,
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
            padding: const EdgeInsets.only(top:5.0),
            child: Align(child: Text("사업자등록증",style: TextStyle(fontSize: 12, color: Color(0xff888888)),),alignment: Alignment.centerLeft,),
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffdddddd))
            ),
            child: Row(
              children: [
                InkWell(
                  child: Container(
                    width: 80,
                    color: Colors.white,
                    child: Center(child: Text("파일첨부"),),
                  ),
                  onTap: (){
                    getImage();
                  },
                ),
                Flexible(
                  child: Container(
                    height: 40,
                    color: Color(0xffeeeeee),
                    child: Align(alignment: Alignment.centerLeft,child: Text(filePath,overflow: TextOverflow.ellipsis,)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:5.0),
            child: Align(child: Text("저해상도의 경우 승인 거부의 사유가 될 수 있습니다.",style: TextStyle(fontSize: 12, color: Color(0xff888888)),),alignment: Alignment.centerRight,),
          )
        ],
      ),
    );
  }

}

