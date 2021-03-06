import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/point.dart';
import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/PointMgmtProvider.dart';
import 'package:cashcook/src/provider/RecoProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/center/recruitment.dart';
import 'package:cashcook/src/screens/mypage/NewStore/BigMenuListPage.dart';
import 'package:cashcook/src/screens/mypage/NewStore/ContentApply.dart';
import 'package:cashcook/src/screens/mypage/NewStore/franApply.dart';
import 'package:cashcook/src/screens/main/home.dart';
import 'package:cashcook/src/screens/mypage/points/integratedPoint.dart';
import 'package:cashcook/src/screens/mypage/points/pointMgmt.dart';
import 'package:cashcook/src/screens/mypage/points/pointMgmtUser.dart';
import 'package:cashcook/src/screens/mypage/store/RefundRequest.dart';
import 'package:cashcook/src/screens/mypage/store/orderList.dart';
import 'package:cashcook/src/screens/qr/qrcreate.dart';
import 'package:cashcook/src/screens/referrermanagement/referrermanagement.dart';
import 'package:cashcook/src/utils/CustomBottomNavBar.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cashcook/src/screens/mypage/info/scrap.dart';
import 'package:cashcook/src/screens/referrermanagement/franBizSelect.dart';
import 'package:cashcook/src/screens/referrermanagement/franBizInfo.dart';

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
  int agencyCheck;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).fetchMyInfo();
    });

  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body(){
    UserCheck userCheck = Provider.of<UserProvider>(context,listen: false).loginUser;

    return
      Scaffold(
          appBar: AppBar(
            backgroundColor: white,
            elevation: 0.0,
            leading: IconButton(
              onPressed: () {
                if(widget.isHome){
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => Home()
                    )
                  , (route) => false);
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
            actions: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          if(view != "My") {
                            await Provider.of<UserProvider>(context, listen:false).fetchMyInfo();
                            setState(() {
                              view = "My";
                            });
                          }
                        },
                        child: (view == "My") ?
                        Text("??????", style: Subtitle2,)
                            :
                        Text("??????", style: Body1,),
                      ),
                      whiteSpaceW(20.0),
                      InkWell(
                        onTap: () async {
                          if(!userCheck.isFran)
                            _showDialog();
                          else {
                            if(view != "Store"){
                              await Provider.of<UserProvider>(context, listen:false).fetchMyInfo();
                              agencyCheck = await Provider.of<UserProvider>(context, listen: false).selectMyAgency();
                              setState(() {
                                view = "Store";
                              });
                            }
                          }
                        },
                        child: (view == "Store") ?
                        Text("???????????????", style: Subtitle2,)
                            :
                        Text("???????????????", style: Body1,),
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
                        Text("???????????????", style: Subtitle2,)
                            :
                        Text("???????????????", style: Body1,),
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
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Provider.of<UserProvider>(context, listen:false).fetchMyInfo(context);
    // });
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
                    valueColor: new AlwaysStoppedAnimation<Color>(primary)
                )
            ),
          )
              :
              SingleChildScrollView(
                child:

                Column(
                    children: [

                      InkWell(
                        onTap: () async {
                          await Navigator.pushNamed(context, "/userState");
                        },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icon/s_maker.png",
                                width: 48,
                                height: 48,
                              ),
                              whiteSpaceW(12),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("${user.loginUser.name} ",
                                        style: Subtitle1.apply(
                                            color: primary,
                                            fontWeightDelta: 2
                                        ),
                                      ),
                                      Text("???",
                                          style: Subtitle1
                                      )
                                    ],
                                  ),
                                  Text("???????????????.",
                                      style: Subtitle1
                                  )
                                ],
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios, size: 16,color: black),
                            ],
                          ),
                        ),
                      ),


          // ?????? ???????????? ??????
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
          child:

          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child:

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
                    child:
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset("assets/icon/c_point.png",height: 24, fit: BoxFit.contain,),
                        whiteSpaceW(5),
                        Text("${demicalFormat.format(user.pointMap['RP'])} CP",style: Body2.apply(color: black),),
                        Icon(Icons.arrow_forward_ios, color: black, size: 12,),
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
                        Text("${demicalFormat.format(user.pointMap['DL'])} DL",style: Body2.apply(color: black),),
                        Icon(Icons.arrow_forward_ios, color: black, size: 12,),
                      ],
                    ),
                  ),

                  whiteSpaceW(20),

                  // ??????
                  InkWell(
                    onTap: (){
                      Map<String, dynamic> args = {
                        "point":"CARAT",
                        "pointImg":"assets/icon/carat.jpg"
                      };
                      Navigator.of(context).pushNamed("/point/history", arguments: args);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset("assets/icon/carat.jpg",height: 24, fit: BoxFit.contain,),
                        whiteSpaceW(5),

                        // Text("${demicalFormat.format(user.pointMap['CARAT'])} CR",style: Body2.apply(color: black),),
                        Text(
                          "${demicalFormat.format(user.pointMap['CARAT'])} CR",style: Body2.apply(color: black),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Icon(Icons.arrow_forward_ios, color: black, size: 12,),
                      ],
                    ),
                  ),

                ]
            ),
          ),
          ),



                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: Color(0xFFDDDDDD)
                      ),
                      Column(
                          children:[
                            SizedBox(height: 24,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  RecoCard(),
                                  easyPayCard(),
                                  scrapCard(),
                                  HistoryCard(),
                                ]
                              )
                            ),
                            SizedBox(height: 24),
                            RecruitCard(),
                            SizedBox(height: 24,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  Tabs(name: "????????????", routesName: "/notice",),
                                  // CustomerCenter(),
                                  Tabs(name: "FAQ", routesName: "/faq",),
                                  Tabs(name: "????????? ??????", routesName: "/inquiry",),
                                  Tabs(name: "?????????", routesName: "/appinfomation",),
                                  Tabs(name: "?????? ??? ??????", routesName: "/terms",),
                                  SizedBox(height: 24,),
                                ],
                              ),
                            ),
                            (!user.loginUser.isFran) ? Tabs2(name: "??????????????? ????????????", routesName: "/store/apply1",img: "assets/icon/shop.png",): SizedBox(),
                            SizedBox(height: 12,),
                            // Tabs2(name: "???????????? ??????", routesName: "cashlink",img: "assets/icon/cashlink-icon.png",),
                            CashTabs(),
                            SizedBox(height: 34),
                            SizedBox(height: 60,),
                          ]
                      )
                    ]
                )
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
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: white,
            ),
            child: Row(
              children: [
                Column (
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        Text("${user.username}",
                            style: Subtitle1.apply(
                              color: primary,
                              fontWeightDelta: 2
                            ),
                          textAlign: TextAlign.start,
                        ),
                        Text("${user.phone.substring(0,3)}-${user.phone.substring(3,7)}-${user.phone.substring(7,11)}",
                            style: Subtitle2.apply(
                              fontWeightDelta: -1
                            )
                        ),
                  ],
                ),
                Spacer(),
                Image.asset(
                  "assets/icon/s_master.png",
                  width: 48,
                  height: 48
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
                  Radius.circular(16),
                ),
                border: Border.all(
                  color: primary,
                  width: 2
                )
              ),
              child:
              Consumer<RecoProvider>(
                  builder: (context, reco, _){
                    return Row(
                        children: [
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child:Column(
                                children: [
                                  Text("????????? ADP ??????",
                                      style: Body2.apply(
                                        color: secondary
                                      )
                                  ),
                                  whiteSpaceH(2),
                                  Text("${numberFormat.format(reco.adp)} ADP",
                                      style: Body1.apply(
                                        color: black,
                                        fontWeightDelta: 3
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width:1,
                            height: 24,
                            color: deActivatedGrey
                          ),
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child:Column(
                                children: [
                                  Text("?????? ?????????",
                                      style: Body2.apply(
                                          color: secondary
                                      )
                                  ),
                                  whiteSpaceH(2),
                                  Text("${numberFormat.format(reco.pay)}???",
                                      style: Body1.apply(
                                          color: black,
                                          fontWeightDelta: 3
                                      )
                                  ),
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
          whiteSpaceH(8),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xFFF2F2F2),
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),

              ),
              child:
              Consumer<RecoProvider>(
                  builder: (context, reco, _){
                    return Row(
                        children: [
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                              child: Row(
                                children: [
                                  Text("??????????????? ???",
                                      style: Body2.apply(
                                          color: secondary
                                      )
                                  ),
                                  Spacer(),
                                  Text("${user.userGrade == "DISTRIBUTOR" ? numberFormat.format(reco.ageAmount) : 0} ???",
                                      style: Body1.apply(
                                          color: black,
                                          fontWeightDelta: 3
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 10,
                            color: deActivatedGrey
                          ),
                          Expanded(
                            child:
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                              child:Row(
                                children: [
                                  Text("????????? ???",
                                      style: Body2.apply(
                                          color: secondary
                                      )
                                  ),
                                  Spacer(),
                                  Text("${user.userGrade == "DISTRIBUTOR" ? numberFormat.format(reco.franAmount) : numberFormat.format(reco.ageAmount)}???",
                                      style: Body1.apply(
                                          color: black,
                                          fontWeightDelta: 3
                                      )
                                  ),
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
          whiteSpaceH(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  height: 40,
                  child: Row (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap:() {
                              setState(() {
                                ageView = "History";
                              });
                            },
                            child: (ageView == "History") ?
                            Text("???????????????/??????????????? ??????", style: Body1.apply(
                                color: black,
                                fontWeightDelta: 1
                            ),
                              textAlign: TextAlign.center,
                            )
                                :
                            Text("???????????????/??????????????? ??????", style: Body1.apply(
                                color:  third
                            ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap:() {
                              setState(() {
                                ageView = "Reward";
                                viewType = "month";
                              });
                            },
                            child: (ageView == "Reward") ?
                            Text("????????? ??????", style: Body1.apply(
                                color: black,
                                fontWeightDelta: 1
                            ),
                              textAlign: TextAlign.center,
                            )
                                :
                            Text("????????? ??????", style: Body1.apply(
                                color:  third
                            ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ]
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: third,
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        left: ageView == "History" ? 0 : MediaQuery.of(context).size.width / 2,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 3,
                          decoration: BoxDecoration(
                              color: primary,
                          ),
                        ),
                        duration: Duration(milliseconds: 400),
                      )
                    ],
                  ),
                )
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
        return Column(
          children: reco.gradeReferrer.map((e) =>
            RecoItem(e)
          ).toList(),
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
                    style: Body1.apply(
                      fontWeightDelta: 1
                    )
                  ),
                  Text(
                    (data.type == 1) ? " (???????????????)" : " (???????????????)",
                    style: Body1.apply(
                      color: (data.type == 1) ? primary : etcYellow,
                      fontWeightDelta: 1
                    )
                  ),
                ]
            ),
            Text(
              "${data.phone.toString().substring(0,3)}-${data.phone.toString().substring(3,7)}-${data.phone.toString().substring(7,11)}",
              style: Body2,
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
                  "????????????",
                  style: Body2.apply(
                    color: primary,
                    decoration: TextDecoration.underline
                  ),
                )
            ),
            data.type == 1
                ? Text(
              "By " + data.byName,
              style: Body2,
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
                          elevation: 0.0,
                          color: white,
                          disabledColor: white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(color: (viewType == "month") ? primary : third)
                          ),
                          child:
                          Text(
                            "??????",
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
                          color: white,
                          elevation: 0.0,
                          disabledColor: white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(color: (viewType == "year") ? primary : third)
                          ),
                          child:
                          Text(
                            "??????",
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
          child: Text("${data.base_mday} ${(viewType == "month") ? "???" : "???"}",
              style: Body2
          ),
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
                        style:
                            Subtitle1
                    )
                ),
                Expanded(
                  flex: 4,
                  child:Container(
                      child:
                      Text(" ${numberFormat.format(double.parse(data.base_amount))} ADP",
                          overflow: TextOverflow.ellipsis,
                          style: Subtitle1.apply(
                            color: primary
                          )
                      ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child:Text("??????",
                        overflow: TextOverflow.ellipsis,
                        style: Subtitle1
                    )
                ),
                Expanded(
                  flex: 4,
                  child:Container(
                      child:
                      Text(" ${numberFormat.format(double.parse(data.sub_amount))} ???",
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

  Widget storeForm(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<UserProvider>(context, listen:false).fetchMyInfo();
      agencyCheck = await Provider.of<UserProvider>(context, listen: false).selectMyAgency();

      print("???????????? ?????? ===> $agencyCheck");
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
                    valueColor: new AlwaysStoppedAnimation<Color>(primary)
                )
            ),
          )
              :
          Column(
              children: [
              InkWell(
                onTap: () async{
                  await Navigator.of(context).pushNamed("/store/modify/routes");
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(6)
                            ),
                            border: Border.all(
                                color: Color(0xFFDDDDDD),
                                width: 0.5
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                user.storeModel.store.shop_img1,
                              ),
                            )
                        ),
                      ),
                      whiteSpaceW(12.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${user.storeModel.store.name}",
                              style: Subtitle1.apply(
                                  color: primary,
                                  fontWeightDelta: 1
                              )
                          ),
                          Text("${user.storeModel.store.tel}",
                              style: Subtitle2.apply(
                                  fontWeightDelta: -1
                              )),
                        ],
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 16, color: black,)
                    ],
                  ),
                ),
              ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  child: Row(
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
                              Text("${demicalFormat.format(user.pointMap['ADP'])} ADP",style: Body2.apply(color: black),),
                              Icon(Icons.arrow_forward_ios, color: black, size: 12,),
                            ],
                          ),
                        ),
                      ]
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color : Color(0xFFDDDDDD)
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
                                  agencyCheck == 1 ? BizInfo() : BizSelect(),
                                  QrCard(),
                                  // RefundCard(),
                                  FranHistoryCard(),
                                  FranOrderCard(),
                                  // ContentApplyCard(),
                                  // MenuApplyCard(),
                                  sellDlCard(),
                                  whiteSpaceH(24.0),
                                  Tabs(name: "????????? ?????? ??????", routesName: "/store/modify/business",),
                                  // RaisedButton(
                                  //   onPressed: () {
                                  //     Navigator.of(context).push(MaterialPageRoute(
                                  //       builder: (context) => FranApply()
                                  //     ));
                                  //   },
                                  //   child: Text("???????????? ?????? ?????????"),
                                  // ),
                                  Tabs(name: "??????????????? ?????? ??????", routesName: "/store/modify/routes",),
                                  Tabs(name: "DL ?????? ?????? ??????", routesName: "/store/modify/limitDL",),
                                  whiteSpaceH(70.0),
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

  //???????????? ??????
  Widget ContentApplyCard() {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ContentApply(
              storeId: Provider.of<UserProvider>(context, listen:false).storeModel.id,
              comment: Provider.of<UserProvider>(context, listen:false).storeModel.store.comment,
            )
        ));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icon/list_color.png", width: 24,height: 24, fit: BoxFit.fill, color: primary),
              SizedBox(width: 12,),
              Text("???????????? ??????",style: Subtitle2),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Color(0xff444444), size: 16,),
            ],
          ),
        ),
      ),
    );
  }

  //?????? ??????
  Widget MenuApplyCard() {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BigMenuListPage(
              store_id: Provider.of<UserProvider>(context, listen:false).storeModel.id,
            )
        ));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icon/list_color.png", width: 24,height: 24, fit: BoxFit.fill, color: primary),
              SizedBox(width: 12,),
              Text("?????? ??????",style: Subtitle2),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Color(0xff444444), size: 16,),
            ],
          ),
        ),
      ),
    );
  }

  //?????? ??????
  Widget HistoryCard(){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => pointMgmtUser()
        ));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icon/list_color.png", width: 24,height: 24, fit: BoxFit.fill, color: primary),
              SizedBox(width: 12,),
              Text("????????????",style: Subtitle2),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Color(0xff444444), size: 16,),
            ],
          ),
        ),
      ),
    );
  }

  Widget FranOrderCard() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          // builder: (context) => pointMgmt()
            builder: (context) => OrderList()
        ));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icon/market.png", width: 24,
                height: 24,
                fit: BoxFit.fill,),
              SizedBox(width: 12,),
              Text("??????????????????", style: Subtitle2),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios, color: Color(0xff444444), size: 16,),
            ],
          ),
        ),
      ),
    );
  }

  Widget FranHistoryCard(){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => pointMgmt()
        ));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icon/market.png", width: 24,height: 24, fit: BoxFit.fill,),
              SizedBox(width: 12,),
              Text("?????? ??????",style: Subtitle2),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Color(0xff444444), size: 16,),
            ],
          ),
        ),
      ),
    );
  }

  //?????? ?????????
  qrCreate(type) {

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
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icon/pay.png", width: 24, height: 24, fit: BoxFit.fill,),
              SizedBox(width: 12,),
              Text("???????????? ??????",style: Subtitle2),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Color(0xff444444), size: 16,),
            ],
          ),
        ),
      ),
    );
  }

  Widget BizSelect(){
    return InkWell(
      onTap: () async{
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => FranBizSelect()));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icon/s_master.png", width: 24, height: 24, fit: BoxFit.fill,),
              SizedBox(width: 12,),
              Text("??????????????? ??????",style: Subtitle2),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Color(0xff444444), size: 16,),
            ],
          ),
        ),
      ),
    );
  }

  Widget BizInfo(){
    return InkWell(
      onTap: () async{
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => FranBizInfo()));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icon/s_master.png", width: 24, height: 24, fit: BoxFit.fill,),
              SizedBox(width: 12,),
              Text("??????????????? ??????",style: Subtitle2),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Color(0xff444444), size: 16,),
            ],
          ),
        ),
      ),
    );
  }

  Widget RefundCard(){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RefundRequest()
        ));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icon/friends.png", width: 24,height: 24, fit: BoxFit.fill,),
              SizedBox(width: 12,),
              Text("????????????",style: Subtitle2),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Color(0xff444444), size: 16,),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget QrCard(){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => QrCreate()
        ));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icon/qr_create.png", width: 24, height: 24, fit: BoxFit.fill,),
              SizedBox(width: 12,),
              Text("QR?????? ??????",style: Subtitle2),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Color(0xff444444), size: 16,),
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
            title: Text("??????"),
            content: Text("????????? ??????????????????."),
          );
        });
  }

  Widget RecruitCard() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Recruitment()
        ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Color(0xFFFFEdE5)
        ),
        child: Row(
          children: [
            Expanded(
              child: Text.rich(
                  TextSpan(
                      style: TextStyle(
                          fontSize: 18,
                          color: primary
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: "????????? ?????? ",
                            style: TextStyle(
                                fontWeight: FontWeight.w300
                            )
                        ),
                        TextSpan(
                            text: "????????????",
                            style: TextStyle(
                                fontWeight: FontWeight.w700
                            )
                        )
                      ]
                  )
              ),
            ),
            Image.asset(
              "assets/resource/main/recruit_logo.png",
              width: 75.2,
              height: 80,
              alignment: Alignment.bottomRight,
            )
          ],
        )
      )
    );
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icon/sell.png", width: 24,height: 24, fit: BoxFit.fill,),
              SizedBox(width: 12,),
              Text("DL ??????",style: Subtitle2),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Color(0xff444444), size:16,),
            ],
          ),
        ),
      ),
    );
  }

  //????????? ??????
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
//              Image.asset("assets/icon/friends-wt.png", height: 32, fit: BoxFit.contain,),
              Image.asset("assets/icon/friends.png", width: 28,height: 28, fit: BoxFit.fill,),
              SizedBox(width: 12,),
              Text("???????????? ??????",style: Subtitle2),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16,),
            ],
          ),
        ),
      ),
    );
  }

  //????????? ??????
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/icon/steam-color2.png", width: 24,height: 24, fit: BoxFit.fill, color: primary),
              SizedBox(width: 12,),
              Text("?????? ???????????????",style: Subtitle2),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16,),
            ],
          ),
        ),
      ),
    );
  }

  //?????? ???
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
            Text("??????", style: Body1,),
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

  //????????????
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
            Text("????????????",style: Body1,),
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
              title: Text("?????? ??????????????? ????????? ???????????????!\n??????????????? ????????? ?????????,\n???????????? ????????? ????????? ???????????????!",
                style: Subtitle2,),
              actions: <Widget>[
                FlatButton(
                    child: new Text("???"),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed("/store/apply1");
                    }
                ),
                FlatButton(
                    child: new Text("?????????"),
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
            Text("DL ?????? ?????? ??????",style: TextStyle(fontSize: 14,color: Color(0xff444444)),),
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
            Text(name,style: Subtitle2.apply(fontWeightDelta: -1),),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xff444444),)
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
            Text(name,style: Body1,),
            Spacer(),
            Image.asset(img,width: 48, fit: BoxFit.contain,),
          ],
        ),
      ),
    );
  }
}

class CashTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: InkWell(
        onTap: () async{
            await launch("http://cashlink.kr");
        },
        child: Row(
          children: [
            Image.asset("assets/icon/to-cashlink.png",width: 36, height: 36, fit: BoxFit.fill,),
            whiteSpaceW(12),
            Text("???????????? ??????",style: Subtitle2.apply(fontWeightDelta: -1),),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16,),
          ],
        ),
      ),
    );
  }
}



