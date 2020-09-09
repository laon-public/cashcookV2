import 'dart:io';
import 'dart:math';

import 'package:cashcook/src/model/reco.dart';
//import 'package:cashcook/src/provider/ContactProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share/share.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cashcook/src/provider/RecoProvider.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/services/Reco.dart';
import 'package:cashcook/src/provider/RecoProvider.dart';

class InvitationList extends StatefulWidget {
  @override
  _InvitationList createState() => _InvitationList();
}

class _InvitationList extends State {
  Iterable<Contact> _contact;
  List<bool> checkTmp = [];
  List<Contact> result = [];
  List<bool> checkBoxValues = [];
  var isChecked = true;
  int initCnt = 0;
  int j = 0;
  int cnt = 0;
  int tmpCnt = 0;

  permission() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
    _contact = await ContactsService.getContacts();
    List<Contact> contactList = _contact.toList();
    print(contactList.length);
    for(var i = 0; i < contactList.length ; i++){
      if(contactList[i].phones.isEmpty){
        contactList.removeAt(i);
      }
    }


 //   cnt = result.length - 1;

    while(j < contactList.length){
      checkTmp.add(true);
      j++;
    }



    setState(() {
      result = contactList.toList();
      cnt = contactList.length;
      checkBoxValues = checkTmp;
    });
    // result = _contact.toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    permission();
  }

  @override
  Widget build(BuildContext context) {
    void medCheckedChanged(bool value, index) => setState(() => checkBoxValues[index] = value);

    void checkConut(){
      cnt = 0;
      for(int i = 0; i < result.length; i++){
          if(checkBoxValues[i]){
            cnt++;
          }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "추천회원 초대하기",
          style: TextStyle(
              color: black,
              fontSize: 14,
              fontFamily: 'noto',
              fontWeight: FontWeight.w600),
        ),
        elevation: 2.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset(
            "assets/resource/public/prev.png",
            width: 24,
            height: 24,
          ),
        ),
      ),
      body:

        Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.amber,
          child: (result.length != 0) ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              whiteSpaceH(10),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Container(
                  child: Row(
                    children: [
                      Text(
                        "$cnt",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'noto',
                            fontSize: 20,
                            color: mainColor),
                      ),
                      Text(
                            "명 선택됨",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'noto',
                                fontSize: 20,
                                color: black),
                          ),
                      whiteSpaceH(15),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 0, right: 20),
                child: Row(
                  children: <Widget>[
                    // 전체선택
                    Checkbox(value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value;
                            for(int i = 0; i < result.length; i++){
                              medCheckedChanged(isChecked, i);
                            }
                            if(isChecked){
                              cnt = result.length;
                            } else {
                              cnt = 0;
                            }
                          });
                        },
                    ),
                    Text(
                      "전체선택",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'noto',
                          fontSize: 14,
                          color: black),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                    child: ListView.builder(
                      itemCount: result.length,
                      itemBuilder: (BuildContext context, int index){
                        var i = index + 1;
                        return Container(
                          child : Center(
                            child: new Row(
                                children: [
                                  Container(
                                    // 개별선택
                                    child: Checkbox(
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      activeColor: mainColor,
//                                      value: (checkBoxValues.length != 0) ? checkBoxValues[index] : true,
                                      value: checkBoxValues[index],
                                      onChanged: (value) {
                                        print(value);
                                        print(index);
                                        medCheckedChanged(value, index);
                                        checkConut();
                                      },
                                    ),
                                  ),

                                      Text('${i.toString().length == 1? '00' + i.toString() : i.toString().length == 2? '0' + i.toString() : i.toString()}',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      whiteSpaceW(10),
                                      Text('|',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      whiteSpaceW(10),
                                      Text('${result[index].displayName}',
                                        style: TextStyle(
                                         fontSize: 12,
                                        ),
                                      ),
                                      whiteSpaceW(10),
                                      Text('|',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      whiteSpaceW(10),
                                      Text('${result[index].phones.first.value}',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                ],
                               ),
                            ),

                    );
                  },
                ),
              )
              ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                      tmpCnt = 0;
                      for(var i = 0; i < result.length - 1; i++){
                        if(checkBoxValues[i]){
                          RecoProvider().postReco(result[i].displayName, result[i].phones.first.value);
                        }
                      }
//                      RecoProvider().postReco("김철수", "010-1111-2222");
                    },
                    elevation: 0.0,
                    color: mainColor,
                    child: Center(
                      child: Text(
                        "초대하기",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'noto',
                            fontSize: 14,
                            color: white),
                      ),
                    ),
                  ),
                ),
                    ],
                  ) :
          Center(
            child: Column(
              children: <Widget>[
                new Image.asset("assets/resource/public/loading.gif"),
                new Text("연락처를 불러오는중입니다."),
              ],
            )
          )
        ),
    );
  }
}
