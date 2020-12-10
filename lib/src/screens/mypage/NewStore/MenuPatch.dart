import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/provider/StoreApplyProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/mypage/NewStore/BigMenuListPage.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MenuPatch extends StatefulWidget {
  final MenuModel menu;

  MenuPatch({this.menu});

  @override
  _MenuPatch createState() => _MenuPatch();
}

class _MenuPatch extends State<MenuPatch> {
  TextEditingController nameCtrl;
  TextEditingController priceCtrl;
  PickedFile imgCtrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameCtrl = TextEditingController(text: widget.menu.name);
    priceCtrl = TextEditingController(text: widget.menu.price.toString());
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text(
          "${widget.menu.name} 수정",
          style: appBarDefaultText
      ),
      centerTitle: true,
      elevation: 0.5,
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
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          PickedFile pickedImg = await ImagePicker().getImage(source: ImageSource.gallery);

                          if(pickedImg != null) {
                            setState(() {
                              imgCtrl = pickedImg;
                            });
                          }
                        },
                        child: widget.menu.imgUrl == null ?
                        imgCtrl == null ?
                        Container(
                          width: 48,
                          height: 48,
                          child: Center(
                            child: Image.asset(
                              "assets/resource/public/plus.png",
                              width: 24,
                              height: 24,
                              fit: BoxFit.fill,
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(6.0)
                              ),
                              border: Border.all(
                                  color: Color(0xFFDDDDDD),
                                  width: 0.5
                              )
                          ),
                        )
                        :
                        Container(
                          width: 48,
                          height: 48,
                          child: Image.file(
                            File(imgCtrl.path),
                            fit: BoxFit.cover,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.all(
                                Radius.circular(6.0)
                            ),
                            border: Border.all(
                                color: Color(0xFFDDDDDD),
                                width: 0.5
                            ),
                          ),
                        )
                            :
                        imgCtrl == null ?
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.all(
                                Radius.circular(6.0)
                            ),
                            border: Border.all(
                                color: Color(0xFFDDDDDD),
                                width: 0.5
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                widget.menu.imgUrl,
                              )
                            )
                          ),
                        )
                            :
                        Container(
                          width: 48,
                          height: 48,
                          child: Image.file(
                            File(imgCtrl.path),
                            fit: BoxFit.cover,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.all(
                                Radius.circular(6.0)
                            ),
                            border: Border.all(
                                color: Color(0xFFDDDDDD),
                                width: 0.5
                            ),
                          ),
                        ),
                      ),
                      whiteSpaceW(16.0),
                      Expanded(
                          child: TextFormField(
                            controller: nameCtrl,
                            style: Body1.apply(
                                color: black,
                                fontWeightDelta: 1
                            ),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent
                                  )
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent
                                  )
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                ),
                whiteSpaceH(20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("메뉴 가격",
                          style: Body2
                      ),
                      whiteSpaceH(8),
                      Row(
                        children: [
                          Image.asset(
                            "assets/resource/public/krw-coin.png",
                            width: 36,
                            height: 36,
                            fit: BoxFit.fill,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: priceCtrl,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.end,
                              style: Subtitle2.apply(
                                  fontWeightDelta: -2
                              ),
                              decoration: InputDecoration(
                                suffixText: "원",
                                suffixStyle: Subtitle2.apply(
                                    fontWeightDelta: -2
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: black, width: 2.0),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: RaisedButton(
                    elevation: 0,
                    onPressed: (nameCtrl.text != "" && priceCtrl.text != "") ?  () {
                      Provider.of<StoreApplyProvider>(context, listen: false).patchMenu(widget.menu.id, nameCtrl.text, priceCtrl.text, imgCtrl).then((value) async
                      {
                        if(value) {
                          showToast("메뉴가 수정되었습니다.");
                          PaintingBinding.instance.imageCache.clear();

                          Navigator.of(context).pop();
                        }
                        else {
                          showToast("메뉴 수정에 실패했습니다.");
                          Navigator.of(context).pop();
                        }
                      });
                    } : null,
                    disabledColor: deActivatedGrey,
                    color: primary,
                    child: Text("수정하기",
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