import 'dart:io';

import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
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



class StoreApplyLastStep extends StatefulWidget {
  @override
  _StoreApplyLastStepState createState() => _StoreApplyLastStepState();
}

class _StoreApplyLastStepState extends State<StoreApplyLastStep> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();

  TextEditingController timeCtrl1 = TextEditingController();
  TextEditingController timeCtrl2 = TextEditingController();
  TextEditingController timeCtrl3 = TextEditingController();

  TextEditingController negotiableTimeCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController detailCtrl = TextEditingController();
   String company_name;

   String license_number;

   String representative;

   String tel;

   String email;

   String bank;

   String account;

  String blUri;

   String shop1_uri;

  String shop2_uri;

  String shop3_uri;

  bool isDl = true;

  double lat;
  double lon;

   setShop1Uri(String uri){
     shop1_uri = uri;
   }

  setShop2Uri(String uri){
    shop2_uri = uri;
  }

  setShop3Uri(String uri){
    shop3_uri = uri;
  }

  setIsDl(bool dl){
     isDl = dl;
  }



  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    company_name = args['company_name'];
    license_number = args['license_number'];
    representative = args['representative'];
    tel = args['tel'];
    email = args['email'];
    bank = args['bank'];
    account = args['account'];
    blUri = args['bl'];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("제휴매장 등록하기 2/2"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(top:false ,child: body(context)),
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
            textField("매장명", "사업자등록증의 상호명을 입력해주세요.", nameCtrl,TextInputType.text),
            textField("매장설명", "100자 내외로 입력해주세요.", descCtrl,TextInputType.text),
            //textField("매장 연락처", "연락가능한 연락처를 입력하여주세요.", timeCtrl,TextInputType.phone),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(child: Text("매장 연락처",style: TextStyle(fontSize: 12, color: Color(0xff888888)),),alignment: Alignment.centerLeft,),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 90,  child: textFieldss( timeCtrl1,TextInputType.phone)),
                        Text("-",style: TextStyle(fontSize: 12, color: Color(0xff888888)),),
                        SizedBox(width: 125, child: textFields( timeCtrl2,TextInputType.phone)),
                        Text("-",style: TextStyle(fontSize: 12, color: Color(0xff888888)),),
                        SizedBox(width: 125, child: textFields( timeCtrl3,TextInputType.phone)),
                      ]
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:5.0),
                    child: Align(child: Text("연락가능한 연락처를 입력하여주세요",style: TextStyle(fontSize: 12, color: Color(0xff888888)),),alignment: Alignment.centerRight,),
                  ),

                ]
            ),
            textField("흥정시간", "실시간 흥정 가능시간.", negotiableTimeCtrl,TextInputType.text),
            addressInfo(context),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Align(
                child: Text(
                  "매장사진",
                  style: TextStyle(fontSize: 12, color: Color(0xff888888)),
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
            Pictures(setShop1Uri),
            Pictures(setShop2Uri),
            Pictures(setShop3Uri),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom:40),
              child: nextBtn(context),
            ),
