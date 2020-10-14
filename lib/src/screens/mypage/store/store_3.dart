import 'dart:io';

import 'package:cashcook/src/model/menu.dart';
import 'package:cashcook/src/provider/MenuProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/TextFieldWidget.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class StoreApplythirdStep extends StatefulWidget {

  @override
  _StoreApplythirdStepState createState() => _StoreApplythirdStepState();
}

class _StoreApplythirdStepState extends State<StoreApplythirdStep>{
  ScrollController _scrollController = ScrollController();
  List<MenuModel> menuList = [];

  List<bool> tmp = [];
  
  int addCnt = 0;

  List<Map<String, String>> menu = List<Map<String, String>>();

  TextEditingController menuName = TextEditingController();
  TextEditingController menuPrice = TextEditingController();

  List<TextEditingController> menuNames = List<TextEditingController>();


  @override
  Widget build(BuildContext context) {
    menuList.add(MenuModel(menu_name: "치킨", menu_price: "10000"));
    print("menuList");
    print(menuList[0].menu_name);
    print(menuList[0].menu_price);

    loadMore(context) async {
      MenuProvider menuProvider = Provider.of<MenuProvider>(context, listen:  false);
      if(!menuProvider.isLoading){
        menuProvider.startLoading();
      }
    }

    _scrollController.addListener(() {
      if(_scrollController.offset == _scrollController.position.maxScrollExtent)
        loadMore(context);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("매장 정보 2/3"),
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
              height: 300,
              child:
                Column(
                  children: <Widget>[
                    menuAdd(),
                  ],
                ),
            ),


//            menuAdd(),


//            TextFormField(decoration: InputDecoration(hintText: "메뉴 대분류를 작성해주세요."),controller: menuCategory,),
//            whiteSpaceH(15),


//            SizedBox(height: 50,
//              child: TextFormField(
//                textInputAction: TextInputAction.done,
//                decoration: InputDecoration(border: OutlineInputBorder(), hintText: "메뉴명을 입력해주세요"), controller: menuName,),
//            ),
//            whiteSpaceH(15),
//            SizedBox(height: 50,
//              child: TextFormField(decoration: InputDecoration(border: OutlineInputBorder(), hintText: "가격을 입력해주세요"),),
//            ),
//            whiteSpaceH(10),
//            Container(
//              width: MediaQuery.of(context).size.width,
//              height: 3,
//              color: Color(0xFFDDDDDD),
//            ),
//            whiteSpaceH(15),


//            Column(
//              children: tmp2.map((e) {
//                return categoryAdd();
//              }).toList(),
//            ),
//            whiteSpaceH(15),


//            Column(
//              children: tmp.map((e) {
//                return menuAdd(addCnt);
//              }).toList(),
//            ),
            InkWell(
                onTap: (){
                  setState(() {
//                    menuNames.add(TextEditingController());
//                    tmp.add(true);
                  });
                },
                child:
                Row(
                  children: <Widget>[
                    Image.asset(
                      "assets/resource/public/plus.png",
                      width: 24,
                      height: 24,
                    ),
                    Text("메뉴추가"),
                  ],
                )
            ),
            whiteSpaceH(10),
//            Row(
//              children: <Widget>[
//                RaisedButton(
//                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/3, right: MediaQuery.of(context).size.width/3),
//                  color: white,
//                  onPressed: () {
//                    setState(() {
//                      print("tmp2");
//                      print(tmp2);
//                      tmp2.add(true);
//                      print(tmp2);
//                    });
//                  },
//                  child: Center(
//                    child: Text("대분류 추가"),
//                  ),
//                ),
//              ],
//            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 40),
              child: nextBtn(context),
            )
          ],
        ),
      ),
    );
  }

//  Widget menuAdd(addCnt) => Container(
//    child:
//      Column(
//        children: <Widget>[
//          SizedBox(height: 50,
//            child: TextFormField(
//              textInputAction: TextInputAction.done,
//              decoration: InputDecoration(border: OutlineInputBorder(), hintText: "메뉴명을 입력해주세요"), controller: menuNames[addCnt],),
////            child: textField("메뉴명", "메뉴명을 입력해주세요.", menuNames[addCnt], TextInputType.text),
//          ),
//          whiteSpaceH(15),
//          SizedBox(height: 50,
//            child: TextFormField(decoration: InputDecoration(border: OutlineInputBorder(), hintText: "가격을 입력해주세요"),),
//          ),
//          whiteSpaceH(10),
//          Container(
//            width: MediaQuery.of(context).size.width,
//            height: 3,
//            color: Color(0xFFDDDDDD),
//          ),
//          whiteSpaceH(10),
//        ],
//      ),
//  );

  Widget menuAdd() {

    return Consumer<MenuProvider>(
        builder: (context, value, _) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            controller: _scrollController,
            itemBuilder: (context, idx){
              return MenuItem(value.menu[idx]);
            },
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: value.menu.length + 1,
          );
        },
    );
  }

//  Widget categoryAdd() => Container(
//    child:
//      TextFormField(decoration: InputDecoration(hintText: "메뉴 대분류를 작성해주세요."),controller: menuCategory,),
//  );

  Widget nextBtn(context) {
    return Container(
      width: double.infinity,
      height: 40,
      child: RaisedButton(
        onPressed: () {
          Map<String, dynamic> args = {
            "menuName": menuName.text,
            "menuPrice": menuPrice.text,
          };

          if (menuName.text == '' || menuName.text == null) Fluttertoast.showToast(msg: "메뉴명을 입력해 주세요");
          if (menuPrice.text == '' || menuPrice.text == null) Fluttertoast.showToast(msg: "가격을 입력해 주세요");

          Navigator.of(context).pushNamed("/store/apply4", arguments: args);

        },
        child: Text("다음"),
        textColor: Colors.white,
        color: mainColor,
      ),
    );
  }
}

class MenuItem extends StatefulWidget {
  MenuModel menuModel;
  MenuItem(this.menuModel);

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {

  @override
  Widget build(BuildContext context) {

  }

}


