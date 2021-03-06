import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/place.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/model/store/reviewWrite.dart';
import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/main/search.dart';
import 'package:cashcook/src/screens/main/storeDetail_3.dart';
import 'package:cashcook/src/screens/mypage/points/pointMgmt.dart';
import 'package:cashcook/src/screens/qr/qr.dart';
import 'package:cashcook/src/services/Search.dart';
import 'package:cashcook/src/utils/Share.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/utils/customSlidePop.dart' as slideDialog;
import 'package:url_launcher/url_launcher.dart';

import 'home.dart';

class MainMap extends StatefulWidget {
  double lat;
  double lon;

  MainMap({this.lat, this.lon});

  @override
  _MainMap createState() => _MainMap();
}

class _MainMap extends State<MainMap> {
  TextEditingController searchCtrl = TextEditingController();

  AppBar appBar;

  // Map Control Variable
  var currentLocation;
  Location location = Location();
  CameraPosition cameraPosition;
  GoogleMapController googleMapController;
  bool mapLoad = false;

  // Search Service Variable
  SearchService searchService = SearchService();
  PlaceDetail placeDetail;

  // DetailView Control Variable
  double scope = 4.4;
  Map<String, int> pointMap;
  UserCheck my;
  bool detailView = false;
  int selStore = 0;

  // Pop Scope Controll
  String loadCompleteUrl;
  DateTime currentBackPressTime;