//            whiteSpaceH(MediaQuery.of(context).padding.bottom)
          ],
        ),
      ),
    );
  }

  TextStyle _decorationStyleOf(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.subhead
        .copyWith(fontSize: 14, color: mainColor);
  }

  void getData(address, lat, lon){
     this.lat = lat;
     this.lon = lon;
     setState(() {
       addressCtrl.text = address;
     });
  }

  Widget addressInfo(context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Align(
              child: Text(
                "매장주소",
                style: TextStyle(fontSize: 12, color: Color(0xff888888)),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          TextFormField(
            enabled: false,
            controller: addressCtrl,
            cursorColor: Color(0xff000000),
            decoration: InputDecoration(
              hintText: "주소입력",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffdddddd), width: 2.0),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: mainColor, width: 2.0),
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Builder(builder: (context) {
                return InkWell(
                    onTap: (){
                      Map<String, dynamic> args = {
                        "getData": getData,
                      };
                      Navigator.of(context).pushNamed("/store/findAddress",arguments: args);
                    },
                    child: Text(
                      "지도찾기",
                      style: _decorationStyleOf(context),
                    ));
              }),
              TextFormField(
                controller: detailCtrl,
                cursorColor: Color(0xff000000),
                decoration: InputDecoration(
                  suffix: InkWell(
                      onTap: () {
                        Map<String, dynamic> args = {
                          "getData": getData,
                        };
                        Navigator.of(context).pushNamed("/store/findAddress",arguments: args);
                      },
                      child: Text("지도찾기")),
                  suffixStyle:
                      TextStyle(fontSize: 14, color: mainColor),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffdddddd), width: 2.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: mainColor, width: 2.0),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Align(
              child: Text(
                "지도에서 매장의 위치를 지정해주세요.",
                style: TextStyle(fontSize: 12, color: Color(0xff888888)),
              ),
              alignment: Alignment.centerRight,
            ),
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
//          List<double> latlon =await AddressToCoordinates(addressCtrl.text);
          Map<String, String> data = {
            "company_name": company_name,
            "business_number": license_number,
            "owner": representative,
            "tel": tel,
            "email": email,
            "bank": bank,
            "account": account,
            "shop_name": nameCtrl.text,
            "shop_description": descCtrl.text,
            "shop_tel": timeCtrl1.text+timeCtrl2.text+timeCtrl3.text,
            "negotiable_time": negotiableTimeCtrl.text,
            "address": addressCtrl.text,
            "address_detail": detailCtrl.text,
            "useDL": isDl.toString(),
            "latitude": lat.toString(),
            "longitude": lon.toString(),
          };
          print("----------------");
          print("$tel");
          print("----------------");

          if(nameCtrl.text == '' || nameCtrl.text == null ) {
            Fluttertoast.showToast(msg: "매장명을 입력해 주세요");
          } else if(descCtrl.text  == '' || descCtrl.text == null){
            Fluttertoast.showToast(msg: "매장설명을 입력해 주세요");
          } else if(timeCtrl1.text == '' || timeCtrl1.text == null ||
              timeCtrl2.text == '' || timeCtrl2.text == null ||
              timeCtrl3.text == '' || timeCtrl3.text == null ){
            Fluttertoast.showToast(msg: "매장 연락처를 입력해 주세요");
          } else if(timeCtrl1.text.length < 3 || timeCtrl2.text.length < 4 || timeCtrl3.text.length < 4){
            Fluttertoast.showToast(msg: "전화 번호의 자릿수가 부족 합니다.");
          } else if(negotiableTimeCtrl.text == '' || negotiableTimeCtrl.text == null ){
            Fluttertoast.showToast(msg: "흥정시간을 입력해 주세요");
          } else if(addressCtrl.text == '' || addressCtrl.text == null ){
            Fluttertoast.showToast(msg: "매장 주소를 입력해 주세요");
          } else if(detailCtrl.text == '' || detailCtrl.text == null ){
            Fluttertoast.showToast(msg: "매장 상세주소를 입력해 주세요");
          } else if(shop1_uri == '' || shop1_uri == null ||
              shop2_uri == '' || shop2_uri == null ||
              shop3_uri == '' || shop3_uri == null ){
            Fluttertoast.showToast(msg: "3개의 매장 사진을 첨부해 주세요");
          } else {
          bool isReturn = await Provider.of<StoreProvider>(context, listen: false).postStore(data, blUri, shop1_uri, shop2_uri, shop3_uri);

          if(isReturn){
            Fluttertoast.showToast(msg: "제휴매장 등록이 성공하였습니다.");
          }else {
            Fluttertoast.showToast(msg: "제휴매장 등록이 실패하였습니다.");
          }
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainMap()), (route) => false);
          }
        },
        child: Text("다음"),
        textColor: Colors.white,
        color: mainColor,
      ),
    );
  }
}

class Pictures extends StatefulWidget {

  final Function(String str) onSetUri;

  Pictures(this.onSetUri);

  @override
  _PicturesState createState() => _PicturesState();
}

class _PicturesState extends State<Pictures> {
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
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          Container(
            height: 40,
            decoration:
                BoxDecoration(border: Border.all(color: Color(0xffdddddd))),
            child: Row(
              children: [
                InkWell(
                  child: Container(
                    width: 80,
                    color: Colors.white,
                    child: Center(
                      child: Text("파일첨부"),
                    ),
                  ),
                  onTap: () {
                    getImage();
                  },
                ),
                Flexible(
                  child: Container(
                    height: 40,
                    color: Color(0xffeeeeee),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          filePath,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
