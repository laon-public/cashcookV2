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
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/dialog.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPage extends StatefulWidget {
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
    return body();
  }

  Widget body(){
    UserCheck userCheck = Provider.of<UserProvider>(context,listen: false).loginUser;

    return SingleChildScrollView(
      child:Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    height: 50,
                      child: Row (
                        mainAxisAlignment: MainAxisAlignment.end,
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
                              Text("마이", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),)
                                  :
                              Text("마이", style: TextStyle(fontSize: 16),),
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
                              Text("매장", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),)
                                  :
                              Text("매장", style: TextStyle(fontSize: 16),),
                            ),
                            whiteSpaceW(20.0),
                            (userCheck.userGrade == "DISTRIBUTOR") ? InkWell(
                              onTap: () {
                                if(view != "Agecy"){
                                  setState(() {
                                    view = "Agecy";
                                  });
                                }
                              },
                              child: (view == "Agecy") ?
                              Text("대리점", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),)
                                  :
                              Text("대리점", style: TextStyle(fontSize: 16),),
                            ) : SizedBox()
                          ]
                      ),
                    decoration: BoxDecoration(
                        color: Color(0xffffdd00)
                    ),
                  ),
                  (view == "My") ? myPageForm()
                    : (view == "Store") ? storeForm()
                    : agencyForm(),
                ],
              ),
            ),

          ],
        ),
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
              child:
              CircularProgressIndicator(
                backgroundColor: Color(0xffffdd00),
                valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
              )
          ),
        )
            :
        Column(
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 30.0, left: 12.0, right: 12.0, bottom: 10),
                  decoration: BoxDecoration(
                    color: Color(0xffffdd00),
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
                                      style: TextStyle(fontSize:16, fontWeight: FontWeight.w600, color: Colors.black),
                                      children: [
                                        TextSpan(text:"${user.loginUser.name}", style: TextStyle(fontSize: 25, color: Color(0xff444444))),
                                        TextSpan(text:" 님\n"),
                                        TextSpan(text:"반갑습니다.")
                                      ]
                                  ),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios, size: 24,color: Colors.black,),
                              ]
                          ),
                          whiteSpaceH(40),
                          Row(
                              children: [
                                InkWell(
                                  onTap: (){
                                    Map<String, dynamic> args = {
                                      "point":"RP",
                                      "pointImg":"assets/icon/rp-coin.png"
                                    };
                                    Navigator.of(context).pushNamed("/point/history", arguments: args);
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset("assets/icon/rp-coin.png",height: 24, fit: BoxFit.contain,),
                                      whiteSpaceW(5),
                                      Text("${demicalFormat.format(user.pointMap['RP'])} RP",style: TextStyle(fontSize: 12, color: Color(0xff444444)),),
                                      Icon(Icons.arrow_forward_ios, color: Colors.black, size: 12,),
                                    ],
                                  ),
                                ),
                                whiteSpaceW(20),
                                InkWell(
                                  onTap: (){
                                    Map<String, dynamic> args = {
                                      "point":"DL",
                                      "pointImg":"assets/icon/bza.png"
                                    };
                                    Navigator.of(context).pushNamed("/point/history", arguments: args);
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset("assets/icon/bza.png",height: 24, fit: BoxFit.contain,),
                                      whiteSpaceW(5),
                                      Text("${demicalFormat.format(user.pointMap['DL'])} BZA",style: TextStyle(fontSize: 12, color: Color(0xff444444)),),
                                      Icon(Icons.arrow_forward_ios, color: Colors.black, size: 12,),
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
    return Column(
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
                        Text("총판명  ",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600
                            )),
                        Text("010-0000-0000"),
                      ],
                    ),
                    whiteSpaceH(5),
                    Row(
                      children: [
                        Text("직전대리점명   ",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600
                            )),
                        Text("010-0000-0000"),
                      ],
                    ),
                    whiteSpaceH(10),
                    Row(
                      children: [
                        Text("스토어명   ",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600
                            )),
                        Text("010-0000-0000"),
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
                  Consumer<RecoProvider>(
                  builder: (context, reco, _){
                  return Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child:

                          Padding(
                            padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0, bottom: 5.0),
                            child:Column(
                              children: [
                                Text("ADP 리워드",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff888888),
                                    )),
                                whiteSpaceH(5),
                                Text("${numberFormat.format(reco.adp)} ADP",
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
                          flex: 4,
                          child:
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0, bottom: 5.0),
                            child:Column(
                              children: [
                                Text("현금리워드",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff888888),
                                    )),
                                whiteSpaceH(5),
                                Text("${numberFormat.format(reco.pay)}원",
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
                          flex: 3,
                          child:
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 12.0, right: 12.0, bottom: 15.0),
                            child:Column(
                              children: [
                                Text("대리점 수",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff888888),
                                    )),
                                whiteSpaceH(5),
                                Text("${numberFormat.format(reco.ageAmount)} 개",
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
                          flex: 3,
                          child:
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 12.0, right: 12.0, bottom: 15.0),
                            child:Column(
                              children: [
                                Text("가맹점 수",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff888888),
                                    )),
                                whiteSpaceH(5),
                                Text("${numberFormat.format(reco.franAmount)}개",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xffFF6622),
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
                  child: Opacity(
                    opacity: reco.isLoading ? 1.0 : 0.0,
                    child: CircularProgressIndicator(),
                  ),
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
                      return Center(
                        child: Opacity(
                          opacity: pm.isLoading ? 1.0 : 0.0,
                          child: CircularProgressIndicator(),
                        ),
                      );
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
                  fontWeight: FontWeight.w600,
                  color: Color(0xff888888))),
        ),
        Container(
          padding: const EdgeInsets.only(right:12.0, left:12.0,bottom: 10.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child:Text("ADP",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'noto',
                            fontSize: 16,
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
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffBE1833)))
                  ),
                ),
                Expanded(
                    flex: 2,
                    child:Text("현금",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'noto',
                            fontSize: 16,
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
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff626262)))
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
              color: Colors.white,
            ),
            child: Center(
                child:
                CircularProgressIndicator(
                  backgroundColor: Color(0xffffdd00),
                  valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                )
            ),
          )
              :
          Column(
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0, bottom: 10),
                    decoration: BoxDecoration(
                      color: Color(0xffffdd00),
                    ),
                    child: InkWell(
                      onTap: () async{
                        Navigator.of(context).pushNamed("/store/modify/store");
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
                                            child: Text("${user.storeModel.store.name}\n", style: TextStyle(fontSize: 25, color: Color(0xff444444), fontWeight: FontWeight.w600))
                                          ),
                                          whiteSpaceW(10),
                                          Icon(Icons.arrow_forward_ios, size: 24,color: Colors.black,),
                                        ]
                                      ),
                                      Text("${user.storeModel.store.tel}\n", style: TextStyle(fontSize: 20, color: Color(0xff444444), fontWeight: FontWeight.w600)),
                                    ]
                                  ),
                                  Spacer(),
                                  CachedNetworkImage(
                                    imageUrl: user.storeModel.store.shop_img1,
                                    fit: BoxFit.contain,
                                    width: 70,
                                    height: 70,
                                  ),
                                ]
                            ),
                            whiteSpaceH(40),
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
                                        Text("${demicalFormat.format(user.pointMap['ADP'])} ADP",style: TextStyle(fontSize: 12, color: Color(0xff444444)),),
                                        Icon(Icons.arrow_forward_ios, color: Colors.black, size: 12,),
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
                                QrCard(),
                                HistoryCard(),
                                sellDlCard(),
                                whiteSpaceH(16.0),
                                Tabs(name: "사업자정보 수정", routesName: "/store/modify/business",),
                                CustomerCenter(),
                              ]
                          )
                      ),
                    ]
                )
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
          color: Color(0xffffff),
          border: Border.all(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
//              Image.asset("assets/icon/friends-wt.png", height: 32, fit: BoxFit.contain,),
              Image.asset("assets/icon/recommend.png", height: 42, fit: BoxFit.contain,),
              SizedBox(width: 12,),
              Text("이용내역",style: TextStyle(fontSize: 16,color: Color(0xff444444))),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.black, size: 24,),
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

  Widget QrCard(){
    return InkWell(
      onTap: (){
        dialog(
            title: "QR생성 안내",
            content: "고객의 결제방식을\n확인해주세요.",
            sub: "",
            context: context,
            selectOneText: "일반결제",
            selectTwoText: "DL결제",
            selectOneVoid: () => qrCreate(0),
            selectTwoVoid: () => qrCreate(1)
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffffff),
          border: Border.all(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/resource/map/qr.png", height: 42, fit: BoxFit.contain,),
              SizedBox(width: 12,),
              Text("결제QR 생성",style: TextStyle(fontSize: 16,color: Color(0xff444444))),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.black, size: 24,),
            ],
          ),
        ),
      ),
    );
  }

  Widget sellDlCard(){
    return InkWell(
      onTap: (){

      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffffff),
          border: Border.all(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icon/bza.png", height: 42, fit: BoxFit.contain,),
              SizedBox(width: 12,),
              Text("BZA 판매",style: TextStyle(fontSize: 16,color: Color(0xff444444))),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.black, size: 24,),
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
          color: Color(0xffffff),
          border: Border.all(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
//              Image.asset("assets/icon/friends-wt.png", height: 32, fit: BoxFit.contain,),
              Image.asset("assets/icon/recommend.png", height: 42, fit: BoxFit.contain,),
              SizedBox(width: 12,),
              Text("추천인 관리",style: TextStyle(fontSize: 16,color: Color(0xff444444))),
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
            child: Row(
              children: [
                Text("고객센터",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600, color: Color(0xff444444)),),
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
              )
            ]
          );
        }
    );
  }
}

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
            child: Row(
              children: [
                Text(name,style: TextStyle(fontSize: 14,color: Color(0xff444444)),),
                Spacer(),
                Icon(Icons.arrow_forward_ios, size: 24,color: Colors.black,)
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
        color: Color(0xffeeeeee),
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



