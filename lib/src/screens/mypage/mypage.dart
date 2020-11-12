import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/point.dart';
import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/PointMgmtProvider.dart';
import 'package:cashcook/src/provider/RecoProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/mypage/points/integratedPoint.dart';
import 'package:cashcook/src/screens/mypage/points/pointMgmt.dart';
import 'package:cashcook/src/screens/mypage/points/pointMgmtUser.dart';
import 'package:cashcook/src/screens/qr/qrcreate.dart';
import 'package:cashcook/src/screens/referrermanagement/referrermanagement.dart';
import 'package:cashcook/src/utils/CustomBottomNavBar.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/dialog.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cashcook/src/screens/mypage/info/scrap.dart';

class MyPage extends StatefulWidget {
  bool isHome;

  MyPage({this.isHome = false});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  ScrollController _scrollController = ScrollController();

  bool isCheck = false;

  String view = "My";

  String ageView = "History";
  String selectUser = "";
  String viewType = "day";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
          child: body(),
          onWillPop: ExitPressed
      );
  }

  Future<bool> ExitPressed() {
    return showDialog( context: context,
      builder: (context) => AlertDialog( content: Container(
          child: Text("앱을 종료하시겠습니까?",
            style: TextStyle(
                fontFamily: 'noto',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333)
            ),
            textAlign: TextAlign.center,
          )
      ),
        actions: <Widget>[
          FlatButton(
            child: Text("예",
              style: TextStyle(
                  fontFamily: 'noto',
                  fontSize: 14,
                  color: mainColor
              ),
            ),
            onPressed: () => Navigator.pop(context, true), ),
          FlatButton(
            child: Text("아니요",
              style: TextStyle(
                  fontFamily: 'noto',
                  fontSize: 14,
                  color: subColor
              ),
            ),
            onPressed: () => Navigator.pop(context, false), ), ], ), ) ?? false;

  }

  Widget body(){
    UserCheck userCheck = Provider.of<UserProvider>(context,listen: false).loginUser;

    return
      Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          elevation: 2.0,
          leading: widget.isHome ? null : IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Image.asset(
              "assets/resource/public/close.png",
              width: 24,
              height: 24,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if(view != "My") {
                        setState(() {
                          view = "My";
                        });
                      }
                    },
                    child: (view == "My") ?
                    Text("마이", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color: Color(0xFF333333)),)
                        :
                    Text("마이", style: TextStyle(fontSize: 14, color: Color(0xFF333333)),),
                  ),
                  whiteSpaceW(20.0),
                  InkWell(
                    onTap: () {
                      if(!userCheck.isFran)
                        _showDialog();
                      else {
                        if(view != "Store"){
                          setState(() {
                            view = "Store";
                          });
                        }
                      }
                    },
                    child: (view == "Store") ?
                    Text("매장", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color: Color(0xFF333333)),)
                        :
                    Text("매장", style: TextStyle(fontSize: 14, color: Color(0xFF333333)),),
                  ),
                  whiteSpaceW(20.0),
                  (userCheck.userGrade == "DISTRIBUTOR" || userCheck.userGrade == "AGENCY") ? InkWell(
                    onTap: () {
                      if(view != "Agecy"){
                        setState(() {
                          view = "Agecy";
                        });
                      }
                    },
                    child: (view == "Agecy") ?
                    Text("대리점", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color: Color(0xFF333333)),)
                        :
                    Text("대리점", style: TextStyle(fontSize: 14, color: Color(0xFF333333)),),
                  ) : SizedBox()
                ],
              )
            )
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(child:
            SingleChildScrollView(
              child:Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Container(
                        color: white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (view == "My") ? myPageForm()
                                : (view == "Store") ? storeForm()
                                : agencyForm(),
                          ],
                        ),
                      )
                  ),

                ],
              ),
            ),
            ),
            widget.isHome ? CustomBottomNavBar(context, "mypage") : Container(),
          ],
        )
      );
  }

  Widget myPageForm() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen:false).fetchMyInfo(context);
    });
    return Consumer<UserProvider>(
      builder: (context, user, _){
        return (user.isLoading) ?
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 53 - 50,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
              child: CircularProgressIndicator(
                  backgroundColor: mainColor,
                  valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
              )
          ),
        )
            :
        Column(
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 30.0, left: 12.0, right: 12.0, bottom: 10),
                  decoration: BoxDecoration(
                    color: white,
                  ),
                  child: InkWell(
                    onTap: () async{
                      await Navigator.pushNamed(context, "/userState");
                    },
                    child:
                    Container(
                      child: Column(
                        children: [
                          Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                      style: TextStyle(fontSize:16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
                                      children: [
                                        TextSpan(text:"${user.loginUser.name}", style: TextStyle(fontSize: 25, color: Color(0xFF333333))),
                                        TextSpan(text:" 님\n"),
                                        TextSpan(text:"반갑습니다.")
                                      ]
                                  ),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios, size: 24,color: Color(0xFF333333),),
                              ]
                          ),
                          whiteSpaceH(40),
                          Row(
                              children: [
                                InkWell(
                                  onTap: (){
                                    Map<String, dynamic> args = {
                                      "point":"RP",
                                      "pointImg":"assets/icon/c_point.png"
                                    };
                                    Navigator.of(context).pushNamed("/point/history", arguments: args);
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset("assets/icon/c_point.png",height: 24, fit: BoxFit.contain,),
                                      whiteSpaceW(5),
                                      Text("${demicalFormat.format(user.pointMap['RP'])} CP",style: TextStyle(fontSize: 12, color: Color(0xFF333333)),),
                                      Icon(Icons.arrow_forward_ios, color: Color(0xFF333333), size: 12,),
                                    ],
                                  ),
                                ),
                                whiteSpaceW(20),
                                InkWell(
                                  onTap: (){
                                    Map<String, dynamic> args = {
                                      "point":"DL",
                                      "pointImg":"assets/icon/DL 2.png"
                                    };
                                    Navigator.of(context).pushNamed("/point/history", arguments: args);
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset("assets/icon/DL 2.png",height: 24, fit: BoxFit.contain,),
                                      whiteSpaceW(5),
                                      Text("${demicalFormat.format(user.pointMap['DL'])} DL",style: TextStyle(fontSize: 12, color: Color(0xFF333333)),),
                                      Icon(Icons.arrow_forward_ios, color: Color(0xFF333333), size: 12,),
                                    ],
                                  ),
                                ),
                              ]
                          ),
                        ],
                      ),
                    ),
                  )
              ),
              Column(
                  children:[
                    SizedBox(height: 24,),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                            children: [
                              HistoryCard(),
                              RecoCard(),
                              easyPayCard(),
                              scrapCard(),
                              SizedBox(height: 16,),
                              Tabs(name: "공지사항", routesName: "/notice",),
                              CustomerCenter(),
                              Tabs(name: "FAQ", routesName: "/faq",),
                              Tabs(name: "서비스 문의", routesName: "/inquiry",),
                              Tabs(name: "약관 및 정책", routesName: "",),
                              Tabs(name: "앱정보", routesName: "/appinfomation",),
                              SizedBox(height: 40,),
                            ]
                        )
                    ),
                    (!user.loginUser.isFran) ? Tabs2(name: "제휴매장 등록하기", routesName: "/store/apply1",img: "assets/icon/shop.png",): SizedBox(),
                    SizedBox(height: 12,),
                    Tabs2(name: "캐시링크 가기", routesName: "cashlink",img: "assets/icon/cashlink-icon.png",),
                  ]
              )
            ]
        );
      }
    );
  }

  Widget agencyForm() {
    UserCheck user = Provider.of<UserProvider>(context, listen: false).loginUser;
    return Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 30.0, left: 12.0, right: 12.0, bottom: 50.0),
            decoration: BoxDecoration(
              color: white,
            ),
            child: Row(
              children: [
                Column (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    whiteSpaceH(10),
                    Row(
                      children: [
                        Text("${user.username}  ",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            )),
                        Text("${user.phone}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Container(
                transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),

                ),
                child:
                  Consumer<RecoProvider>(
                  builder: (context, reco, _){
                  return Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child:
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 12.0, right: 12.0, bottom: 15.0),
                            child:Column(
                              children: [
                                Text("ADP 리워드",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: white,
                                    )),
                                whiteSpaceH(5),
                                Text("${numberFormat.format(reco.adp)} ADP",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: white,
                                        fontWeight: FontWeight.w600
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child:
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 12.0, right: 12.0, bottom: 15.0),
                            child:Column(
                              children: [
                                Text("현금리워드",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: white,
                                    )),
                                whiteSpaceH(5),
                                Text("${numberFormat.format(reco.pay)}원",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: white,
                                        fontWeight: FontWeight.w600
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child:
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 12.0, right: 12.0, bottom: 15.0),
                            child:Column(
                              children: [
                                Text("대리점 수",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: white,
                                    )),
                                whiteSpaceH(5),
                                Text("${user.userGrade == "DISTRIBUTOR" ? numberFormat.format(reco.ageAmount) : 0} 개",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: white,
                                        fontWeight: FontWeight.w600
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child:
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 12.0, right: 12.0, bottom: 15.0),
                            child:Column(
                              children: [
                                Text("가맹점 수",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: white,
                                    )),
                                whiteSpaceH(5),
                                Text("${user.userGrade == "DISTRIBUTOR" ? numberFormat.format(reco.franAmount) : numberFormat.format(reco.ageAmount)}개",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: white,
                                        fontWeight: FontWeight.w600
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ]
                  );
                  }
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  height: 50,
                  child: Row (
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap:() {
                              setState(() {
                                ageView = "History";
                              });
                          },
                          child: (ageView == "History") ?
                              Container(
                              child:Text("대리점/가맹점 내역", style: TextStyle(fontSize: 16, color: mainColor, fontWeight: FontWeight.w600)),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border(bottom: BorderSide(color: mainColor, width: 3)
                                      )
                                  )
                              )
                          :
                          Text("대리점/가맹점 내역", style: TextStyle(fontSize: 16)),
                        ),
                        whiteSpaceW(20.0),
                        InkWell(
                          onTap:() {
                            setState(() {
                              ageView = "Reward";
                              viewType = "month";
                            });
                          },
                          child: (ageView == "Reward") ?
                              Container(
                              child:Text("리워드 내역", style: TextStyle(fontSize: 16, color: mainColor, fontWeight: FontWeight.w600)),
                              decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(bottom: BorderSide(color: mainColor, width: 3)
                              )
                              )
                              )

                            :
                          Text("리워드 내역", style: TextStyle(fontSize: 16),),
                        ),
                        whiteSpaceW(20.0),
                      ]
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(bottom: BorderSide(color:Colors.grey, width: 1)
                      )
                  ),
                ),
              ],
            ),
          ),
          (ageView == "History") ?
              GradeRecoForm()
                :
              RewardForm(),
        ]
    );  
  }

  Widget GradeRecoForm() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<RecoProvider>(context, listen: false).fetchGradeReco(
        Provider.of<UserProvider>(context, listen: false).loginUser
      );
    });
    return Consumer<RecoProvider>(
      builder: (context, reco, _) {
        print(reco.gradeReferrer);
        return
          Container(
            height: 300,
            child:
            ListView.builder(
              itemBuilder: (context, idx) {
                if (idx < reco.gradeReferrer.length) {
                  return RecoItem(reco.gradeReferrer[idx]);
                }
                return Center(
                    child: CircularProgressIndicator(
                        backgroundColor: mainColor,
                        valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
                    )
                );
              },
              itemCount: reco.gradeReferrer.length,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
            )
          );
      },
    );
  }

  Widget RecoItem(data) {
    return Row(
      children: [
        whiteSpaceW(16),
        Image.asset(
          data.type == 0
              ? "assets/resource/public/directly.png"
              : data.type == 1
              ? "assets/resource/public/indirect.png"
              : "assets/resource/public/friend-none.png",

          width: 32,
          height: 60,
        ),
        whiteSpaceW(12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                  (data.type == 1) ? " (가맹점)" : " (대리점)",
                  style: TextStyle(
                      fontFamily: 'noto',
                      fontSize: 14,
                      color: (data.type == 1) ? mainColor : Colors.amberAccent,
                      fontWeight: FontWeight.w600),
                ),
              ]
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
            InkWell(
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => IntegratedPoint(),
                      settings: RouteSettings(
                          arguments : {
                            "username" : data.name,
                            "phone": data.phone,
                          }
                      )),);
              },
              child:Text(
                "활동현황",
                style: TextStyle(
                    fontSize: 12, fontFamily: 'noto', color: mainColor, decoration: TextDecoration.underline),
              )
            ),
            data.type == 1
                ? Text(
              "By " + data.byName,
              style: TextStyle(
                  fontFamily: 'noto', fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.end,
            )
                : Container()
          ],
        ),
        whiteSpaceW(16)
      ],
    );
  }

  Widget RewardForm() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<PointMgmtProvider>(context, listen: false).fetchBizMgmt(viewType);
    });
    return Column(
      children: [
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
                        onPressed: (viewType == "month") ? null : () {
                          setState(() {
                            viewType = "month";
                          });
                        },
                        color: white,
                        disabledColor: mainColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(color: mainColor)
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
                            side: BorderSide(color: mainColor)
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
        ReportList()
      ]
    );
  }

  Widget ReportList() {
    return Consumer<PointMgmtProvider>(
      builder: (context, pm, _) {
        return
              Container(
                  height: 300,
                  child:
                  ListView.builder(
                    itemBuilder: (context, idx) {
                      if (idx < pm.pbmList.length) {
                        return ReportItem(pm.pbmList[idx]);
                      }
                    },
                    itemCount: pm.pbmList.length,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
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
          padding: const EdgeInsets.only(bottom: 5.0, right: 12.0, left: 12.0),
          child: Text("${data.base_mday} ${(viewType == "month") ? "월" : "년"}",
              style: TextStyle(
                  fontFamily: 'noto',
                  fontSize: 12,
                  color: Color(0xff888888))),
        ),
        Container(
          padding: const EdgeInsets.only(right:16.0, left:16.0,bottom: 10.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child:Text("ADP",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'noto',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color:Color(0xff626262)))
                ),
                Expanded(
                  flex: 4,
                  child:Container(
                      child:
                      Text(" ${numberFormat.format(double.parse(data.base_amount))} ADP",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'noto',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: mainColor))
                  ),
                ),
                Expanded(
                    flex: 2,
                    child:Text("현금",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'noto',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color:Color(0xff626262)))
                ),
                Expanded(
                  flex: 4,
                  child:Container(
                      child:
                      Text(" ${numberFormat.format(double.parse(data.sub_amount))} 원",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'noto',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: subYellow))
                  ),
                ),
              ]
          ),
        )
      ],
    );
  }
  
  Widget storeForm(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen:false).fetchMyInfo(context);
    });
    return Consumer<UserProvider>(
        builder: (context, user, _) {
          return (user.isLoading) ?
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 53 - 50,
            decoration: BoxDecoration(
              color: white,
            ),
            child: Center(
                child: CircularProgressIndicator(
                    backgroundColor: mainColor,
                    valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
                )
            ),
          )
              :
          Column(
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0, bottom: 10),
                    decoration: BoxDecoration(
                      color: white,
                    ),
                    child: InkWell(
                      onTap: () async{
                        await Navigator.of(context).pushNamed("/store/modify/store");
                      },
                      child:
                      Container(
                        child: Column(
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text("${user.storeModel.store.name}", style: TextStyle(fontSize: 25, color: Color(0xFF333333), fontWeight: FontWeight.w600))
                                          ),
                                          whiteSpaceW(10),
                                          Icon(Icons.arrow_forward_ios, size: 24,color: Color(0xFF333333),),
                                        ]
                                      ),
                                      whiteSpaceH(8.0),
                                      Text("${user.storeModel.store.tel}\n", style: TextStyle(fontSize: 20,color: Color(0xFF333333), fontWeight: FontWeight.w600)),
                                    ]
                                  ),
                                  Spacer(),
                                  CachedNetworkImage(
                                    imageUrl: user.storeModel.store.shop_img1,
                                    imageBuilder: (context, img) => Container(
                                        width: 64,
                                        height: 64,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            image: DecorationImage(
                                                image: img, fit: BoxFit.fill
                                            )
                                        )
                                    ),
                                  ),
                                ]
                            ),
                            Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Map<String, dynamic> args = {
                                        "point":"ADP",
                                        "pointImg":"assets/icon/adp.png",
                                        "dlAccount": user.pointMap['DL']
                                      };
                                      Navigator.of(context).pushNamed("/point/history", arguments: args);
                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset("assets/icon/adp.png",height: 24, fit: BoxFit.contain,),
                                        whiteSpaceW(5),
                                        Text("${demicalFormat.format(user.pointMap['ADP'])} ADP",style: TextStyle(fontSize: 12, color: Color(0xFF333333)),),
                                        Icon(Icons.arrow_forward_ios, color: Color(0xFF333333), size: 12,),
                                      ],
                                    ),
                                  ),
                                ]
                            ),
                          ],
                        ),
                      ),
                    )
                ),
                Container(
                      color: white,
                      child:Column(
                          children:[
                            SizedBox(height: 24,),
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                    children: [
                                      QrCard(),
                                      HistoryCard(),
                                      sellDlCard(),
                                      whiteSpaceH(16.0),
                                      Tabs(name: "알림", routesName: "/store/modify/business",),
                                      Tabs(name: "사업자정보 수정", routesName: "/store/modify/business",),
                                      Tabs(name: "매장정보 수정", routesName: "/store/modify/store",),
                                      Tabs(name: "DL 결제 한도 설정", routesName: "/store/modify/limitDL",),
                                      CustomerCenter(),
                                    ]
                                )
                            ),
                          ]
                      ),
                  ),
              ]
          );
        }
    );
  }

  //이용 내역
  Widget HistoryCard(){
    return InkWell(
      onTap: (){
        if(view == "My"){
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => pointMgmtUser()
          ));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => pointMgmt()
          ));
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icon/recommend.png", height: 42, fit: BoxFit.contain,),
              SizedBox(width: 12,),
              Text("이용내역",style: TextStyle(fontSize: 16,color: Color(0xff444444), fontWeight: FontWeight.w600)),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Color(0xff444444), size: 24,),
            ],
          ),
        ),
      ),
    );
  }

  //큐알 생성기
  qrCreate(type) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => QrCreate(
          type: type,
        )
    ));
  }

  Widget easyPayCard(){
    return InkWell(
      onTap: (){
        showAlert();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icon/card_blue.png", height: 42, fit: BoxFit.contain,),
              SizedBox(width: 12,),
              Text("간편결제 관리",style: TextStyle(fontSize: 16,color: Color(0xff444444), fontWeight: FontWeight.w600)),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Color(0xff444444), size: 24,),
            ],
          ),
        ),
      ),
    );
  }

  Widget QrCard(){
    return InkWell(
      onTap: (){
        dialog(
            title: "QR생성 안내",
            content: "고객의 결제방식을\n확인해주세요.",
            sub: "",
            context: context,
            selectOneText: "현장결제",
            selectTwoText: "DL결제",
            selectOneVoid: () => qrCreate(0),
            selectTwoVoid: () => qrCreate(1)
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/resource/map/qr.png", height: 42, fit: BoxFit.contain,),
              SizedBox(width: 12,),
              Text("결제QR 생성",style: TextStyle(fontSize: 16,color: Color(0xff444444), fontWeight: FontWeight.w600)),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Color(0xff444444), size: 24,),
            ],
          ),
        ),
      ),
    );
  }

  showAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("알림"),
            content: Text("서비스 준비중입니다."),
          );
        });
  }

  Widget sellDlCard(){
    return InkWell(
      onTap: (){
        showAlert();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icon/DL 2.png", height: 42, fit: BoxFit.contain,),
              SizedBox(width: 12,),
              Text("DL 판매",style: TextStyle(fontSize: 16,color: Color(0xff444444), fontWeight: FontWeight.w600)),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Color(0xff444444), size: 24,),
            ],
          ),
        ),
      ),
    );
  }

  //추천인 관리
  Widget RecoCard(){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ReferrerManagement()
        ));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
