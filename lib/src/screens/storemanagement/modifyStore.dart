import 'dart:io';

import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/store/menuedit.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/TextFieldWidget.dart';
import 'package:cashcook/src/widgets/TextFieldsWidget.dart';
import 'package:cashcook/src/widgets/TextFieldssWidget.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class ModifyStore extends StatefulWidget {

  @override
  _ModifyStoreState createState() => _ModifyStoreState();
}

class _ModifyStoreState extends State<ModifyStore> {
  TextEditingController nameCtrl = TextEditingController();

  TextEditingController descCtrl = TextEditingController();

  TextEditingController telCtrl = TextEditingController();
  TextEditingController telCtrl1 = TextEditingController();
  TextEditingController telCtrl2 = TextEditingController();
  TextEditingController telCtrl3 = TextEditingController();

  TextEditingController negotiableTimeCtrl = TextEditingController();

  TextEditingController addressCtrl = TextEditingController();

  TextEditingController detailCtrl = TextEditingController();

  TextEditingController commentCtrl = TextEditingController();

  @override
  void initState() {
    StoreModel store = Provider.of<UserProvider>(context,listen: false).storeModel;
    nameCtrl.text = store.store.name;
    descCtrl.text = store.store.description;

    telCtrl.text = store.store.tel;
    telCtrl1.text = store.store.tel.substring(0,3);
    telCtrl2.text = store.store.tel.substring(3,7);
    telCtrl3.text = store.store.tel.substring(7,11);

    commentCtrl.text = store.store.comment;

    negotiableTimeCtrl.text = store.store.store_time;
    addressCtrl.text = store.address.address;
    detailCtrl.text = store.address.detail;
  }

  String shop1_uri = "";

  String shop2_uri = "";

  String shop3_uri = "";

  setShop1Uri(String uri){
    shop1_uri = uri;
  }

  setShop2Uri(String uri){
    shop2_uri = uri;
  }

  setShop3Uri(String uri){
    shop3_uri = uri;
  }

  double lat;

  double lon;

  // view Controll variable
  int view = 0;

  @override
  Widget build(BuildContext context) {
    print(lat);
    print(lon);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("매장정보 수정",
          style: TextStyle(
            color: Color(0xFF444444),
            fontSize: 14,
            fontFamily: 'noto'
          )
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(top: false, child: body(context)),
    );
  }

