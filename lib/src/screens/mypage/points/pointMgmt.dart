import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/point.dart';
import 'package:cashcook/src/provider/PointMgmtProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
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

class pointMgmt extends StatefulWidget {
  @override
  _pointMgmtState createState() => _pointMgmtState();
}

class _pointMgmtState extends State<pointMgmt> {
  String viewType = "day";

  int page;

  @override
  void initState() {
    // TODO: implement initState
    page = 1;
  }

  void loadMore()  async{
    setState(() {
      page = page + 1;
    });
    await Provider.of<PointMgmtProvider>(context, listen: false).fetchFranMgmt(viewType,page);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if(page == 1 || viewType!="day") {
        await Provider.of<PointMgmtProvider>(context, listen: false)
            .fetchFranMgmt(viewType, page);
      }
    });
    return
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 1.5,
          title: Text("활동현황",
            style: appBarDefaultText,
          ),
          backgroundColor: white,
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
        Consumer<PointMgmtProvider>(
            builder: (context, pm, _){
              return
                Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 16.0),
                        decoration: BoxDecoration(
                          color: white,
                        ),
                        child: Row(
                          children: [
                            Column (
                              children: [
                                (Provider.of<UserProvider>(context, listen: false).loginUser.userGrade == "NORMAL") ?
                                pm.disMap != null ?
                                Row(
                                  children: [
                                    Text("${pm.disMap['username']}   ",
                                        style: Subtitle2
                                    ),
                                    Text("${pm.disMap['phone'].toString().substring(0,3)}-"
                                        "${pm.disMap['phone'].toString().substring(3,7)}-"
                                        "${pm.disMap['phone'].toString().substring(7,11)}",
                                        style: Body2.apply(
                                          fontWeightDelta: 1
                                        )
                                    ),
                                  ],
                                ) : Row()
                                    : whiteSpaceH(1),
                                whiteSpaceH(5),
                                (Provider.of<UserProvider>(context, listen: false).loginUser.userGrade == "NORMAL") ?
                                pm.ageMap != null ?
                                Row(
                                  children: [
                                    Text("${pm.ageMap['username']}   ",
                                        style: Subtitle2
                                    ),
                                    Text("${pm.disMap['phone'].toString().substring(0,3)}-"
                                        "${pm.disMap['phone'].toString().substring(3,7)}-"
                                        "${pm.disMap['phone'].toString().substring(7,11)}",
                                        style: Body2.apply(
                                            fontWeightDelta: 1
                                        )
                                    ),
                                  ],
                                ) : Row()
                                    : whiteSpaceH(1),
                                whiteSpaceH(10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("${Provider.of<UserProvider>(context, listen:false).storeModel.store.name}",
                                        style: Subtitle1.apply(
                                          color: primary,
                                          fontWeightDelta: 2
                                        )
                                    ),
                                    Text("${Provider.of<UserProvider>(context, listen:false).storeModel.store.tel.substring(0,3)}-"
                                        "${Provider.of<UserProvider>(context, listen:false).storeModel.store.tel.substring(3,7)}-"
                                        "${Provider.of<UserProvider>(context, listen:false).storeModel.store.tel.substring(7,11)}",
                                        style: Subtitle2.apply(
                                          fontWeightDelta: -1
                                        )
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Spacer(),
                            Image.asset(
                              "assets/icon/s_store.png",
                              width: 48,
                              height: 48,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              border: Border.all(
                                color: primary,
                                width: 2
                              )
                            ),
                            child:
                            Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child:
                                    Padding(
                                      padding: const EdgeInsets.only(top: 30.0, left: 12.0, right: 12.0, bottom: 30.0),
                                      child:Column(
                                        children: [
                                          Text("광고주 포인트",
                                              style: Caption.apply(
                                                color: secondary
                                              )
                                          ),
                                          whiteSpaceH(5),
                                          Text("${numberFormat.format(pm.adp)} ADP",
                                              style: Caption.apply(
                                                  color:black,
                                                fontWeightDelta: 3
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 24,
                                    color: deActivatedGrey,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child:
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15.0, left: 12.0, right: 12.0, bottom: 15.0),
                                      child:Column(
                                        children: [
                                          Text("총 현장결제",
                                              style: Caption.apply(
                                                  color: secondary
                                              )
                                          ),
                                          whiteSpaceH(5),
                                          Text("${numberFormat.format(pm.pay)}원",
                                              style: Caption.apply(
                                                  color:black,
                                                  fontWeightDelta: 3
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 24,
                                    color: deActivatedGrey,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child:
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15.0, left: 12.0, right: 12.0, bottom: 15.0),
                                      child:Column(
                                        children: [
                                          Text("총 DL 결제",
                                              style: Caption.apply(
                                                  color: secondary
                                              )
                                          ),
                                          whiteSpaceH(5),
                                          Text("${numberFormat.format(pm.dl)} DL",
                                              style: Caption.apply(
                                                  color:black,
                                                  fontWeightDelta: 3
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]
                            )
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          child:
                          Container(
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
                                      elevation: 0.0,
                                      color: white,
                                      disabledColor: white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          side: BorderSide(
                                              color: (viewType == "day") ? primary : third,
                                          )
                                      ),
                                      child:
                                      Text(
                                        "일간",
                                        style: Body1.apply(
                                            color: (viewType == "day") ? black : third,
                                          fontWeightDelta: 1
                                        )
                                      ),
                                    ),
                                    whiteSpaceW(10),
                                    RaisedButton(
                                      onPressed: (viewType == "month") ? null : () {
                                        setState(() {
                                          viewType = "month";
                                        });
                                      },
                                      elevation: 0.0,
                                      color: white,
                                      disabledColor: white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          side: BorderSide(
                                              color: (viewType == "month") ? primary : third
                                          )
                                      ),
                                      child:
                                      Text(
                                        "월간",
                                          style: Body1.apply(
                                              color: (viewType == "month") ? black : third,
                                              fontWeightDelta: 1
                                          )
                                      ),
                                    ),
                                    whiteSpaceW(10),
                                    RaisedButton(
                                      onPressed: (viewType == "year") ? null : () {
                                        setState(() {
                                          viewType = "year";
                                        });
                                      },
                                      elevation: 0.0,
                                      color: white,
                                      disabledColor: white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          side: BorderSide(
                                              color: (viewType == "year") ? primary : third
                                          )
                                      ),
                                      child:
                                      Text(
                                        "연간",
                                          style: Body1.apply(
                                              color: (viewType == "year") ? black : third,
                                              fontWeightDelta: 1
                                          )
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
                valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
            )
        )
            :
        Container(
          child: ListView.builder(
            itemBuilder: (context, idx) {
              if(idx < pm.pfmList_my.length){
                return ReportItem(pm.pfmList_my[idx]);
              }
              if(pm.pfmList_my.length == 0) {
                return SizedBox();
              }
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
                  )
              );
            },
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: pm.pfmList_my.length,
          ),
        );
      },
    );
  }

  Widget ReportItem(PointReportModel data) {
    print("hi");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0, right: 12.0, left: 12.0),
          child: Text("${data.base_mday} ${(viewType == "month") ? "월" : "년"}",
              style: Body1.apply(
                fontWeightDelta: -1
              )
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right:12.0, left:12.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child:Image.asset(
                      "assets/resource/public/krw-coin.png", width: 30, fit: BoxFit.contain,)
                ),
                Expanded(
                  flex: 5,
                  child:Container(
                      child:
                      Text("  ${numberFormat.format(double.parse(data.base_amount))} 원",
                          overflow: TextOverflow.ellipsis,
                          style: Subtitle1.apply(
                            color: primary
                          )
                      )
                  ),
                ),
                Expanded(
                    flex: 2,
                    child:Image.asset(
                      "assets/icon/DL 2.png", width: 30, fit: BoxFit.contain,)
                ),
                Expanded(
                  flex: 5,
                  child:Container(
                      child:
                      Text("  ${numberFormat.format(double.parse(data.sub_amount))} DL",
                          overflow: TextOverflow.ellipsis,
                          style: Subtitle1.apply(
                              color: etcYellow
                          )
                      )
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
        return
          Container(
            child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if(scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                    if(!pm.isLoading && pm.pfmList.length != 0 && !pm.isLastPage) {
                      loadMore();
                    }
                  }

                  return true;
                },
                child: ListView.builder(
                  itemBuilder: (context, idx) {
                    if(idx < pm.pfmList.length){
                      return historyItem(pm.pfmList[idx]);

                    }
                    if(pm.pfmList.length == 0) {
                      return SizedBox();
                    }
                    return Center(
                        child: Opacity(
                            opacity: pm.isLoading ? 1.0 : 0.0,
                            child:CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
                            )
                        )
                    );
                  },
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: pm.pfmList.length + 1,
                )
            ),
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
          padding: const EdgeInsets.only(bottom: 5.0, right: 12.0, left: 12.0),
          child: Text(DateFormat("yy.MM.dd").format(
              DateTime.parse( data['date'].toString())),
              style: Body2
          ),
        ),
        Column(
          children: histories.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0, right: 12.0, left: 12.0),
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
                        flex: 5,
                        child:Container(
                            child:
                            Text(
                                "    ${e['title']}  ",
                                style: Subtitle1.apply(
                                    color: (e['title'].toString().contains("DL")) ? Color(0xffBE1833)
                                        : Color(0xFFFF6622))
                            )
                        ),
                      ),
                      Expanded(
                          flex:3,
                          child:Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(top: 15.0, right: 13.0),
                              child:Text(
                                  "${e['time'].toString().split(":")[0]}:${e['time'].toString().split(":")[1]}",
                                  style: Body2
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
