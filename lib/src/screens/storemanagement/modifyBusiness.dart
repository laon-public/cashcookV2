import 'dart:io';

import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/screens/storemanagement/storemanagement.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/TextFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/widgets/TextFieldsWidget.dart';
import 'package:cashcook/src/widgets/TextFieldssWidget.dart';


class ModifyBusiness extends StatefulWidget {
  @override
  _ModifyBusiness createState() => _ModifyBusiness();

}

class _ModifyBusiness extends State<ModifyBusiness> {

  TextEditingController nameCtrl = TextEditingController(); //상호명
  TextEditingController bnCtrl = TextEditingController(); //사업자번호
  TextEditingController ownerCtrl = TextEditingController(); //대표자명
  TextEditingController telCtrl = TextEditingController(); //연락처

  TextEditingController telCtrl1 = TextEditingController(); //연락처
  TextEditingController telCtrl2 = TextEditingController(); //연락처
  TextEditingController telCtrl3 = TextEditingController(); //연락처

  TextEditingController emailCtrl = TextEditingController(); //이메일주소
  String bank = ""; //은행명
  TextEditingController accountCtrl = TextEditingController(); //계좌번호
  String blUri = "";

  setBlUri(uri){
    blUri = uri;
  }

//  bool check = true;

//  change(String text){
//    print(text);
//    print(text.isNotEmpty);
//    if (text.isNotEmpty) {
//      check = false;
//    } else {
//      check = true;
//    }
//  }

