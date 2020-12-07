import 'package:cashcook/src/model/phone.dart';
import 'package:cashcook/src/provider/PhoneProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
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
        backgroundColor: white,
        title: Text(
          "추천회원 초대하기",
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
              Container(
                  height: MediaQuery.of(context).size.height,
                  color: white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 30.0, left: 20, right: 20, bottom: 10.0),
                        child: Row(
                          children: [
                            Text("추천회원\n초대 목록입니다.",
                              style: Subtitle2.apply(
                                fontWeightDelta: -1
                              )
                            ),
                          ],
                        ),
                      ),
                      whiteSpaceH(10),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, left: 20, right: 20, bottom: 15.0),
                        child: Container(
                          child: Row(
                            children: [
                              Text(
                                "${phoneProvider.phoneList.length}명 중 ",
                                style: Subtitle2
                              ),
                              Text(
                                "${phoneProvider.checkCnt}",
                                style: Subtitle2.apply(
                                  color: primary
                                )
                              ),
                              Text(
                                "명 선택",
                                style: Subtitle2
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
                              data: ThemeData(unselectedWidgetColor: black,),
                              child:
                              Checkbox(
                                activeColor: black,
                                checkColor: black,
                                value: phoneProvider.allCheck,
                                onChanged: (value) {
                                  phoneProvider.setAllCheck(value);
                                },
                              ),
                            ),
                            Text(
                              "전체선택",
                              style: Subtitle2
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
                          color: mainColor,
                          child: Center(
                            child: Text(
                              "초대하기",
                              style: Body1.apply(
                                fontWeightDelta: 1,
                                color: white
                              ),
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
              padding: EdgeInsets.only(right: 20.0, left: 5.0),
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
                        style: Body1
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
            );
          }
      );
  }
}
