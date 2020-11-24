import 'package:cashcook/src/provider/PointMgmtProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

class IntegratedPoint extends StatefulWidget {
  @override
  _IntegratedPoint createState() => _IntegratedPoint();
}

class _IntegratedPoint extends State<IntegratedPoint> {
  ScrollController _scrollController = ScrollController();

  String username = "";
  String phone = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute
        .of(context)
        .settings
        .arguments as Map<String, dynamic>;

    username = args['username'];
    phone = args['phone'];

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("$username 활동현황",
        style: appBarDefaultText),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: mainColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset(
            "assets/resource/public/close.png",
            width: 24,
            height: 24,
          ),
        ),
      ),
      body: Column(
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
              Row(
                children: [
                  Text("$username   ",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: white,
                      )),
                  Text("$phone",style: TextStyle(
                    fontSize: 20,
                    color: white,
                  )),
                ],
              ),

            ],
          ),
        ],
      ),
    ),
            Consumer<PointMgmtProvider>(
              builder: (context, pm, _) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 5.0, top: 5.0),
                      transform: Matrix4.translationValues(0.0, -30.0, 0.0),
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
                                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                child:Column(
                                  children: [
                                    Text("ADP",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff888888),
                                        )),
                                    whiteSpaceH(5),
                                    Text("${numberFormat.format(pm.adp)} ADP",
                                        style: TextStyle(
                                            fontSize: 12,
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
                                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                child:Column(
                                  children: [
                                    Text("RP",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff888888),
                                        )),
                                    whiteSpaceH(5),
                                    Text("${numberFormat.format(pm.rp)} RP",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: subYellow,
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
                                padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0, bottom: 5.0),
                                child:Column(
                                  children: [
                                    Text("DL",
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
                            Expanded(
                              flex: 1,
                              child:
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0, bottom: 5.0),
                                child:Column(
                                  children: [
                                    Text("가맹점 수",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff888888),
                                        )),
                                    whiteSpaceH(5),
                                    Text("${numberFormat.format(pm.franAmount)} 개",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: mainColor,
                                            fontWeight: FontWeight.w600
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ]
                      )
                  ),
                );
              }
            ),
      Flexible(
        child:historyList()
      ),
    ]
    )
    );
  }

  Widget historyList() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<PointMgmtProvider>(context, listen:false).fetchMgmtOther(username);
    });
    return Consumer<PointMgmtProvider>(
      builder: (context, pm, _){
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
                  return historyItem(pm.pomList[idx]);
              },
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: pm.pomList.length,
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
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
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
                                      (e['title'].toString().contains("DL") || (e['title'].toString().contains("ADP")) ? Color(0xffBE1833)
                                          : (e['title'].toString().contains("RP")) ? subYellow
                                          :  Colors.black),
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