//              Image.asset("assets/icon/friends-wt.png", height: 32, fit: BoxFit.contain,),
              Image.asset("assets/icon/recommend.png", height: 42, fit: BoxFit.contain,),
              SizedBox(width: 12,),
              Text("추천인 관리",style: TextStyle(fontSize: 16,color: Color(0xff444444), fontWeight: FontWeight.w600)),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.black, size: 24,),
            ],
          ),
        ),
      ),
    );
  }

  //추천인 관리
  Widget scrapCard(){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Scrap()
        ));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icon/recommend.png", height: 42, fit: BoxFit.contain,),
              SizedBox(width: 12,),
              Text("찜한 매장",style: TextStyle(fontSize: 16,color: Color(0xff444444),fontWeight: FontWeight.w600)),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.black, size: 24,),
            ],
          ),
        ),
      ),
    );
  }

  //알림 뷰
  Widget Alarm(){
    return InkWell(
      onTap: (){
        setState(() {
          isCheck = !isCheck;
        });
      },
        child: Container(
          height: 48,
          child: Row(
            children: [
              Text("알림", style: TextStyle(fontSize: 14,color: Colors.black),),
              Spacer(),
              Switch(
                onChanged: (bool value){
                  setState(() {
                    isCheck = value;
                  });
                },
                value: isCheck,
                  activeColor: mainColor,
              ),
            ],
      ),
        ),
    );
  }

  //고객센터
  Widget CustomerCenter(){
    return InkWell(
      onTap: ()async {
        await launch("tel://15001500");
      },
          child: Container(
            height: 48,
            color: white,
            child: Row(
              children: [
                Text("문의하기",style: TextStyle(fontSize: 14, color: Color(0xff444444)),),
                Spacer(),
                Text("HOJOGroup",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600, color: Color(0xff444444)),),
                SizedBox(width: 12,),
                Text("1500-1500",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600, color: Color(0xffffcc00)),)
              ],
      ),
          ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("아직 매장등록을 안하셨군요!\n매장등록을 하시고,\n여러가지 포인트 혜택을 누려보세요!",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff444444),
              ),),
            actions: <Widget>[
              FlatButton(
                child: new Text("예"),
                onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed("/store/apply1");
                }
              ),
              FlatButton(
                child: new Text("아니요"),
                onPressed: () {
                  Navigator.pop(context);
                }
              ),
            ]
          );
        }
    );
  }
}

