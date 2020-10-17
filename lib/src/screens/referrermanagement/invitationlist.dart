import 'dart:io';
import 'dart:math';

import 'package:cashcook/src/model/phone.dart';
import 'package:cashcook/src/model/reco.dart';
import 'package:cashcook/src/provider/PhoneProvider.dart';
import 'package:cashcook/src/screens/referrermanagement/invitation.dart';
//import 'package:cashcook/src/provider/ContactProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
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

class _InvitationList extends State<InvitationList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<PhoneProvider>(context, listen: false).fetchPhoneList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mainColor,
        title: Text(
          "추천회원 초대하기",
          style: TextStyle(
              color: white,
              fontSize: 14,
              fontFamily: 'noto',
              fontWeight: FontWeight.w600),
        ),
        elevation: 2.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          icon: Image.asset(
            "assets/resource/public/prev.png",
            width: 24,
            height: 24,
          ),
        ),
      ),
      body:
        Consumer<PhoneProvider>(
          builder: (context, phoneProvider, _){
              return (phoneProvider.isLoading) ?
                Center(
                    child: CircularProgressIndicator(
                      backgroundColor: mainColor,
                      valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
                    )
                )
                  :
              Container(
                  height: MediaQuery.of(context).size.height,
                  color: mainColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      whiteSpaceH(10),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Container(
                          child: Row(
                            children: [
                              Text(
                                "${phoneProvider.checkCnt}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'noto',
                                    fontSize: 20,
                                    color: white),
                              ),
                              Text(
                                "명 선택됨",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'noto',
                                    fontSize: 20,
                                    color: white),
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
                            Theme(
                              data: ThemeData(unselectedWidgetColor: Colors.white,),
                              child:
                              Checkbox(
                                activeColor: white,
                                checkColor: white,
                                value: phoneProvider.allCheck,
                                onChanged: (value) {
                                  phoneProvider.setAllCheck(value);
                                },
                              ),
                            ),
                            Text(
                              "전체선택",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'noto',
                                  fontSize: 18,
                                  color: white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Container(
                            child: InvitationItemList(phoneProvider.phoneList),
                          )
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: RaisedButton(
                          disabledColor: subBlue,
                          onPressed: phoneProvider.checkCnt != 0? () async {
                              phoneProvider.postReco();
                              showToast("초대하기를 성공하셨습니다.");
                              Navigator.of(context).pop(true);
                          } : null,
                          elevation: 0.0,
                          color: subYellow,
                          child: Center(
                            child: Text(
                              "초대하기",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'noto',
                                  fontSize: 14,
                                  color: phoneProvider.checkCnt != 0 ? black : subBlue),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              );
          }
        )
    );
  }
}

class InvitationItemList extends StatefulWidget {
  final List<PhoneModel> phoneList;

  InvitationItemList(this.phoneList);

  @override
  _InvitationItemListState createState() => _InvitationItemListState(phoneList);
}

class _InvitationItemListState extends State<InvitationItemList> {
  final List<PhoneModel> phoneList;
  PhoneProvider phoneProvider;

  _InvitationItemListState(this.phoneList);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneProvider = Provider.of<PhoneProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return
      ListView.builder(
          itemCount: phoneList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.only(right: 15.0),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      flex:1,
                      child:Container(
                        // 개별선택
                        child:
                        Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white,),
                          child:
                          Checkbox(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            activeColor: white,
                            checkColor: white,
                            value: phoneList[index].isCheck,
                            onChanged: (value) {
                              phoneProvider.setCheck(index, value);
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text('${NumberFormat("000").format(index + 1)}',
                        style: TextStyle(
                          color: white,
                          fontSize: 12,
                          fontFamily: 'noto',
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('${phoneList[index].name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: white,
                          fontSize: 12,
                          fontFamily: 'noto',
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('${phoneList[index].phone}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: white,
                          fontSize: 12,
                          fontFamily: 'noto',
                        ),
                        textAlign: TextAlign.end,
                      ),
                    )
                  ],
                ),
              ),
            );
          }
      );
  }
}
