import 'package:cashcook/src/model/point.dart';
import 'package:cashcook/src/provider/PointMgmtProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class pointMgmtUser extends StatefulWidget {
  @override
  _pointMgmtUserState createState() => _pointMgmtUserState();
}

class _pointMgmtUserState extends State<pointMgmtUser> {
  ScrollController _scrollController = ScrollController();

  String viewType = "day";
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<PointMgmtProvider>(context, listen: false).fetchUserMgmt(viewType);
    });

    return
      Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: mainColor,
      ),
      body:
        Consumer<PointMgmtProvider>(
          builder: (context, pm, _){
            return
            Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 30.0, left: 12.0, right: 12.0, bottom: 50.0),
                    decoration: BoxDecoration(
                      color: mainColor,
                    ),
                    child: Row(
                      children: [
                        Column (
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            whiteSpaceH(1),
                            whiteSpaceH(5),
                            whiteSpaceH(1),
                            whiteSpaceH(20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("${Provider.of<UserProvider>(context, listen:false).loginUser.username}   ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: white
                                    )),
                                Text("${Provider.of<UserProvider>(context, listen:false).loginUser.phone}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: white
                                  ))
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        Image.asset("assets/icon/recommend.png", height: 42, fit: BoxFit.contain,),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Container(
                        transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(3,3),
                              blurRadius: 3,
                              color: Color(0xff888888).withOpacity(0.15),
                            ),
                          ],
                        ),
                        child:
                        Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child:
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0, left: 12.0, right: 12.0, bottom: 15.0),
                                  child:Column(
                                    children: [
                                      Text("총 현장결제",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff888888),
                                          )),
                                      whiteSpaceH(5),
                                      Text("${numberFormat.format(pm.pay)}원",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xffFF6622),
                                              fontWeight: FontWeight.w600
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child:
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0, left: 12.0, right: 12.0, bottom: 15.0),
                                  child:Column(
                                    children: [
                                      Text("총 BZA 결제",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff888888),
                                          )),
                                      whiteSpaceH(5),
                                      Text("${numberFormat.format(pm.dl)} BZA",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xffD4145A),
                                              fontWeight: FontWeight.w600
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ]
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                    child:
                      Container(
                        transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                        width: MediaQuery.of(context).size.width,
                        child:
                          Row(
                            children: [
                              RaisedButton(
                                onPressed: (viewType == "day") ? null : () {
                                    setState(() {
                                      viewType = "day";
                                    });
                                },
                                color: white,
                                disabledColor: Colors.cyan,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(color: Colors.cyan)
                                  ),
                                child:
                                Text(
                                  "일간",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: (viewType == "day") ? Colors.white : Colors.black
                                  ),
                                ),
                              ),
                              whiteSpaceW(10),
                              RaisedButton(
                                onPressed: (viewType == "month") ? null : () {
                                  setState(() {
                                    viewType = "month";
                                  });
                                },
                                color: white,
                                disabledColor: Colors.cyan,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(color: Colors.cyan)
                                ),
                                child:
                                Text(
                                  "월간",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: (viewType == "month") ? Colors.white : Colors.black
                                  ),
                                ),
                              ),
                              whiteSpaceW(10),
                              RaisedButton(
                                onPressed: (viewType == "year") ? null : () {
                                  setState(() {
                                    viewType = "year";
                                  });
                                },
                                color: white,
                                disabledColor: Colors.cyan,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(color: Colors.cyan)
                                ),
                                child:
                                Text(
                                  "연간",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: (viewType == "year") ? Colors.white : Colors.black
                                  ),
                                ),
                              ),
                            ]
                          )
                      )
                  ),
                  Flexible(
                      child: (viewType == "day") ? historyList()
                          : (viewType == "month") ? ReportList()
                          : ReportList()
                  ),
                ]
            );
          }
        ),
    );
  }

  Widget ReportList() {
    return Consumer<PointMgmtProvider>(
      builder: (context, pm, _) {
        return (pm.isLoading) ?
        Center(
            child: CircularProgressIndicator(
                backgroundColor: mainColor,
                valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
            )
        )
            :
        Container(
            child:
            ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, idx) {
                if(idx < pm.pumList_my.length){
                  return ReportItem(pm.pumList_my[idx]);
                }
                if(pm.pumList_my.length == 0) {
                  return SizedBox();
                }
                return Center(
                    child: CircularProgressIndicator(
                        backgroundColor: mainColor,
                        valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
                    )
                );
              },
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: pm.pumList_my.length,
            )
        );
      },
    );
  }

  Widget ReportItem(PointReportModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0, right: 20.0, left: 20.0),
          child: Text("${data.base_mday} ${(viewType == "month") ? "월" : "년"}",
              style: TextStyle(
                  fontFamily: 'noto',
                  fontSize: 12,
                  color: Color(0xff888888))),
        ),
                Container(
                  padding: const EdgeInsets.only(right:12.0, left:12.0, bottom: 10.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child:Image.asset(
                            "assets/resource/public/krw-coin.png", width: 40, fit: BoxFit.contain,)
                        ),
                        Expanded(
                          flex: 5,
                          child:Container(
                              child:
                              Text("  ${numberFormat.format(double.parse(data.base_amount))} 원",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'noto',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color:Color(0xffFF6622)))
                          ),
                        ),
                        whiteSpaceW(10),
                        Expanded(
                          flex: 2,
                          child:Image.asset(
                            "assets/icon/bza.png", width: 40, fit: BoxFit.contain,)
                        ),
                        Expanded(
                          flex: 5,
                          child:Container(
                              child:
                              Text("  ${numberFormat.format(double.parse(data.sub_amount))} BZA",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'noto',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xffD4145A)))
                          ),
                        ),
                      ]
                  ),
                )
      ],
    );
  }

  Widget historyList() {
    return Consumer<PointMgmtProvider>(
      builder: (context, pm, _) {
        return (pm.isLoading) ?
        Center(
            child: CircularProgressIndicator(
                backgroundColor: mainColor,
                valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
            )
        )
          :
          Container(
          child:
          ListView.builder(
            controller: _scrollController,
            itemBuilder: (context, idx) {
              if(idx < pm.pumList.length){
                return historyItem(pm.pumList[idx]);

              }
              if(pm.pumList.length == 0) {
                return SizedBox();
              }
            },
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: pm.pumList.length + 1,
          )
        );
      },
    );
  }

  Widget historyItem(Map<String, dynamic> data) {
    List<dynamic> histories = data['history'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0, right: 12.0, left: 12.0),
          child: Text(data['date'],
                    style: TextStyle(
                        fontFamily: 'noto',
                        fontSize: 12,
                    color: Color(0xFF888888))),
        ),
        Column(
          children: histories.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0, right: 15.0, left: 15.0),
              child:
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child:
                    Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child:Image.asset(
                              "${e['point_img']}", width: 40, fit: BoxFit.contain,),
                          ),
                          Expanded(
                            flex: 4,
                            child:Container(
                                child:
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "    ${e['description']}  ",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'noto',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black)
                                        ),
                                        Text(
                                            "      ${e['time']}  ",
                                            style: TextStyle(
                                                fontFamily: 'noto',
                                                fontSize: 10,
                                                color: Color(0xFF888888))
                                        ),
                                      ]
                                    )
                            ),
                          ),
                          Expanded(
                            flex:3,
                            child:Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 13.0),
                                child:Text(
                                    "${e['title']}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'noto',
                                      fontWeight: FontWeight.w600,
                                      color:
                                      (e['title'].toString().contains("BZA") || (e['title'].toString().contains("ADP")) ? Color(0xffD4145A)
                                          : (e['title'].toString().contains("RP")) ? mainColor
                                          :  Color(0xffFF6622)),
                                    )
                                )
                            )
                          )
                    ]
                  ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
