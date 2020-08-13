import 'package:cashcook/src/model/referrer/referrer.dart';
import 'package:cashcook/src/provider/RecoProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/referrermanagement/invitation.dart';
import 'package:cashcook/src/screens/referrermanagement/recommendation.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReferrerManagement extends StatefulWidget {
  @override
  _ReferrerManagement createState() => _ReferrerManagement();
}

class _ReferrerManagement extends State {
  String selectValue = "최신순";

//  List<Referrer> referrerList = List();

  @override
  void initState() {
    super.initState();

//    referrerList
//      ..add(Referrer(
//          name: "CashCook",
//          phone: "010-1111-1111",
//          type: 1,
//          byName: "normal",
//          date: "2020.06.04"))
//      ..add(Referrer(
//          name: "normal",
//          type: 0,
//          phone: "010-2222-2222",
//          byName: "",
//          date: "2020.06.03"));

//    referrerList.sort((a, b) => b.date
//        .toString()
//        .compareTo(a.date.toString()));
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
      center.fetchReco(currentPage,
          Provider.of<UserProvider>(context, listen: false).loginUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<RecoProvider>(context, listen: false).fetchReco(currentPage,
        Provider.of<UserProvider>(context, listen: false).loginUser);
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
        elevation: 0.5,
        title: Text(
          "추천인 관리",
          style: TextStyle(
              color: black,
              fontSize: 14,
              fontFamily: 'noto',
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
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
                          reco.referrer.length.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'noto',
                              fontSize: 24,
                              color: black),
                        );
                      },
                    ),
                    Text(
                      "명",
                      style: TextStyle(
                          color: black,
                          fontSize: 14,
                          fontFamily: 'noto',
                          fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      width: 72,
                      height: 24,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Recommendation()));
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
                            "추천하기",
                            style: TextStyle(
                                color: black, fontFamily: 'noto', fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    whiteSpaceW(4),
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
                            style: TextStyle(
                                color: black, fontFamily: 'noto', fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              whiteSpaceH(16),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: [
                    Text(
                      "추천인 적립금",
                      style: TextStyle(
                          color: black,
                          fontSize: 14,
                          fontFamily: 'noto',
                          fontWeight: FontWeight.w600),
                    ),
                    whiteSpaceW(12),
                    Text(
                      "${numberFormat.format(1234)} RP",
                      style: TextStyle(
                          color: black,
                          fontSize: 14,
                          fontFamily: 'noto',
                          fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      width: 70,
                      padding: EdgeInsets.zero,
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: DropdownButton<String>(
                          underline: Container(),
                          elevation: 0,
                          style: TextStyle(
                              color: black, fontSize: 14, fontFamily: 'noto'),
                          items: <String>['최신순'].map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: black,
                                    fontSize: 14,
                                    fontFamily: 'noto'),
                              ),
                            );
                          }).toList(),
                          value: selectValue,
                          onChanged: (value) {
//                            setState(() {
//                              selectValue = value;
//                              if (value == "최신순") {
//                                referrerList.sort((a, b) => b.date
//                                    .toString()
//                                    .compareTo(a.date.toString()));
//                              } else {
//                                referrerList.sort((a, b) => a.date
//                                    .toString()
//                                    .compareTo(b.date.toString()));
//                              }
//                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              whiteSpaceH(16),
              Consumer<RecoProvider>(
                builder: (context, reco, _) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (context, idx) {
                      if (idx < reco.referrer.length) {
                        return Item(reco.referrer[idx]);
                      }
                      return Center(
                        child: Opacity(
                          opacity: reco.isLoading ? 1.0 : 0.0,
                          child: CircularProgressIndicator(),
                        ),
                      );
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
    return Row(
      children: [
        whiteSpaceW(16),
        Image.asset(
          data.type == 0
              ? "assets/resource/public/directly.png"
              : "assets/resource/public/indirect.png",
          width: 32,
          height: 32,
        ),
        whiteSpaceW(12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.name,
              style: TextStyle(
                  fontFamily: 'noto',
                  fontSize: 14,
                  color: black,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              data.phone,
              style: TextStyle(
                  color: Color(0xFF888888), fontSize: 12, fontFamily: 'noto'),
            )
          ],
        ),
        Expanded(
          child: Container(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              data.date,
              style: TextStyle(
                  fontSize: 12, fontFamily: 'noto', color: Color(0xFF888888)),
            ),
            data.type == 1
                ? Text(
                    "By " + data.byName,
                    style: TextStyle(
                        fontFamily: 'noto', fontSize: 12, color: mainColor),
                    textAlign: TextAlign.end,
                  )
                : Container()
          ],
        ),
        whiteSpaceW(16)
      ],
    );
  }
}
