import 'dart:io';

import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/TextFieldWidget.dart';
import 'package:cashcook/src/widgets/TextFieldsWidget.dart';
import 'package:cashcook/src/widgets/TextFieldssWidget.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/model/store.dart';

class StorePatch extends StatefulWidget{
  @override
  _StorePatch createState() => _StorePatch();
}

class _StorePatch extends State<StorePatch> {
  TextEditingController nameCtrl = TextEditingController();

  TextEditingController descSrtCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();

  TextEditingController telCtrl = TextEditingController();
  TextEditingController telCtrl1 = TextEditingController();
  TextEditingController telCtrl2 = TextEditingController();
  TextEditingController telCtrl3 = TextEditingController();

  TextEditingController storeTimeCtrl = TextEditingController();

  TextEditingController addressCtrl = TextEditingController();

  TextEditingController detailCtrl = TextEditingController();

  String shop1_uri = "";

  String shop2_uri = "";

  String shop3_uri = "";

  double lat;

  double lon;
  @override
  void initState() {
    StoreModel store = Provider.of<UserProvider>(context,listen: false).storeModel;
    nameCtrl.text = store.store.name;
    descSrtCtrl.text = store.store.short_description;
    descCtrl.text = store.store.description;

    telCtrl.text = store.store.tel;
    telCtrl1.text = store.store.tel.substring(0,3);
    telCtrl2.text = store.store.tel.substring(3,7);
    telCtrl3.text = store.store.tel.substring(7,11);

    storeTimeCtrl.text = store.store.store_time;
    addressCtrl.text = store.address.address;
    detailCtrl.text = store.address.detail;

    shop1_uri = store.store.shop_img1;
    shop2_uri = store.store.shop_img2;
    shop3_uri = store.store.shop_img3;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<StoreServiceProvider>(context, listen: false).fetchEditCategory(store.store.category_code, store.store.category_sub_code);
    });
  }

  setShop1Uri(String uri){
    shop1_uri = uri;
  }

  setShop2Uri(String uri){
    shop2_uri = uri;
  }

  setShop3Uri(String uri){
    shop3_uri = uri;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: Text(
          "기본정보",
          style: appBarDefaultText,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:5.0),
                child: Align(child: Text("업종",style: Body2,),alignment: Alignment.centerLeft,),
              ),
              Consumer<StoreServiceProvider>(
                  builder: (context, ssp, _) {
                    return ssp.isCategoryFetching ?
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child:Row(
                          children:[
                            Expanded(
                                flex: 1,
                                child: Container(
                                  height: 40,
                                  child: Center(
                                      child: Container(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                            valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
                                        ),
                                      )
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: deActivatedGrey,
                                          width: 1,
                                        )
                                      )
                                  ),
                                )
                            ),
                            whiteSpaceW(5),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  height: 40,
                                  child: Center(
                                      child: Container(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                            valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
                                        ),
                                      )
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                            color: deActivatedGrey,
                                            width: 1,
                                          )
                                      )
                                  ),
                                )
                            )
                          ]
                      ),
                    )
                        : Container(
                      width: MediaQuery.of(context).size.width,
                      child:Row(
                          children:[
                            Expanded(
                                flex: 1,
                                child:DropdownButton(
                                  isExpanded: true,
                                  icon: Icon(Icons.arrow_drop_down, color: mainColor,),
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
                                icon: Icon(Icons.arrow_drop_down, color: mainColor,),
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
                    fontWeightDelta: -1
                ),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xff888888)
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:mainColor
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
                    Align(child: Text("매장 연락처",
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
                        style: Body2,),
                        alignment: Alignment.centerRight,),
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
              Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child:Row(
                      children: [
                        Pictures(
                          onSetUri: setShop1Uri,
                          initUri: shop1_uri,),
                        Pictures(
                          onSetUri: setShop2Uri,
                          initUri: shop2_uri,),
                        Pictures(
                          onSetUri: setShop3Uri,
                          initUri: shop3_uri,),
                      ],
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:40.0),
                child: nextBtn(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _decorationStyleOf(BuildContext context) {
    return Body1.apply(
        color: primary
    );
  }

  void getData(address, lat, lon){
    print("getData");
    this.lat = lat;
    this.lon = lon;
    setState(() {
      print(address);
      addressCtrl.text = address;
      print(addressCtrl.text);
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
                  suffixStyle: _decorationStyleOf(context),
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
                  style: Body2
              ),
              alignment: Alignment.centerRight,
            ),
          )
        ],
      ),
    );
  }

  Widget nextBtn(context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 8),
      child:
      Consumer<StoreServiceProvider>(
        builder: (context, ssp, _) {
          return RaisedButton(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(6.0)
                )
            ),
            onPressed: () async {
              StoreModel store = Provider.of<UserProvider>(context,listen: false).storeModel;

              Map<String, String> data = {};
              if(nameCtrl.text.length < 1) Fluttertoast.showToast(msg: "매장명을 입력해주세요.");
              if(descCtrl.text.length < 1) Fluttertoast.showToast(msg: "매장설명을 입력해주세요.");
              if(storeTimeCtrl.text.length < 1) Fluttertoast.showToast(msg: "매장영업시간을 입력해주세요.");
              if(addressCtrl.text.length < 1) Fluttertoast.showToast(msg: "매장주소를 입력해주세요.");
              if(detailCtrl.text.length < 1) Fluttertoast.showToast(msg: "매장상세주소를 입력해주세요.");

              if(store.store.name != nameCtrl.text) data["shop_name"] = nameCtrl.text;
              if(store.store.short_description != descSrtCtrl.text) data["shop_srt_description"] = descSrtCtrl.text;
              if(store.store.description != descCtrl.text) data["shop_description"] = descCtrl.text;
              if(store.store.store_time != storeTimeCtrl.text) data["store_time"] = storeTimeCtrl.text;
              if(store.store.tel != telCtrl1.text + telCtrl2.text + telCtrl3.text) data["shop_tel"] = telCtrl1.text + telCtrl2.text + telCtrl3.text;
              if(store.address.address != addressCtrl.text) {
                data["address"] = addressCtrl.text;
                data["latitude"] = lat.toString();
                data["longitude"] = lon.toString();
              }
              if(store.address.detail != detailCtrl.text) data["address_detail"] = detailCtrl.text;

              if(
              ssp.selectCat_code != null &&
                  store.store.category_code !=
                      ssp.selectCat_code
              )
                data["category_code"] = ssp.selectCat_code;
              if(
              ssp.selectSubCat_code != null &&
                  store.store.category_sub_code !=
                      ssp.selectSubCat_code
              )
                data["category_sub_code"] = ssp.selectSubCat_code;

              if( telCtrl1.text.length < 3 || telCtrl2.text.length < 4 ||  telCtrl3.text.length < 4 ){
                Fluttertoast.showToast(msg: "전화 번호의 자릿수가 부족 합니다.");
              }

              if( store.store.shop_img1 != shop1_uri) {
                data['shop_uri1'] = shop1_uri;
              }

              if( store.store.shop_img2 != shop2_uri) {
                data['shop_uri2'] = shop2_uri;
              }

              if( store.store.shop_img3 != shop3_uri) {
                data['shop_uri3'] = shop3_uri;
              }

              bool isReturn = await Provider.of<StoreProvider>(context,listen: false).patchStore(data, "");

              if(isReturn){
                Fluttertoast.showToast(msg: "가맹점 수정이 성공하였습니다.");
                PaintingBinding.instance.imageCache.clear();
              }else {
                Fluttertoast.showToast(msg: "가맹점 수정이 실패하였습니다.");

              }

              await Provider.of<StoreProvider>(context, listen: false).clearMap();
              await Provider.of<StoreProvider>(context, listen: false).hideDetailView();
              await Provider.of<UserProvider>(context, listen: false).fetchMyInfo();

              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainMap()), (route) => false);
            },
            child: Text("수정",
              style: Subtitle2.apply(
                  color: white,
                  fontWeightDelta: 1
              ),
            ),
            color: mainColor,
          );
        },
      ),
    );
  }
}

class Pictures extends StatefulWidget {

  final Function(String str) onSetUri;
  final String initUri;

  Pictures({this.onSetUri, this.initUri});

  @override
  _PicturesState createState() => _PicturesState();
}

class _PicturesState extends State<Pictures> {
  final picker = ImagePicker();
  File _image;
  String filePath;


  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
      // filePath = pickedFile.path.split("/").last;
      filePath = _image.absolute.path;
      widget.onSetUri(_image.absolute.path);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filePath = widget.initUri;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child:
      Container(
        width: 104,
        height: 104,
        margin: EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          color: deActivatedGrey,
          borderRadius: BorderRadius.all(
              Radius.circular(6)
          ),
          border: Border.all(
              color: third,
              width: 0.5
          ),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: filePath == widget.initUri ?
              NetworkImage(
                widget.initUri,
              )
                  :
              FileImage(
                  File(filePath)
              )
          ),
        ),
      ),
      onTap: () {
        getImage();
      },
    );
  }
}