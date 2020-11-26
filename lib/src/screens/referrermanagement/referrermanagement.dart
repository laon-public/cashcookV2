import 'package:cashcook/src/provider/RecoProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/referrermanagement/invitation.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

class ReferrerManagement extends StatefulWidget {
  @override
  _ReferrerManagement createState() => _ReferrerManagement();
}

class _ReferrerManagement extends State {
  String selectValue = "직접 추천회원";
  String type = "dir";
//  List<Referrer> referrerList = List();

  @override
  void initState() {
    super.initState();
  }

  ScrollController _scrollController = ScrollController();
  int currentPage = 0;

  loadMore(context) async {
      RecoProvider center = Provider.of<RecoProvider>(context, listen: false);
      if (!center.isLoading) {
        currentPage++;
        if (center.pageing.offset >= center.pageing.count) {
          return;
        }
        center.startLoading();
        center.fetchReco(currentPage, type,
            Provider
                .of<UserProvider>(context, listen: false)
                .loginUser);
      }
  }

  @override
  Widget build(BuildContext context) {
      Provider.of<RecoProvider>(context, listen: false).fetchReco(currentPage, type,
          Provider
              .of<UserProvider>(context, listen: false)
              .loginUser);
    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) loadMore(context);
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        leading: IconButton(
          icon: Image.asset(
            "assets/resource/public/prev.png",
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        elevation: 1,
        title: Text(
          "추천인 관리",
          style: appBarDefaultText,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              whiteSpaceH(4),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: [
                    Consumer<RecoProvider>(
                      builder: (context, reco, _) {
                        return Text(
                          reco.allCount.toString(),
                          style: Headline,
                        );
                      },
                    ),
                    Text(
                      "명",
                      style: Headline,
                    ),
                    Spacer(),
                    Container(
                      width: 72,
                      height: 24,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Invitation()));
                        },
                        elevation: 0.0,
                        color: white,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Color(0xFFDDDDDD),
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            "초대하기",
                            style: Body1
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              whiteSpaceH(16),
              Consumer<RecoProvider>(
                builder: (context, reco, _) {
                  return Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 40,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "직접추천회원 적립",
                                    style: TabsTagsStyle
                                ),
                                Text(
                                  "${numberFormat.format(reco.dirAmount)} CP",
                                  style: Body1.apply(
                                    color: primary
                                  )
                                )
                              ]
                          ),
                          whiteSpaceW(20),
                          // Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Text(
                          //           "간접추천회원 적립",
                          //           style: TextStyle(
                          //             fontFamily: 'noto',
                          //             color: Color(0xFF888888),
                          //             fontSize: 10,
                          //           )
                          //       ),
                          //       Text(
                          //         "${numberFormat.format(reco.inDirAmount)} RP",
                          //         style: TextStyle(
                          //             fontFamily: 'noto',
                          //             color: mainColor,
                          //             fontSize: 15
                          //         ),
                          //       )
                          //     ]
                          // ),
                        ]
                    ),
                  );
                }
              ),
              whiteSpaceH(16),
              Consumer<RecoProvider>(
                builder: (context, reco, _) {
                  return Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 40,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                        children: [
                          Row(
                              children: [
                                Text(
                                    "${reco.typeTitle}",
                                    style: Subtitle2
                                ),
                                Text(
                                    reco.referrer.length.toString(),
                                    style: Subtitle2.apply(
                                      color: primary
                                    )
                                ),
                                Text(
                                    "명",
                                    style: Subtitle2
                                ),
                              ]
                          ),
                          Spacer(),
                          Container(
                            width: 120,
                            padding: EdgeInsets.zero,
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: DropdownButton<String>(
                                underline: Container(),
                                elevation: 0,
                                style: Body1,
                                items: // <String>['전체', '직접 추천회원', '간접 추천회원', '가입 대기회원']
                                    <String>['직접 추천회원', '가입 대기회원']
                                    .map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: Body1,
                                    ),
                                  );
                                }).toList(),
                                value: selectValue,
                                onChanged: (value) {
                                  setState(() {
                                    selectValue = value;
                                    print(value);
                                    if (value == '직접 추천회원') {
                                      print("type ===> direct");
                                      type = "dir";
                                    } else if (value == '간접 추천회원') {
                                      print("type ===> indirect");
                                      type = "inDir";
                                    } else if (value == '전체') {
                                      print("type ===> all");
                                      type = "all";
                                    } else if (value == '가입 대기회원') {
                                      print("type ===> recognition");
                                      type = "recognition";
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ]
                    ),
                  );
                }
              ),
              whiteSpaceH(20),
              Consumer<RecoProvider>(
                builder: (context, reco, _) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (context, idx) {
                      if (idx < reco.referrer.length) {
                        return Item(reco.referrer[idx]);
                      }

                    },
                    itemCount: reco.referrer.length + 1,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget Item(data) {
    return
      Container(
          width: MediaQuery.of(context).size.width,
        child:Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.asset(
                data.type == 0
                    ? "assets/resource/public/directly.png"
                    : data.type == 1
                    ? "assets/resource/public/indirect.png"
                    : "assets/resource/public/friend-none.png",

                width: 32,
                height: 60,
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    overflow: TextOverflow.ellipsis,
                    style: Body1.apply(
                      fontWeightDelta: 1
                    ),
                  ),
                  Text(
                    data.phone,
                    style: Body2,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    data.date,
                    style: Body2
                  ),
                  type != "recognition" && data.type == 1
                      ? Text(
                    "By " + data.byName,
                    style: Body2.apply(
                      color: primary
                    ),
                    textAlign: TextAlign.end,
                  )
                      : Container()
                ],
              ),
            )
          ],
        )
      );
  }
}
