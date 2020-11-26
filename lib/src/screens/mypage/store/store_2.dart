import 'dart:io';

import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/TextFieldWidget.dart';
import 'package:cashcook/src/widgets/TextFieldssWidget.dart';
import 'package:cashcook/src/widgets/TextFieldsWidget.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';



class StoreApplySecondStep extends StatefulWidget {
  @override
  _StoreApplySecondStepState createState() => _StoreApplySecondStepState();
}

class _StoreApplySecondStepState extends State<StoreApplySecondStep> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  TextEditingController descSrtCtrl = TextEditingController();

  TextEditingController timeCtrl1 = TextEditingController();
  TextEditingController timeCtrl2 = TextEditingController();
  TextEditingController timeCtrl3 = TextEditingController();

  TextEditingController storeTimeCtrl = TextEditingController();
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

  String category = "음식점";
  String sub_category = "한식";

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
        title: Text("매장 정보 1/3", style:appBarDefaultText),
        centerTitle: true,
        elevation: 0.5,
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
          children: [
            Padding(
              padding: const EdgeInsets.only(top:5.0),
              child: Align(child: Text("업종",style: Body2,),alignment: Alignment.centerLeft,),
            ),
            Consumer<StoreServiceProvider>(
              builder: (context, ssp, _) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child:Row(
                      children:[
                        Expanded(
                            flex: 1,
                            child:DropdownButton(
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down, color: primary,),
                              iconSize: 24,
                              elevation: 16,
                              underline: Container(
                                height: 2,
                                color: Color(0xFFDDDDDD),
                              ),
                              value: ssp.selectCat ,
                              items: ssp.catList.map((value) {
                                return DropdownMenuItem(
                                  value: value.code_name,
                                  child: Text(value.code_name),
                                );
                              }
                              ).toList(),
                              onChanged: (value){
                                ssp.fetchNewCategory(value);
                              },
                            )
                        ),
                        whiteSpaceW(5),
                        Expanded(
                          flex: 1,
                          child: DropdownButton(
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down, color: primary,),
                            iconSize: 24,
                            elevation: 16,
                            underline: Container(
                              height: 2,
                              color: Color(0xFFDDDDDD),
                            ),
                            value: ssp.selectSubCat,
                            items: ssp.subCatList.map((value) {
                              return DropdownMenuItem(
                                value: value.code_name,
                                child: Text(value.code_name),
                              );
                            }
                            ).toList(),
                            onChanged: (value){
                              ssp.setSubCat(value);
                            },
                          ),
                        )
                      ]
                  ),
                );
              }
            ),
            Padding(
              padding: const EdgeInsets.only(top:5.0),
              child: Align(child: Text("고객에게 보여질 업종을 선택해주세요.",style: Body2,),alignment: Alignment.centerRight,),
            ),
            textField("매장명", "사업자등록증의 상호명을 입력해주세요.", nameCtrl,TextInputType.text),
            textField("매장요약", "20자 내외로 입력해주세요.", descSrtCtrl,TextInputType.text),
            Padding(
              padding: const EdgeInsets.only(top:5.0),
              child: Align(child: Text("매장설명",style: Body2,),alignment: Alignment.centerLeft,),
            ),
            whiteSpaceH(5),
            TextFormField(
              autofocus: false,
              maxLines: 4,
              controller: descCtrl,
              style: Subtitle2.apply(
                fontWeightDelta: -2
              ),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff888888)
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:primary
                      )
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:5.0),
              child: Align(child: Text("100자 내외로 입력해주세요.",style: Body2,),alignment: Alignment.centerRight,),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(child: Text("매장 연락처",style: Body2,),alignment: Alignment.centerLeft,),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: textFieldss( timeCtrl1,TextInputType.phone)
                        ),
                        Text("-",style: Body2,),
                        Expanded(
                            child: textFields( timeCtrl2,TextInputType.phone)
                        ),
                        Text("-",style: Body2,),
                        Expanded(
                            child: textFields( timeCtrl3,TextInputType.phone)
                        ),
                      ]
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:5.0),
                    child: Align(child: Text("연락가능한 연락처를 입력하여주세요",style: Body2,),alignment: Alignment.centerRight,),
                  ),

                ]
            ),
            textField("매장 영업시간", "매장 영업시간을 입력해주세요.", storeTimeCtrl,TextInputType.text),
            addressInfo(context),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Align(
                child: Text(
                  "매장사진",
                  style: Body2,
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
        .copyWith(fontSize: 14, color: primary);
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
                style: Body2,
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
                borderSide: BorderSide(color: primary, width: 2.0),
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
                      Body1.apply(
                        color: primary
                      ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffdddddd), width: 2.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: primary, width: 2.0),
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
                style: Body2,
              ),
              alignment: Alignment.centerRight,
            ),
          )
        ],
      ),
    );
  }

  Widget nextBtn(context) {
    return
      Consumer<StoreServiceProvider>(
        builder: (context, sp, _) {
          return Container(
            width: double.infinity,
            height: 40,
            child: RaisedButton(
              onPressed: () async {
                Map<String, String> data = {
                  "company_name": company_name,
                  "business_number": license_number,
                  "owner": representative,
                  "tel": tel,
                  "email": email,
                  "bank": bank,
                  "account": account,
                  "shop_name": nameCtrl.text,
                  "shop_srt_description" : descSrtCtrl.text,
                  "shop_description": descCtrl.text,
                  "shop_tel": timeCtrl1.text+timeCtrl2.text+timeCtrl3.text,
                  "store_time": storeTimeCtrl.text,
                  "address": addressCtrl.text,
                  "address_detail": detailCtrl.text,
                  "useDL": isDl.toString(),
                  "latitude": lat.toString(),
                  "longitude": lon.toString(),
                  "category_code": sp.selectCat_code,
                  "category_sub_code": sp.selectSubCat_code,
                };
                print("----------------");
                print("$tel");
                print("----------------");

                if(nameCtrl.text == '' || nameCtrl.text == null ) {
                  Fluttertoast.showToast(msg: "매장명을 입력해 주세요");
                } else if(descSrtCtrl.text  == '' || descSrtCtrl.text == null){
                  Fluttertoast.showToast(msg: "매장설명을 입력해 주세요");
                } else if(timeCtrl1.text == '' || timeCtrl1.text == null ||
                    timeCtrl2.text == '' || timeCtrl2.text == null ||
                    timeCtrl3.text == '' || timeCtrl3.text == null ){
                  Fluttertoast.showToast(msg: "매장 연락처를 입력해 주세요");
                } else if(timeCtrl1.text.length < 3 || timeCtrl2.text.length < 4 || timeCtrl3.text.length < 4){
                  Fluttertoast.showToast(msg: "전화 번호의 자릿수가 부족 합니다.");
                } else if(storeTimeCtrl.text == '' || storeTimeCtrl.text == null ){
                  Fluttertoast.showToast(msg: "영업시간을 입력해 주세요");
                } else if(addressCtrl.text == '' || addressCtrl.text == null ){
                  Fluttertoast.showToast(msg: "매장 주소를 입력해 주세요");
                } else if(detailCtrl.text == '' || detailCtrl.text == null ){
                  Fluttertoast.showToast(msg: "매장 상세주소를 입력해 주세요");
                } else if(shop1_uri == '' || shop1_uri == null ||
                    shop2_uri == '' || shop2_uri == null ||
                    shop3_uri == '' || shop3_uri == null ){
                  Fluttertoast.showToast(msg: "3개의 매장 사진을 첨부해 주세요");
                } else {
                  await Provider.of<StoreProvider>(context, listen: false).bak_store2(data, blUri, shop1_uri, shop2_uri, shop3_uri);
                  Navigator.of(context).pushNamed("/store/apply3");
                }
              },
              child: Text("다음"),
              textColor: Colors.white,
              color: primary,
            ),
          );
        },
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
                Flexible(
                  child: Container(
                    height: 40,
                    color: Color(0xffDDDDDD),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          filePath,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ),
                ),
                InkWell(
                  child: Container(
                    width: 90,
                    color: primary,
                    child: Center(child: Text("파일첨부",
                        style: Body2.apply(
                          color: white
                        )),),
                  ),
                  onTap: () {
                    getImage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
