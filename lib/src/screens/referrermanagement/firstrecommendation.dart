import 'dart:convert';

import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/RecoProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/model/recomemberlist.dart';
import 'dart:math';

class FirstRecommendation extends StatefulWidget {
  @override
  _FirstRecommendation createState() => _FirstRecommendation();
}



class _FirstRecommendation extends State<FirstRecommendation> {


  String _selectedValue = "선택해주세요.";
  String memb = '캐시쿡을 추천해준 친구를 선택해주세요.';

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).recoemberlist();

    // print('----------------------');
    // print(userProvider.recomemberList );
    // print('----------------------');
    // if(userProvider.recomemberList == '' || userProvider.recomemberList.isEmpty){
    //   memb = '추천자가 아무도 없습니다.';
    // }else{
    //   memb = '캐시쿡을 추천해준 친구를 선택해주세요.';
    // }

  }

  bool userCheck = false;

  FocusNode contactUsFocus = FocusNode();

  AppBar appBar;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);

    return Scaffold(
      backgroundColor: Colors.amberAccent,
      resizeToAvoidBottomInset: true,
      appBar: appBar = AppBar(
        backgroundColor: Colors.amberAccent,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          "추천인 등록하기",
          style: TextStyle(
              color: black,
              fontFamily: 'noto',
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false, // 뒤로가기 기능 x
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        //   icon: Image.asset(
        //     "assets/resource/public/prev.png",
        //     width: 24,
        //     height: 24,
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - appBar.preferredSize.height,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                whiteSpaceH(24),
                Text('추천회원',
                  style: TextStyle(
                      fontFamily: 'noto', fontSize: 14, color: Colors.red),
                ),

                whiteSpaceH(4),


//                 TextFormField(
//                   textInputAction: TextInputAction.next,
//                   keyboardType: TextInputType.text,
//                   controller: nameController,
//                   onFieldSubmitted: (value) {
//                     FocusScope.of(context).requestFocus(contactUsFocus);
//                   },
//                   cursorColor: mainColor,
//                   decoration: InputDecoration(
//                       counterText: "",
// //                    hintStyle: TextStyle(
// //                        fontSize: 16,
// //                        color: Color.fromARGB(255, 167, 167, 167),
// //                        fontFamily: 'noto'),
//                       labelText: "",
//                       labelStyle: TextStyle(
//                           fontSize: 16,
//                           color: Color.fromARGB(255, 167, 167, 167),
//                           fontFamily: 'noto'),
// //                    hintText: "이름",
//                       border: UnderlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xFFCCCCCC)),
//                           borderRadius: BorderRadius.circular(0)),
//                       focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: mainColor),
//                           borderRadius: BorderRadius.circular(0)),
//                       contentPadding: EdgeInsets.only(left: 10, right: 10),),
//                 ),


                Consumer<UserProvider>(
                  builder: (context, user, _){
                    return SizedBox(
                      child: DropdownButton(
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        underline: Container(
                            height: 2,
                            color: Colors.red
                        ),
                        value: _selectedValue,
                        items: user.recomemberList.map(
                                (value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }
                        ).toList(),
                        onChanged: (value){
                          setState(() {
                            _selectedValue = value;
                          });
                        },
                      ),
                    );
                  },
                  //    child: SizedBox(
                  //    // 드롭다운버튼
                  // child: DropdownButton(
                  //      isExpanded: true, // 버튼의 사이즈를 화면에 딱 맞춤
                  //      icon: Icon(Icons.arrow_drop_down),
                  //      iconSize: 24,
                  //      elevation: 16,
                  //      underline: Container(
                  //        height: 2,
                  //          color: Colors.red
                  //      ),
                  //      value: _selectedValue,
                  //      items: _valueList.map(
                  //          (value) {
                  //            return DropdownMenuItem(
                  //              value: value,
                  //              child: Text(value),
                  //            );
                  //          }
                  //      ).toList(),
                  //      onChanged: (value){
                  //        setState(() {
                  //          _selectedValue = value;
                  //        });
                  //      },
                  //    ),
                  //    ),
                ),

                whiteSpaceH(8),



                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '$memb',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontFamily: 'noto', fontSize: 14, color: black),
                      ),
                      whiteSpaceW(12),
                    ],
                  ),
                ),


                Expanded(
                  child: Container(),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 72,
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "캐시쿡을 추천해준\n친구를 선택해주세요.",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontFamily: 'noto', fontSize: 14, color: black),
                      ),
                      whiteSpaceW(12),
                      Container(
                        width: 48,
                        height: 48,
                        color: Color(0xFFDDDDDD),
                      )
                    ],
                  ),
                ),
                whiteSpaceH(24),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: RaisedButton(
                    onPressed: () {
                      apply(userProvider.loginUser);
                    },
                    elevation: 0.0,
                    color: mainColor,
                    child: Center(
                      child: Text(
                        "확인",
                        style: TextStyle(
                            color: white,
                            fontSize: 14,
                            fontFamily: 'noto',
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                whiteSpaceH(40)
              ],
            ),
          ),
        ),
      ),
    );
  }


  apply(UserCheck user) async {
    // aip 요정하는 곳
    // String firstlogin = user.isFirstLogin.toString();
    // String username = user.username;

    UserProvider userProviders = Provider.of<UserProvider>(context,listen: false);
    print(userProviders.recomemberList);
    print('추천해준 사람 선택 : $_selectedValue');
    String selectedmember;

    int i =0;
    if(_selectedValue == '랜덤선택'){
      List<String> ss = [];
      for(String userid in userProviders.recomemberList ){
        if(i >= 2 ){
          ss.add(userid);
        }
        i++;
      }
      print(ss);
      int ranmax =ss.length;
      print(ranmax);
      var ran=Random().nextInt(ranmax);

      print('$ran');
      selectedmember = ss[ran];
      print('$selectedmember');
    }else{
      selectedmember = _selectedValue;
    }


    await Provider.of<UserProvider>(context, listen: false).patchloginReco(); // isFirstLogin 상태 변경
    String response = await Provider.of<UserProvider>(context, listen: false).recomemberinsert(selectedmember); // 나를 추천한 사람을 선택 후 저장

    if(response == "true"){
      Fluttertoast.showToast(msg: "등록이 완료되었습니다.");
    }else {
      Fluttertoast.showToast(msg: response);
    }

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainMap()), (route) => false);

  }

}