/*
class DeliveryCard extends StatefulWidget {
  @override
  _DeliveryCard createState() => _DeliveryCard();
}

class _DeliveryCard extends State<DeliveryCard> {
  bool status = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
      },
      enableFeedback:false,
      child: Container(
        height: 55.0,
        color: white,
        child: Row(
          children: [
            Text("DL 결제 한도 설정",style: TextStyle(fontSize: 14,color: Color(0xff444444)),),
            Spacer(),
            FlutterSwitch(
              width: 40.0,
              height: 22.0,
              toggleColor: status ? mainColor : white,
              toggleSize: 24.0,
              padding: 0.0,
              activeColor: subBlue,
              inactiveColor: Color(0xFFDDDDDD),
              value: status,
              onToggle: (val) {
                setState(() {
                  status = val;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}*/

class Tabs extends StatelessWidget {
  final String routesName;
  final String name;

  Tabs({this.routesName, this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Navigator.of(context).pushNamed(routesName);
        },
        enableFeedback:false,
          child: Container(
            height: 48,
            color: white,
            child: Row(
              children: [
                Text(name,style: TextStyle(fontSize: 14,color: Color(0xff444444)),),
                Spacer(),
                Icon(Icons.arrow_forward_ios, size: 24, color: Color(0xff444444),)
              ],
        ),
          ),
    );
  }
}

class Tabs2 extends StatelessWidget {
  final String routesName;
  final String name;
  final String img;

  Tabs2({this.routesName, this.name, this.img});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFFEEEEEE),
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
        child: InkWell(
          onTap: () async{
            if(routesName == "cashlink"){
              await launch("http://cashlink.kr");
            }else {
              Navigator.of(context).pushNamed(routesName);
            }

          },
          child: Row(
            children: [
              Text(name,style: TextStyle(fontSize: 14,color: Color(0xff444444)),),
              Spacer(),
              Image.asset(img,width: 48, fit: BoxFit.contain,),
            ],
          ),
        ),
    );
  }
}



