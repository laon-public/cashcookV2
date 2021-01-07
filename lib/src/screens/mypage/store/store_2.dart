import 'dart:io';

import 'package:cashcook/src/model/store/menuedit.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/screens/mypage/store/storeApply.dart';
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
        title: Text("매장정보 입력", style:appBarDefaultText),
        centerTitle: true,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
        ),
      ),
      body: SafeArea(top:false ,
          child: Consumer<StoreProvider>(
            builder: (context, sp, _){
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:12, bottom: 4),
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
                                            child:
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 12),
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFF7F7F7),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(6.0)
                                                  )
                                              ),
                                              child: DropdownButton(
                                                isExpanded: true,
                                                icon: Icon(Icons.arrow_drop_down, color: black,),
                                                iconSize: 24,
                                                elevation: 16,
                                                underline: Container(
                                                  color: Colors.transparent,
                                                ),
                                                value: ssp.selectCat ,
                                                items: ssp.catList.map((value) {
                                                  return DropdownMenuItem(
                                                    value: value.code_name,
                                                    child: Text(value.code_name,
                                                        style: Subtitle2.apply(
                                                            fontWeightDelta: 1,
                                                            color: secondary
                                                        )
                                                    ),
                                                  );
                                                }
                                                ).toList(),
                                                onChanged: (value){
                                                  ssp.fetchNewCategory(value);
                                                },
                                              ),
                                            )
                                        ),
                                        whiteSpaceW(8),
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 12),
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFF7F7F7),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(6.0)
                                                  )
                                              ),
                                              child: DropdownButton(
                                                isExpanded: true,
                                                icon: Icon(Icons.arrow_drop_down, color: black,),
                                                iconSize: 24,
                                                elevation: 16,
                                                underline: Container(
                                                  color: Colors.transparent,
                                                ),
                                                value: ssp.selectSubCat,
                                                items: ssp.subCatList.map((value) {
                                                  return DropdownMenuItem(
                                                    value: value.code_name,
                                                    child: Text(value.code_name,
                                                        style: Subtitle2.apply(
                                                            fontWeightDelta: 1,
                                                            color: secondary
                                                        )
                                                    ),
                                                  );
                                                }
                                                ).toList(),
                                                onChanged: (value){
                                                  ssp.setSubCat(value);
                                                },
                                              ),
                                            )
                                        )
                                      ]
                                  ),
                                );
                              }
                          ),
                          whiteSpaceH(20),
                          textField("매장명", "사업자등록증의 상호명을 입력해주세요.", nameCtrl,TextInputType.text),

                          textField("매장 요약글", "20자 내외로 입력해주세요.", descSrtCtrl,TextInputType.text),
                          Padding(
                            padding: const EdgeInsets.only(top:5.0),
                            child: Align(child: Text("매장 설명",style: Body2,),alignment: Alignment.centerLeft,),
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
                                        color: deActivatedGrey
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: black,
                                        width: 2
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
                            padding: const EdgeInsets.only(top: 40.0, bottom: 5.0),
                            child: Align(
                              child: Text(
                                "매장사진 ${[0,1,2,3].reduce((value, element) {
                                  if(element == 1) {
                                    if(shop1_uri == null || shop1_uri == ""){
                                      return value;
                                    } else {
                                      return value + 1;
                                    }
                                  }
                                  else if(element == 2) {
                                    if(shop2_uri == null || shop2_uri == ""){
                                      return value;
                                    } else {
                                      return value + 1;
                                    }
                                  }
                                  else {
                                    if(shop3_uri == null || shop3_uri == ""){
                                      return value;
                                    } else {
                                      return value + 1;
                                    }
                                  }
                                })
                                }/3",
                                style: Body2,
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                          ),
                          Row(
                            children: [
                              Pictures(setShop1Uri, shop1_uri),
                              Pictures(setShop2Uri, shop2_uri),
                              Pictures(setShop3Uri, shop3_uri),
                            ],
                          ),
                          whiteSpaceH(52),
                          Consumer<StoreServiceProvider>(
                            builder: (context, sp, _) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                height: 60,
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
                                      await Provider.of<StoreProvider>(context, listen: false).clearSuccess();
                                      await Provider.of<StoreProvider>(context, listen: false).postStore();
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(builder: (context) => StoreApplyState()), (route) => false
                                      );
                                    }
                                  },
                                  child: Text("등록하기",
                                      style: Subtitle2.apply(
                                          color: white,
                                          fontWeightDelta: 1
                                      )
                                  ),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(6),
                                      )
                                  ),
                                  textColor: Colors.white,
                                  color: primary,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  sp.isStoreLoading ?
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        color: black.withOpacity(0.7)
                    ),
                    child: Center(
                      child: Container(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
                          )
                      ),
                    ),
                  )
                  :
                  Container(),
                ],
              );
            },
          ),
      ),
    );
  }

  setShop1Uri(String uri){
    setState(() {
      shop1_uri = uri;
    });
  }

  setShop2Uri(String uri){
    setState(() {
      shop2_uri = uri;
    });
  }

  setShop3Uri(String uri){
    setState(() {
      shop3_uri = uri;
    });
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
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom:4 ),
            child: Align(
              child: Text(
                "매장 주소",
                style: Body2,
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: deActivatedGrey,
                width: 1
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(4.0)
              ),
              color: Color(0xFFF7F7F7)
            ),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: addressCtrl,
                    cursorColor: Color(0xff000000),
                    style: Subtitle2.apply(
                        color: secondary,
                        fontWeightDelta: 1
                    ),
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent, width: 2.0),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent, width: 2.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent, width: 2.0),
                      ),
                    ),
                  ),
                ),
                InkWell(
                    onTap: (){
                      Map<String, dynamic> args = {
                        "getData": getData,
                      };
                      Navigator.of(context).pushNamed("/store/findAddress",arguments: args);
                    },
                    child: Text(
                      "지도찾기",
                      style: Body1.apply(
                          color: primary,
                          fontWeightDelta: 1
                      ),
                    )
                )
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          TextFormField(
            controller: detailCtrl,
            cursorColor: Color(0xff000000),
            style: Subtitle2.apply(
                color: black,
                fontWeightDelta: 1
            ),
            decoration: InputDecoration(
              hintText: "상세 주소를 입력해주세요.",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintStyle: Subtitle2.apply(
                  color: third,
                  fontWeightDelta: -2
              ),
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
}

class Pictures extends StatefulWidget {

  final Function(String str) onSetUri;
  final String uri;

  Pictures(this.onSetUri, this.uri);

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
    return (widget.uri != null && widget.uri != "") ? InkWell(
      onTap: () {
        setState(() {
          widget.onSetUri("");
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 8.0),
        width: 104,
        height: 104,
        decoration: BoxDecoration(
            color: Color(0xFFF7F7F7),
            borderRadius: BorderRadius.all(
                Radius.circular(4)
            ),
            border: Border.all(
                color: Color(0xFFDDDDDD),
                width: 1
            ),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: FileImage(
                  File(widget.uri)
              ),
            )
        ),
      ),
    )
    :
    InkWell(
      onTap: () {
          getImage();
      },
      child: Container(
        margin: EdgeInsets.only(right: 8.0),
        width: 104,
        height: 104,
        child: Center(
            child: Image.asset(
              "assets/icon/plus.png",
              width: 36,
              height: 36,
            )
        ),
        decoration: BoxDecoration(
            color: Color(0xFFF7F7F7),
            borderRadius: BorderRadius.all(
                Radius.circular(4)
            ),
            border: Border.all(
                color: Color(0xFFDDDDDD),
                width: 1
            )
        ),
      ),
    );
  }
}
