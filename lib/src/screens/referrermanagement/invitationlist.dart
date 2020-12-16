import 'dart:async';

import 'package:cashcook/src/model/phone.dart';
import 'package:cashcook/src/provider/PhoneProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:provider/provider.dart';

class InvitationList extends StatefulWidget {
  @override
  _InvitationList createState() => _InvitationList();
}

class _InvitationList extends State<InvitationList> {
  TextEditingController searchCtrl;

  Timer _debounce;
  int _debouncetime = 750;

  String filterKeyword;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<PhoneProvider>(context, listen: false).fetchPhoneList();
    this.searchCtrl = TextEditingController();
    this.searchCtrl.addListener(_onSearchChanged);
    filterKeyword = "";
  }

  _onSearchChanged() {
    if(_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: _debouncetime), () {
      if(searchCtrl.text != filterKeyword) {
        setState(() {
          filterKeyword = searchCtrl.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        title: Text(
          "친구추천 자동인식 등록하기",
          style: appBarDefaultText,
        ),
        elevation: 1.5,
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
                        valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
                    )
                )
                  :
                  Stack(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 60),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      whiteSpaceH(12),
                                      Text("성명",
                                          style: Body2.apply(
                                              color: third
                                          )
                                      ),
                                      Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 44,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  autofocus: false,
                                                  cursorColor: Color(0xff000000),
                                                  style: Subtitle2,
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.all(12.0),
                                                    border: UnderlineInputBorder(
                                                      borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                                                    ),
                                                    focusedBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(color: black, width: 2.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                whiteSpaceH(12),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      whiteSpaceH(12),
                                      Text("연락처",
                                          style: Body2.apply(
                                              color: third
                                          )
                                      ),
                                      Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 44,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  autofocus: false,
                                                  cursorColor: Color(0xff000000),
                                                  style: Subtitle2,
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.all(12.0),
                                                    border: UnderlineInputBorder(
                                                      borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                                                    ),
                                                    focusedBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(color: black, width: 2.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  child: RaisedButton(
                                    elevation: 0.0,

                                    color: white,
                                    onPressed: () {},
                                    child: Text("확인",
                                        style: Body1.apply(
                                            color: primary
                                        )
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xFFDDDDDD),
                                          width: 1
                                      )
                                  ),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 8,
                                    color: Color(0xFFF2F2F2)
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 16, top:14, bottom: 14),
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Theme(
                                            data: ThemeData(unselectedWidgetColor: Color(0xFFDDDDDD),),
                                            child:
                                            Checkbox(
                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              activeColor: mainColor,
                                              checkColor: white,
                                              value: phoneProvider.allCheck,
                                              onChanged: (value) {
                                                phoneProvider.setAllCheck(value);
                                              },
                                            )
                                        ),
                                      ),
                                      Text(
                                          "${phoneProvider.phoneList.length}명 중 ",
                                          style: Subtitle2.apply(
                                              fontWeightDelta: 1
                                          )
                                      ),
                                      Text(
                                          "${phoneProvider.checkCnt}",
                                          style: Subtitle2.apply(
                                              color: primary,
                                              fontWeightDelta: 1
                                          )
                                      ),
                                      Text(
                                          "명 선택",
                                          style: Subtitle2.apply(
                                              fontWeightDelta: 1
                                          )
                                      ),
                                      whiteSpaceH(15),
                                    ],
                                  ),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 44,
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: searchCtrl,
                                            autofocus: false,
                                            cursorColor: Color(0xff000000),
                                            style: Subtitle2,
                                            decoration: InputDecoration(
                                              labelText: "찾으실 친구를 입력해주세요.",
                                              labelStyle: Subtitle2.apply(
                                                color: third,
                                                fontWeightDelta: -1
                                              ),
                                              contentPadding: EdgeInsets.all(12.0),
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: black, width: 2.0),
                                              ),
                                              prefixIcon: InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  padding: EdgeInsets.all(12.0),
                                                  child: Image.asset(
                                                    "assets/resource/main/search_blue.png",
                                                    width: 24,
                                                    height: 24,
                                                    color: primary,
                                                  ),
                                                ),
                                              ),
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    searchCtrl.text = "";
                                                    filterKeyword = "";
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(12.0),
                                                  child: Image.asset(
                                                    "assets/icon/cancle.png",
                                                    width: 24,
                                                    height: 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                                Expanded(
                                    child: Container(
                                      child: InvitationItemList(phoneList: phoneProvider.phoneList, filterKeyword: filterKeyword,),
                                    )
                                ),
                              ],
                            )
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(6)
                                )
                            ),
                            disabledColor: deActivatedGrey,
                            onPressed: phoneProvider.checkCnt != 0? () async {
                              phoneProvider.postReco();
                              showToast("초대하기를 성공하셨습니다.");
                              Navigator.of(context).pop(true);
                            } : null,
                            elevation: 0.0,
                            color: primary,
                            child: Center(
                              child: Text(
                                  "친구추천 자동인식 등록하기",
                                  style: Subtitle2.apply(
                                      color: white,
                                      fontWeightDelta: 1
                                  )
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
          }
        )
    );
  }
}

class InvitationItemList extends StatefulWidget {
  final List<PhoneModel> phoneList;
  final String filterKeyword;

  InvitationItemList({this.phoneList, this.filterKeyword});

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
        physics: NeverScrollableScrollPhysics(),
          itemCount: phoneList.length,
          itemBuilder: (BuildContext context, int index) {
            return phoneList[index].name.contains(widget.filterKeyword) ? Container(
              padding: EdgeInsets.only(right: 16, top: 20, bottom: 20),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      flex:1,
                      child:Container(
                        // 개별선택
                        child:
                        Theme(
                          data: ThemeData(unselectedWidgetColor: Color(0xFFDDDDDD),),
                          child:
                          Checkbox(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            activeColor: mainColor,
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
                        style: Body2
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('${phoneList[index].name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Body1.apply(
                          fontWeightDelta: 1
                        )
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('${phoneList[index].phone}',
                        overflow: TextOverflow.ellipsis,
                        style: Body1,
                        textAlign: TextAlign.end,
                      ),
                    )
                  ],
                ),
              ),
            )
            :
            Container();
          }
      );
  }
}
