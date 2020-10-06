import 'package:cached_network_image/cached_network_image.dart';
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

class pointMgmt extends StatefulWidget {
  @override
  _pointMgmtState createState() => _pointMgmtState();
}

class _pointMgmtState extends State<pointMgmt> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<PointMgmtProvider>(context, listen: false).fetchFranMgmt();
    });

    return
      Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xffffdd00),
      ),
      body:
        Consumer<PointMgmtProvider>(
          builder: (context, pm, _){
            return (pm.isLoading) ?
                Center(
                    child:
                    CircularProgressIndicator(
                      backgroundColor: Color(0xffffdd00),
                      valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                    )
                )
                :
            Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 30.0, left: 12.0, right: 12.0, bottom: 50.0),
                    decoration: BoxDecoration(
                      color: Color(0xffffdd00),
                    ),
                    child: Row(
                      children: [
                        Column (
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("${pm.disMap['username']}   ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600
                                    )),
                                Text("${pm.disMap['phone']}"),
                              ],
                            ),
                            whiteSpaceH(5),
                            Row(
                              children: [
                                Text("${pm.ageMap['username']}   ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600
                                    )),
                                Text("${pm.ageMap['phone']}"),
                              ],
                            ),
                            whiteSpaceH(10),
                            Row(
                              children: [
                                Text("${Provider.of<UserProvider>(context, listen:false).storeModel.store.name}   ",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600
                                    )),
                                Text("${Provider.of<UserProvider>(context, listen:false).storeModel.store.tel}"),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        CachedNetworkImage(
                          imageUrl: "${Provider.of<UserProvider>(context, listen: false).storeModel.store.shop_img1}",
                          fit: BoxFit.contain,
                          width: 70,
                          height: 70,
                        ),
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
                                  padding: const EdgeInsets.only(top: 30.0, left: 12.0, right: 12.0, bottom: 30.0),
                                  child:Column(
                                    children: [
                                      Text("광고주 포인트",
                                          style: TextStyle(
                                            color: Color(0xff888888),
                                          )),
                                      whiteSpaceH(5),
                                      Text("${numberFormat.format(pm.adp)} ADP",
                                          style: TextStyle(
                                              color: Color(0xffD4145A),
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
                                      Text("총 현장결제",
                                          style: TextStyle(
                                            color: Color(0xff888888),
                                          )),
                                      whiteSpaceH(5),
                                      Text("${numberFormat.format(pm.pay)}원",
                                          style: TextStyle(
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
                                            color: Color(0xff888888),
                                          )),
                                      whiteSpaceH(5),
                                      Text("${numberFormat.format(pm.dl)} BZA",
                                          style: TextStyle(
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
                  Flexible(
                      child: historyList()
                  ),
                ]
            );
          }
        ),
    );
  }

  Widget historyList() {
    return Consumer<PointMgmtProvider>(
      builder: (context, pm, _) {
        print("여기임");
        print(pm.pfmList);
        return Container(
            transform: Matrix4.translationValues(0.0, -20.0, 0.0),
          child:
          ListView.builder(
            controller: _scrollController,
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
                  child: CircularProgressIndicator(),
                ),
              );
            },
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: pm.pfmList.length + 1,
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
                    fontWeight: FontWeight.w600,
                    color: Color(0xff888888))),
        ),
        Column(
          children: histories.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0, right: 12.0, left: 12.0),
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
                                Text(
                                    "    ${e['title']}  ",
                                    style: TextStyle(
                                        fontFamily: 'noto',
                                        fontSize: 23,
                                        fontWeight: FontWeight.w600,
                                        color: (e['title'].toString().contains("BZA")) ? Color(0xffBE1833)
                                            : Color(0xFFFF6622))
                                )
                            ),
                          ),
                          Expanded(
                            flex:2,
                            child:Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(top: 15.0, right: 13.0),
                                child:Text(
                                    "${e['time']}\n",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'noto',
                                        color: Color(0xff888888))
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