  Widget body(context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top:12.0, left: 12.0, right: 12.0),
              child:Row(
                children: [
                  InkWell(
                      onTap: () {
                        if(view != 0){
                          setState(() {
                            view = 0;
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 12.0),
                          child: Text("매장정보",
                              style: TextStyle(
                                  color: view == 0 ? mainColor : Color(0xFF444444),
                                  fontSize: 14,
                                  fontFamily: 'noto'
                              )
                          ),
                        decoration: view == 0 ? BoxDecoration(
                          border: Border(bottom: BorderSide(color: mainColor, width: 4.0))
                        ) : BoxDecoration(),
                      )
                  ),
                  whiteSpaceW(20),
                  InkWell(
                      onTap: () {
                        if(view != 1){
                          setState(() {
                            view = 1;
                          });
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: Text("메뉴정보",
                              style: TextStyle(
                                  color: view == 1 ? mainColor : Color(0xFF444444),
                                  fontSize: 14,
                                  fontFamily: 'noto'
                              )),
                        decoration: view == 1 ? BoxDecoration(
                            border: Border(bottom: BorderSide(color: mainColor, width: 4.0))
                        ) : BoxDecoration(),
                      )
                  ),
                  whiteSpaceW(20),
                  InkWell(
                      onTap: () {
                        if(view != 2){
                          setState(() {
                            view = 2;
                          });
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: Text("기타정보",
                              style: TextStyle(
                                  color: view == 2 ? mainColor : Color(0xFF444444),
                                  fontSize: 14,
                                  fontFamily: 'noto'
                              )),
                        decoration: view == 2 ? BoxDecoration(
                            border: Border(bottom: BorderSide(color: mainColor, width: 4.0))
                        ) : BoxDecoration(),
                      )
                  )
                ],
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height:1,
                color: Color(0xFFEEEEEE)
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              child:
              (view == 0) ?
                infoForm()
                  :
              (view == 1) ?
                  menuForm()
                  :
                  commentForm()
            )

          ],
        ),
      ),
    );
  }
  
  Widget infoForm() {
    return Column(
      children: [
        textField("매장명", "사업자등록증의 상호명을 입력해주세요.", nameCtrl,TextInputType.text),
        textField("매장설명", "100자 내외로 입력해주세요.", descCtrl,TextInputType.text),
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(child: Text("매장 연락처",
                style: TextStyle(fontSize: 12, color: Color(0xff888888)),),
                alignment: Alignment.centerLeft,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: textFieldss(telCtrl1, TextInputType.phone)),
                    Text("-", style: TextStyle(
                        fontSize: 12, color: Color(0xff888888)),),
                    Expanded(
                        child: textFields(telCtrl2, TextInputType.phone)),
                    Text("-", style: TextStyle(
                        fontSize: 12, color: Color(0xff888888)),),
                    Expanded(
                        child: textFields(telCtrl3, TextInputType.phone)),
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
          padding: const EdgeInsets.only(top:40.0),
          child: nextBtn(context),
        )
      ],
    );
  }

  Widget menuForm() {
    int bigIdx = 0;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<StoreProvider>(context, listen: false).fetchEditMenu(
        Provider.of<UserProvider>(context, listen: false).storeModel.id
      );
    });

    return  Consumer<StoreProvider>(
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

  Widget commentForm(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text("기타정보",
        style: TextStyle(
          fontSize: 12,
          color: Color(0xFF888888),
          fontFamily: 'noto',
        )
    ),
    whiteSpaceH(10),
    TextFormField(
    autofocus: false,
    maxLines: 6,
    controller: commentCtrl,
    style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'noto',
    ),
    decoration: InputDecoration(
    hintText: '기타 정보를 입력하여주세요.(원산지 표시 등)',
    border: OutlineInputBorder(
    borderSide: BorderSide(
    color:Colors.black
    )
    ),
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
    color:mainColor
    )
    )
    ),
    ),
    ]
    );
  }

  Widget nextBtn(context){
    return Container(
      width: double.infinity,
      height: 40,
      child: RaisedButton(
        onPressed: () async {
          StoreModel store = Provider.of<UserProvider>(context,listen: false).storeModel;

          Map<String, String> data = {};
          if(nameCtrl.text.length < 1) Fluttertoast.showToast(msg: "매장명을 입력해주세요.");
          if(descCtrl.text.length < 1) Fluttertoast.showToast(msg: "매장설명을 입력해주세요.");
          if(negotiableTimeCtrl.text.length < 1) Fluttertoast.showToast(msg: "흥정시간을 입력해주세요.");
          if(addressCtrl.text.length < 1) Fluttertoast.showToast(msg: "매장주소를 입력해주세요.");
          if(detailCtrl.text.length < 1) Fluttertoast.showToast(msg: "매장상세주소를 입력해주세요.");

          if(store.store.name != nameCtrl.text) data["shop_name"] = nameCtrl.text;
          if(store.store.description != descCtrl.text) data["shop_description"] = descCtrl.text;
          if(store.store.store_time != negotiableTimeCtrl.text) data["store_time"] = negotiableTimeCtrl.text;
          if(store.store.tel != telCtrl1.text + telCtrl2.text + telCtrl3.text) data["shop_tel"] = telCtrl1.text + telCtrl2.text + telCtrl3.text;
          if(store.address.address != addressCtrl.text) {
            data["address"] = addressCtrl.text;
            data["latitude"] = lat.toString();
            data["longitude"] = lon.toString();
          }
          if(store.address.detail != detailCtrl.text) data["address_detail"] = detailCtrl.text;


          if( telCtrl1.text.length < 3 || telCtrl2.text.length < 4 ||  telCtrl3.text.length < 4 ){
            Fluttertoast.showToast(msg: "전화 번호의 자릿수가 부족 합니다.");
          }else{

            bool isReturn = await Provider.of<StoreProvider>(context,listen: false).patchStore(data, "", shop1_uri, shop2_uri, shop3_uri);

            if(isReturn){
              Fluttertoast.showToast(msg: "가맹점 수정이 성공하였습니다.");
              DefaultCacheManager cacheManager = new DefaultCacheManager();
              cacheManager.emptyCache();
            }else {
              Fluttertoast.showToast(msg: "가맹점 수정이 실패하였습니다.");
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

  TextStyle _decorationStyleOf(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.subhead
        .copyWith(fontSize: 14, color: mainColor);
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

