import 'package:cashcook/src/model/point.dart';
import 'package:cashcook/src/provider/PointMgmtProvider.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/CustomBottomNavBar.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class pointMgmtUser extends StatefulWidget {
  bool afterGame;
  bool isHome;

  pointMgmtUser({this.afterGame = false, this.isHome = false});

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
          backgroundColor: primary,
          leading: widget.isHome ? null : IconButton(
            onPressed: () {
              if(widget.afterGame){
                Provider.of<StoreProvider>(context,listen: false).clearMap();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MainMap()),
                        (route) => false);

                // Navigator.of(context).pushNamed("/mainmap"); 안됨
                // Navigator.of(context).push(
                //   MaterialPageRoute(builder: (context) => MainMap())); 안됨
              } else {
                Navigator.of(context).pop();
              }

            },
            icon: Image.asset(
              "assets/resource/public/close.png",
              width: 24,
              height: 24,
            ),
          ),
        ),
        body: Stack (
          children: [
            Consumer<PointMgmtProvider>(
                builder: (context, pm, _){
                  return
                    Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(top: 30.0, left: 12.0, right: 12.0, bottom: 50.0),
                            decoration: BoxDecoration(
                              color: primary,
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
                                              Text("총 DL 결제",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xff888888),
                                                  )),
                                              whiteSpaceH(5),
                                              Text("${numberFormat.format(pm.dl)} DL",
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
                                            print("viewType");
                                            print(viewType);
                                            setState(() {
                                              viewType = "day";
                                            });
                                          },
                                          color: white,
                                          disabledColor: primary,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                              side: BorderSide(color: primary)
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
                                          disabledColor: primary,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                              side: BorderSide(color: primary)
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
                                          disabledColor: mainColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                              side: BorderSide(color: mainColor,)
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
            widget.isHome ? CustomBottomNavBar(context, "pointmgmt") : Container(),
          ],
        )

      );
  }

  Widget ReportList() {
    return Consumer<PointMgmtProvider>(
      builder: (context, pm, _) {
        return (pm.isLoading) ?
        Center(
            child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
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
                        valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
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
              style: Body2),
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
                          style: Subtitle1.apply(
                            color: primary
                          ))
                  ),
                ),
                whiteSpaceW(10),
                Expanded(
                    flex: 2,
                    child:Image.asset(
                      "assets/icon/DL 2.png", width: 40, fit: BoxFit.contain,)
                ),
                Expanded(
                  flex: 5,
                  child:Container(
                      child:
                      Text("  ${numberFormat.format(double.parse(data.sub_amount))} DL",
                          overflow: TextOverflow.ellipsis,
                          style: Subtitle1.apply(
                            color: etcYellow
                          ))
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
                valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
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
          child: Text(
              DateFormat("yy.MM.dd").format(
                  DateTime.parse( data['date'].toString())),
              style: Body2
                  ),
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
                                      style: Subtitle2
                                  ),
                                  Text(
                                      "      ${e['time'].toString().split(":")[0]}:${e['time'].toString().split(":")[1]}  ",
                                      style: TabsTagsStyle
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
                                  style: Subtitle2.apply(
                                    color:
                                    (e['title'].toString().contains("DL") || (e['title'].toString().contains("ADP")) ? Color(0xffD4145A)
                                        : (e['title'].toString().contains("RP")) ? primary
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