  @override
  Widget build(BuildContext context) {

    StoreModel store = Provider.of<UserProvider>(context,listen: false).storeModel;
    nameCtrl.text = store.company_name;
    bnCtrl.text = store.business_number;
    ownerCtrl.text = store.owner;

    telCtrl1.text = store.tel.substring(0,3);
    telCtrl2.text = store.tel.substring(3,7);
    telCtrl3.text = store.tel.substring(7,11);


    emailCtrl.text = store.store.email;
    bank = store.bank.bank;
    accountCtrl.text = store.bank.number;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("사업자정보 수정",
          style: TextStyle(
            color: Color(0xFF444444),
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            nameWidget(),
            BusinessNumber(onSetUri: setBlUri,),
            Padding(
              padding: const EdgeInsets.only(top:18.0),
              child: Align(child: Text("사업자번호",style: TextStyle(fontSize: 12, color: Color(0xff888888)),),alignment: Alignment.centerLeft,),
            ),
            TextFormField(
              controller: bnCtrl,
              cursorColor: Color(0xff000000),
              decoration: InputDecoration(
                hintText: "사업자등록증의 내용으로 입력해주세요.",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffdddddd), width: 2.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: mainColor, width: 2.0),
                ),
              ),
            ),
//            textField("사업자번호", "사업자등록증의 내용으로 입력해주세요.", bnCtrl,TextInputType.text),
            Padding(
              padding: const EdgeInsets.only(top:18.0),
              child: Align(child: Text("대표자명",style: TextStyle(fontSize: 12, color: Color(0xff888888)),),alignment: Alignment.centerLeft,),
            ),
            TextFormField(
              controller: ownerCtrl,
              cursorColor: Color(0xff000000),
              decoration: InputDecoration(
                hintText: "사업자등록증의 내용으로 입력해주세요.",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffdddddd), width: 2.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: mainColor, width: 2.0),
                ),
              ),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:18.0),
                    child: Align(child: Text("연락처",style: TextStyle(fontSize: 12, color: Color(0xff888888)),),alignment: Alignment.centerLeft,),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child:
                            TextFormField(
                              controller: telCtrl1,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.phone,
                              cursorColor: Color(0xff000000),
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xffdddddd), width: 2.0),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: mainColor, width: 2.0),
                                ),
                              ),
                            )),
                        Text("-", style: TextStyle(
                            fontSize: 12, color: Color(0xff888888)),),
                        Expanded(
                            child:
                            TextFormField(
                              controller: telCtrl2,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.phone,
                              cursorColor: Color(0xff000000),
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xffdddddd), width: 2.0),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: mainColor, width: 2.0),
                                ),
                              ),
                            )),
                        Text("-", style: TextStyle(
                            fontSize: 12, color: Color(0xff888888)),),
                        Expanded(
                            child:
                            TextFormField(
                              controller: telCtrl3,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.phone,
                              cursorColor: Color(0xff000000),
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xffdddddd), width: 2.0),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: mainColor, width: 2.0),
                                ),
                              ),
                            )),
                      ]
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Align(child: Text("연락가능한 연락처를 입력하여주세요",
                      style: TextStyle(
                          fontSize: 12, color: Color(0xff888888)),),
                      alignment: Alignment.centerRight,),
                  ),

                ]
            ),

            Padding(
              padding: const EdgeInsets.only(top:18.0),
              child: Align(child: Text("이메일 주소",style: TextStyle(fontSize: 12, color: Color(0xff888888)),),alignment: Alignment.centerLeft,),
            ),
            TextFormField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Color(0xff000000),
              decoration: InputDecoration(
                hintText: "사업자등록증의 이메일을 입력해주세요.",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffdddddd), width: 2.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: mainColor, width: 2.0),
                ),
              ),
            ),
            bankInfo(),
            Padding(
              padding: const EdgeInsets.only(top:40.0),
              child: nextBtn(context),
            )
          ],
        ),
      ),
    );
  }

  Widget nameWidget(){
    return Container(
      child: Column(
          children: [
              Padding(
                padding: const EdgeInsets.only(top:18.0),
                child: Align(child: Text("상호명",style: TextStyle(fontSize: 12, color: Color(0xff888888)),),alignment: Alignment.centerLeft,),
              ),
              TextFormField(
              controller: nameCtrl,
              cursorColor: Color(0xff000000),
              decoration: InputDecoration(
              hintText: "사업자등록증의 상호명을 입력해주세요.",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffdddddd), width: 2.0),
              ),
              focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: mainColor, width: 2.0),
              ),
              ),
              ),
            ],
          ),
        );
  }


  Widget BackInfo(){
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:18.0),
            child: Align(child: Text("계좌정보",style: TextStyle(fontSize: 12, color: Color(0xff888888)),),alignment: Alignment.centerLeft,),
          ),
          TextFormField(
            // controller: bankCtrl,
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
        onPressed: () async{
            if(nameCtrl.text.length < 1) {
              Fluttertoast.showToast(msg: "상호명을 입력해주세요.");
              return;
            }
            if(bnCtrl.text.length < 1) {
              Fluttertoast.showToast(msg: "사업자번호를 입력해주세요.");
              return;
            }
            if(nameCtrl.text.length < 1) {
              Fluttertoast.showToast(msg: "대표자명을 입력해주세요.");
              return;
            }
            if(emailCtrl.text.length < 1) {
              Fluttertoast.showToast(msg: "이메일주소를 입력해주세요.");
              return;
            }
            if(bank.length < 1) {
              Fluttertoast.showToast(msg: "은행명을 입력해주세요.");
              return;
            }
            if(accountCtrl.text.length < 1) {
              Fluttertoast.showToast(msg: "계좌번호를 입력해주세요.");
              return;
            }

            StoreModel store = Provider.of<UserProvider>(context,listen: false).storeModel;
            Map<String, String> data = {};
            if(store.company_name != nameCtrl.text) data["company_name"] = nameCtrl.text;
            if(store.business_number != bnCtrl.text) data["business_number"] = bnCtrl.text;
            if(store.owner != ownerCtrl.text) data["owner"] = ownerCtrl.text;
            if(store.tel != telCtrl1.text+telCtrl2.text+telCtrl3.text) data["tel"] = telCtrl1.text+telCtrl2.text+telCtrl3.text;
            if(store.store.email != emailCtrl.text) data["email"] = emailCtrl.text;
            if(store.bank.bank != bank) data["bank"] = bank;
            if(store.bank.number != accountCtrl.text) data["account"] = accountCtrl.text;


            if( telCtrl1.text.length < 3 || telCtrl2.text.length < 4 ||  telCtrl3.text.length < 4 ){
              Fluttertoast.showToast(msg: "전화 번호의 자릿수가 부족 합니다.");
            }else{

              bool isReturn = await Provider.of<StoreProvider>(context,listen: false).patchStore(data, blUri, "", "", "");
              if(isReturn){
                Fluttertoast.showToast(msg: "사업자정보 수정이 성공하였습니다.");
              }else {
                Fluttertoast.showToast(msg: "사업자정보 수정이 실패하였습니다.");
              }
              //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => StoreManagement()), (route) => false);
            Navigator.of(context).pop();
            }
          },
        child: Text("수정"),
        textColor: Colors.white,
        color: mainColor,
      ),
    );
  }

  Widget bankInfo() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Align(child: Text("계좌정보",
              style: TextStyle(fontSize: 12, color: Color(0xff888888)),),
              alignment: Alignment.centerLeft,),
          ),
          DropdownButton(
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down, color: mainColor,),
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
                borderSide: BorderSide(color: mainColor, width: 2.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Align(child: Text("본인 명의의 계좌를 입력해주세요.",
              style: TextStyle(fontSize: 12, color: Color(0xff888888)),),
              alignment: Alignment.centerRight,),
          )
        ],
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
            padding: const EdgeInsets.only(top:18.0,bottom: 5.0),
            child: Align(child: Text("사업자등록증",style: TextStyle(fontSize: 12, color: Color(0xff888888)),),alignment: Alignment.centerLeft,),
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffdddddd))
            ),
            child: Row(
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
                    width: 80,
                    color: mainColor,
                    child: Center(child:
                      Text("파일첨부",
                        style: TextStyle(
                          color: white,
                          fontSize: 14,
                          fontFamily: 'noto'
                        ),
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
            child: Align(child: Text("저해상도의 경우 승인 거부의 사유가 될 수 있습니다.",style: TextStyle(fontSize: 12, color: Color(0xff888888)),),alignment: Alignment.centerRight,),
          )
        ],
      ),
    );
  }

}