  @override
  void initState(){
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<UserProvider>(context,listen: false).fetchMyInfo();

      my = Provider.of<UserProvider>(context, listen: false).loginUser;
      pointMap = Provider.of<UserProvider>(context, listen: false).pointMap;
    });

    return
      Consumer<StoreProvider>(
        builder: (context, sp, _) {
          return Scaffold(
          backgroundColor: white,
          resizeToAvoidBottomInset: true,
          appBar: sp.isCurrentPage != 2 ? AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => Home()
                  )
                , (route) => false);
              },
              icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24, color: black,),
            ),
          backgroundColor: white,
          elevation: 0.5,
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: InkWell(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => Home()
                )
              , (route) => false);
            },
            child: Image.asset(
              "assets/icon/cashcook_logo.png",
              width: 116,
              height: 30,
            ),
          ),
      ) : Container(),
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
                color: white,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom -
                            53,
                        child: getChild(),
                      ),
                    ),
                    sp.detailView
                        ? Positioned(
                      bottom: my.id.toString() == sp.selStore.user_id ? 230 + (sp.position * 2) : 143 + (sp.position * 2),
                      right: 10,
                      child: Container(
                        width: 180,
                        height: 40,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "??? ??????????????? ??????",
                              style: Body2,
                            ),
                            whiteSpaceW(8),
                            Text(
                              "${sp.distance.toStringAsFixed(1)}km",
                              style: Body1.apply(
                                color: primary,
                                fontWeightDelta: -1
                              )
                            ),
                          ],
                        ),
                      ),
                    )
                        : Container(),
                    sp.detailView
                        ?
                    Positioned(
                        bottom: sp.position,
                        child: GestureDetector(
                          onPanUpdate: (details) async {
                            if(details.delta.dy > 0) {
                              await sp.hideDetailView();
                            } else {
                              if (!Provider.of<StoreServiceProvider>(context,listen: false).isMenuLoading) {
                                await Provider.of<StoreServiceProvider>(
                                    context, listen: false).setServiceNum(
                                    0, sp.selStore.id);
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => StoreDetail3(
                                          store: sp.selStore,
                                        )
                                    )
                                );
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(builder:
                                //   (context) => StoreDetail(
                                //     store: sp.selStore,
                                //   )
                                //   )
                                // );
                                //storeDetailDialog();
                              }
                            }
                          },
                          onPanEnd: (details) async {
                            await sp.backPosition();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0)
                                )
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: my.id.toString() == sp.selStore.user_id? 223 + (sp.position * 2) : 136 + (sp.position * 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if(!Provider.of<StoreServiceProvider>(context, listen: false).isLoading){
                                      await Provider.of<StoreServiceProvider>(context, listen: false).setServiceNum(0, sp.selStore.id);
                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(builder:
                                      //         (context) => StoreDetail(
                                      //       store: sp.selStore,
                                      //     )
                                      //     )
                                      // );
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => StoreDetail3(
                                                store: sp.selStore,
                                              )
                                          )
                                      );
                                      // storeDetailDialog();
                                      // Provider.of<StoreServiceProvider>(context, listen: false).showView();
                                    }
                                  },
                                  child:
                                  Container(
                                    decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0)
                                        )
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: 136,
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            showBigImage(sp.selStore.store.shop_img1);
                                          },
                                          child:
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
                                                    sp.selStore.store.shop_img1,
                                                  ),
                                                )
                                            ),
                                          ),
                                        ),
                                        whiteSpaceW(12),
                                        Expanded(
                                          child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      sp.selStore.store.name,
                                                      style: Body1,
                                                    ),
                                                    whiteSpaceW(20),
                                                    Text(
                                                      "${sp.selStore.store.category_name} / ${sp.selStore.store.category_sub_name}",
                                                      style: Body2.apply(
                                                        color: primary
                                                      )
                                                    )
                                                  ],
                                                ),
                                                whiteSpaceH(5),
                                                Text(
                                                  sp.selStore.address.address,
                                                  style: Body2,
                                                ),
                                                whiteSpaceH(12),
                                                my.id.toString() == sp.selStore.user_id ?
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Image.asset("assets/icon/adp.png",height: 30, fit: BoxFit.contain,),
                                                    Text(
                                                      "  ${pointMap['ADP'] == null ? demicalFormat.format(0)
                                                          : demicalFormat.format(pointMap['ADP'])}",
                                                      style: Body2.apply(
                                                        color: black,
                                                        fontWeightDelta: 3
                                                      ),
                                                    ),
                                                    whiteSpaceW(12),
                                                    Image.asset("assets/icon/DL 2.png",height: 30, fit: BoxFit.contain,),
                                                    Text(
                                                      "  ${demicalFormat.format(pointMap['DL'])}",
                                                      style: Body2.apply(
                                                        fontWeightDelta: 1,
                                                        color: black
                                                      )
                                                      // style: TextStyle(
                                                      //     fontFamily: 'noto',
                                                      //     color: black,
                                                      //     fontWeight: FontWeight.bold,
                                                      //     fontSize: 12),
                                                    )
                                                  ],
                                                ) : Row(),
                                              ]
                                          ),
                                        ),
                                        whiteSpaceW(6),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => Qr(),
                                                  settings: RouteSettings(
                                                      arguments: {
                                                        "store_id": sp.selStore.id,
                                                        "store_name" : sp.selStore.store.name
                                                      }
                                                  )),);
                                          },
                                          child: Image.asset(
                                            "assets/icon/qr_scan.png",
                                            width: 24,
                                            height: 24,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ),
                                my.id.toString() == sp.selStore.user_id ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 80,
                                  color: white,
                                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                                  child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                          child: Container(
                                            child:RaisedButton(
                                                color: white,
                                                onPressed: () async {
                                                  await Navigator.of(context).pushNamed("/store/modify/routes");
                                                  googleMapController
                                                      .getVisibleRegion()
                                                      .then((value) async {
                                                    String start = value.northeast.latitude.toString() +
                                                        "," +
                                                        value.northeast.longitude.toString();
                                                    String end = value.southwest.latitude.toString() +
                                                        "," +
                                                        value.southwest.longitude.toString();

                                                    print("????????? ?????? ???????????????");
                                                    await sp.getStore(start, end, my.id);
                                                  });
                                                },
                                                elevation: 0.0,
                                                child: Center(
                                                  child: Text(
                                                    "??????????????? ??????/??????",
                                                    style: Body1
                                                  ),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    side: BorderSide(color: Color(0xFFDDDDDD))
                                                )
                                            ),
                                          )

                                      ),
                                      whiteSpaceW(5),
                                      Expanded(
                                        child:
                                        Container(
                                          child: RaisedButton(
                                              color: white,
                                              onPressed: () {
                                                Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) => pointMgmt()
                                                ));
                                              },
                                              elevation: 0.0,
                                              child: Center(
                                                child: Text(
                                                  "????????????",
                                                  style: Body1,
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  side: BorderSide(color: Color(0xFFDDDDDD))
                                              )
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ) : Container(),
                              ],
                            ),
                          ),
                        )
                    )
                        : Container(),
                  ],
                ),
              ),
      );
        }
      );
  }

  // ????????? ?????? ??????
  Future<bool> onWillPop() {
    if(loadCompleteUrl == null){
      DateTime now = DateTime.now();
      if(currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)){
        currentBackPressTime = now;
        showToast("?????? ??? ????????? ?????????????????? ???????????????.");


        return Future.value(false);
      }
      return Future.value(true);
    }
  }


  Widget menuForm() {
    int bigIdx = 0;
    return Consumer<StoreServiceProvider>(
      builder: (context, ss, __) {
        return
            Container(
                width: MediaQuery.of(context).size.width,
                child:
                Column(
                    children:
                      ss.menuList.map((e) =>
                        BigMenuItem(bigIdx++,e)
                      ).toList()

                )
          );
      }
    );
  }

  Widget BigMenuItem(int bigIdx,BigMenuModel bmm){
    int idx = 0;
    return Container(
        width: MediaQuery.of(context).size.width,
        child:
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 10.0),
                  child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bmm.name,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'noto',
                              color: Color(0xFF444444),
                              fontWeight: FontWeight.w600
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ]
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20.0,bottom: 10.0),
                  child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      bmm.menuList.map((e) =>
                          MenuItem(bigIdx,idx++,e)
                      ).toList()
                  )
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height:  1,
                    color: Color(0xFFEEEEEE)
                ),
              ]
            )
    );
  }

  Widget MenuItem(int bigIdx,int idx,MenuModel mm) {
    StoreServiceProvider ssp = Provider.of<StoreServiceProvider>(context, listen: false);
    return Row(
        children: [
          Expanded(
            flex: 1,
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: mainColor,
              checkColor: mainColor,
              value: mm.isCheck,
              onChanged: (value) {
                ssp.setCheck(bigIdx,idx, value);
              },
            ),
          ),
          Expanded(
              flex: 3,
              child: Text("${mm.name}",
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'noto',
                      color: Color(0xFF444444)
                  )
              )
          ),
          Expanded(
              flex: 2,
              child: Text("${numberFormat.format(mm.price)} ???",
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Color(0xFF444444),
                      fontSize: 14,
                      fontFamily: 'noto'
                  ),
                  textAlign: TextAlign.end,
              )
          )
        ]
    );
  }

  Widget reviewForm() {
    StoreProvider sp = Provider.of<StoreProvider>(context, listen: false);
    return Consumer<StoreServiceProvider>(
        builder: (context, ss, __){
          return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
              ),
              child: SingleChildScrollView(
                child: Center(
                  child:Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child:Stack(
                              children: [
                                Positioned(
                                    top:0,
                                    right: 0,
                                    child: RaisedButton(
                                        color: mainColor,
                                        onPressed: () async {
                                          await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => ReviewWrite(
                                                    store_id: sp.selStore.id,
                                                  )));
                                          ss.setServiceNum(1, sp.selStore.id);
                                        },
                                        child: Text("????????????",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'noto',
                                              color: white,
                                            ))
                                    )
                                ),
                                Column(
                                    children:[
                                      Text("?????? ??? ??????",
                                          style: TextStyle(
                                              fontFamily: 'noto',
                                              fontSize: 12,
                                              color: mainColor,
                                              fontWeight: FontWeight.w600
                                          )),
                                      Text("${NumberFormat("#.#").format(ss.reviewAvg)}",
                                          style: TextStyle(
                                              fontFamily: 'noto',
                                              fontSize: 40,
                                              color: mainColor,
                                              fontWeight: FontWeight.w600
                                          )),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            starImage(ss.reviewAvg,1),
                                            starImage(ss.reviewAvg,2),
                                            starImage(ss.reviewAvg,3),
                                            starImage(ss.reviewAvg,4),
                                            starImage(ss.reviewAvg,5),
                                          ]
                                      ),
                                    ]
                                )
                              ]
                          )
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height:12,
                            color: Color(0xFFEEEEEE)
                        ),
                        (ss.isLoading) ?
                        Container(
                            padding: EdgeInsets.all(10),
                            child:Center(
                                child: CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
                                )
                            )
                        )
                        :
                        (ss.reviewList.length == 0) ?
                        Container(
                            padding: EdgeInsets.all(20),
                            child:Column(
                              children:[
                                Text("????????? ????????????.",
                                  style: TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: 16,
                                    fontFamily: 'noto',
                                  )
                                ),
                                whiteSpaceH(10),
                                RaisedButton(
                                    color: mainColor,
                                    onPressed: () async {
                                      await Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => ReviewWrite(
                                                store_id: sp.selStore.id,
                                              )));
                                      ss.setServiceNum(1, sp.selStore.id);
                                    },
                                    child: Text("??? ????????? ??????????????????!",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'noto',
                                          color: white,
                                        ))
                                )
                              ]
                            )
                        )
                        :
                          Container(
                            padding: EdgeInsets.all(10),
                            child:ListView.builder(
                              shrinkWrap: true,
                              itemCount: ss.reviewList.length,
                              itemBuilder: (context, idx) {
                                return reviewListItem(idx,ss.reviewList[idx]);
                              },
                              physics: NeverScrollableScrollPhysics(),
                            )
                          )
                      ]
                  )
                )
              )
          );
        }
    );
  }

  Widget reviewListItem(idx,review) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child:
        Column(
            children: [
              Row(
                  children: [
                    Text("${review.username}",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'noto',
                            fontWeight: FontWeight.w600
                        )),
                    whiteSpaceW(15),
                    Text("${review.date.split("T").first}",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'noto',
                            color: Color(0xFF888888)
                        )),
                    Spacer(),
                    Image.asset(
                      "assets/icon/review/star_full_color.png",
                      width: 14,
                      height: 14,
                    ),
                    Text("${review.scope}",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'noto',
                            color: Color(0xFF888888)
                        ))
                  ]),
              whiteSpaceH(5),
              Container(
                  width: MediaQuery.of(context).size.width,
                  child:Text(
                      "${review.contents}",
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'noto',
                          color: Color(0xFF888888)
                      )
                  )
              ),
              whiteSpaceH(8),
              Row(
                  children: [
                    likeImage(idx,review.id,review.isLike),
                    whiteSpaceW(10),
                    Text(
                        "${review.like}",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'noto',
                            color: Color(0xFF888888)
                        )
                    ),
                    whiteSpaceW(20),
                    hateImage(idx,review.id, review.isHate),
                    whiteSpaceW(10),
                    Text(
                        "${review.hate}",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'noto',
                            color: Color(0xFF888888)
                        )
                    )
                  ]
              ),
              whiteSpaceH(15)
            ]
        )
    );
  }

  Widget hateImage(idx,review_id,isHate) {
    print(review_id);
    return (isHate == 0) ?
        InkWell(
          onTap: () async {
            print("????????? ????????? ??????");
            await Provider.of<StoreServiceProvider>(context, listen:false).patchReview(idx,review_id, "hate", "inc");
          },
          child:Image.asset(
            "assets/icon/dislike_grey.png",
            width: 18,
            height: 18,
          )
        )
        :
    InkWell(
        onTap: () async {
          print("????????? ???????????? ??????");
          await Provider.of<StoreServiceProvider>(context, listen:false).patchReview(idx,review_id, "hate", "dec");
        },
        child:Image.asset(
          "assets/icon/hate_color.png",
          width: 18,
          height: 18,
          color: mainColor
        )
    );
  }

  Widget likeImage(idx,review_id,isLike) {
    print(review_id);
    return (isLike == 0) ?
    InkWell(
        onTap: () async {
          print("????????? ????????? ??????");
          await Provider.of<StoreServiceProvider>(context, listen:false).patchReview(idx,review_id, "like", "inc");
        },
        child:Image.asset(
          "assets/icon/like_grey.png",
          width: 18,
          height: 18,
        )
    )
        :
    InkWell(
        onTap: () async {
          print("????????? ???????????? ??????");
          await Provider.of<StoreServiceProvider>(context, listen:false).patchReview(idx,review_id, "like", "dec");
        },
        child:Image.asset(
          "assets/icon/like_color.png",
          width: 18,
          height: 18,
          color: mainColor,
        )
    );
  }

  Widget starImage(avg,idx) {
    return (avg >= idx) ?
      Image.asset(
        "assets/icon/star_full_color.png",
        width: 14,
        height: 14,
      )
          :
      Image.asset(
        "assets/icon/star_color.png",
        width: 14,
        height: 14,
      );
  }

  Widget otherForm() {
    StoreProvider sp = Provider.of<StoreProvider>(context, listen: false);
    return Consumer<StoreServiceProvider>(
        builder: (context, ss, __){
          return Container(
            padding: EdgeInsets.all(15.0),
              width: MediaQuery.of(context).size.width,
              child: Text(
                  sp.selStore.store.comment,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF888888),
                  fontFamily: 'noto'
                )
              )
          );
        }
    );
  }

  // Map Control Function
  Widget getChild() {
      return
        Consumer<StoreProvider>(
          builder: (context, sp, _){
            return         Stack(
              children: [
            mapLoad
            ? Positioned.fill(

            child: GoogleMap(
              initialCameraPosition: cameraPosition,
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              rotateGesturesEnabled: false,
              markers: sp.markers,
              onCameraIdle: () {
                googleMapController
                    .getVisibleRegion()
                    .then((value) async {
                  String start = value.northeast.latitude.toString() +
                      "," +
                      value.northeast.longitude.toString();
                  String end = value.southwest.latitude.toString() +
                      "," +
                      value.southwest.longitude.toString();

                  await sp.getStore(start, end, Provider.of<UserProvider>(context, listen: false).loginUser.id);
                });
              },
              onMapCreated: (GoogleMapController controller) {
                print("?????????");
                /*controller
                    .getVisibleRegion()
                    .then((value) async {
                  String start = value.northeast.latitude.toString() +
                      "," +
                      value.northeast.longitude.toString();
                  String end = value.southwest.latitude.toString() +
                      "," +
                      value.southwest.longitude.toString();

                  await sp.getStore(start, end, my.id);


                });*/
                setState(() {
                  googleMapController = controller;
                });
              },
            ),
            )
                : Positioned(
            child: SizedBox(),
            ),
            Positioned(
            left: 0,
            right: 0,
            top: 16,
            child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: RaisedButton(
              onPressed: () async {
                final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage()));

                if(result != null)
                  moveCamera(result['lat'], result['lng']);
              },
              color: white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/resource/main/search_blue.png",
                  width: 24,
                  height: 24,
                  color: mainColor,
                ),
                Text("??????",
                    style: TextStyle(
                        color: Color(0xFF444444),
                        fontSize: 16,
                        fontFamily: 'noto',
                        fontWeight: FontWeight.w600
                    ))
              ]
              ),
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            )
            ),
            ),
            ),
            Positioned(
            top: 0,
            right: 0,
            child: Align(
            alignment: Alignment.topRight,
            child: Padding(
            padding: EdgeInsets.only(right: 16, top: 72),
            child: Container(
            width: 40,
            height: 40,
            child: ClipOval(
            child: RaisedButton(
            color: white,
            onPressed: () {
            setMyLocation();
            },
            elevation: 0.0,
            padding: EdgeInsets.zero,
            child: Center(
            child: Image.asset(
            "assets/resource/map/myplace.png",
            fit: BoxFit.cover,
            width: 24,
            height: 24,
            ),
            ),
            ),
            ),
            ),
            ),
            ),
            ),
            ]
            );
          }
        );
  }

  moveCamera(lat, lng) async {
    googleMapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(lat, lng),
      ),
    );
  }

  getLocation() async {
    currentLocation = await location.getLocation();
    if((widget.lat != null && widget.lat != 0.0) && (widget.lon != null && widget.lon != 0.0)){
      cameraPosition = CameraPosition(
          target: LatLng(widget.lat, widget.lon),
          zoom: 14);
    } else {
      cameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 14);
    }

    setState(() {
      mapLoad = true;
    });
  }

  setMyLocation() async {
    currentLocation = await location.getLocation();
    googleMapController.animateCamera(CameraUpdate.newLatLng(
        LatLng(currentLocation.latitude, currentLocation.longitude)));
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

  showBigImage(String img) {
    showDialog(
      context: context,
      builder: (context){
        return
          Stack(
            children: [
              Opacity(
                  opacity: 0.4,
                  child: Scaffold(
                      body: InkWell(
                        onTap: () {
                          Navigator.pop(context,true);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: Color(0xFFEEEEEE),
                        ),
                      )
                  )
              ),
              Positioned.fill(
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 100.0, horizontal: 32.0),
                    child:
                    CachedNetworkImage(
                      imageUrl: img,
                      imageBuilder: (context, img) => Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              image: DecorationImage(
                                  image: img, fit: BoxFit.fill
                              )
                          )
                      ),
                    ),
              )
              ),
            ],
          );
      }
    );
  }
}