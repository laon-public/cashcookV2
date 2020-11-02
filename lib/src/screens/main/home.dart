import 'package:cashcook/src/model/store/review.dart';
import 'package:cashcook/src/provider/provider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/provider/provider.dart';
import 'package:cashcook/src/model/usercheck.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart' as P;
import 'dart:async';
import 'package:location/location.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/services/StoreService.dart';


class Home extends StatefulWidget {

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  String initialUrl = "";
  int viewPage = 0;
  UserCheck my;
  StoreProvider sp = null;
  StoreServiceProvider ssp;
  GoogleMapController googleMapController;
  CameraPosition cameraPosition;
  var currentLocation;
  Location location = Location();
  bool mapLoad = false;
  String start;
  String end;

  List<String> serviceName = [
    '음식',
    '패션',
    '여행',
    '문화',
    '키즈',
    '가전',
    '건강',
    '레저',
    '애완',
    '기타'
  ];

  List<String> serviceImage = [
    'assets/resource/category/category01.png',
    'assets/resource/category/category02.png',
    'assets/resource/category/category03.png',
    'assets/resource/category/category04.png',
    'assets/resource/category/category05.png',
    'assets/resource/category/category06.png',
    'assets/resource/category/category07.png',
    'assets/resource/category/category08.png',
    'assets/resource/category/category09.png',
    'assets/resource/category/category10.png',
  ];

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  getLocation() async {
    print("1");
    currentLocation = await location.getLocation();
      cameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 14);
    print("getLocation");
    print(cameraPosition);
    setState(() {
      mapLoad = true;
        sp = P.Provider.of<StoreProvider>(context, listen: false);
        ssp = P.Provider.of<StoreServiceProvider>(context, listen: false);
    });


  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await P.Provider.of<UserProvider>(context,listen: false).fetchMyInfo(context);

      my = P.Provider.of<UserProvider>(context, listen: false).loginUser;
      await P.Provider.of<StoreServiceProvider>(context, listen: false).reviewListSelect();
      // sp = P.Provider.of<StoreProvider>(context, listen: false);
      // ssp = P.Provider.of<StoreServiceProvider>(context, listen: false);
    });
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
          child: Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              elevation: 0.5,
              centerTitle: false,
              title: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                child: Image.asset(
                  "assets/icon/cashcook_logo.png",
                  width: 108,
                  height: 32,
                ),
              ),
              actions: [
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: DropdownButton(
                    icon: Icon(Icons.arrow_drop_down, color: Color(0xFF333333),),
                    iconSize: 20,
                    underline: Container(
                      height: 0,
                      color: Color(0xFFDDDDDD),
                    ),
                    value: "현위치 사용",
                    items: ["현위치 사용"].map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF333333),
                            fontFamily: 'noto',

                          ),
                        ),
                      );
                    }
                    ).toList(),
                    onChanged: (value){
                    },
                  ),
                )
              ],
            ),
            body:
              Stack(
                children: [
                  mapLoad ?
                  Positioned.fill(
                    child: GoogleMap(
                      initialCameraPosition: cameraPosition,
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      rotateGesturesEnabled: false,
                      onMapCreated: (GoogleMapController controller) {
                        controller.getVisibleRegion().then((value) async {
                            start = value.northeast.latitude.toString() + "," + value.northeast.longitude.toString();
                            end = value.southwest.latitude.toString() + "," + value.southwest.longitude.toString();
                            await P.Provider.of<StoreProvider>(context, listen: false).getStore(start, end, my.id);
                            // await P.Provider.of<StoreServiceProvider>(context, listen: false).reviewListSelect();
                            setState(() {
                              sp = P.Provider.of<StoreProvider>(context, listen: false);
                            });
                          });
                      },
                    ),
                  ) : Container(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: white,
                    child: Column(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                              initialPage: 0,
                              height: 185,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration: Duration(milliseconds:1000),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              viewportFraction: 1.0
                          ),
                          items: [
                            Image.asset(
                              "assets/resource/ad/banner1.png",
                              width: MediaQuery.of(context).size.width,
                              height: 120,
                            ),
                            Image.asset(
                              "assets/resource/ad/banner2.jpg",
                              width: MediaQuery.of(context).size.width,
                              height: 120,
                            ),
                            Image.asset(
                              "assets/resource/ad/ad_1.PNG",
                              width: MediaQuery.of(context).size.width,
                              height: 120,
                            ),
                            Image.asset(
                              "assets/resource/ad/ad_2.PNG",
                              width: MediaQuery.of(context).size.width,
                              height: 120,
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 90,
                                      child: Center(
                                        child: ListView.builder(
                                          itemBuilder: (context, idx) {
                                            return Padding(
                                              padding:
                                              EdgeInsets.only(right: idx < 4 ? 18 : 0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      width: 64,
                                                      height: 64,
                                                      child:
                                                      RaisedButton(
                                                        onPressed: () {
                                                          if (serviceName[idx] == '음식') {
                                                            print("음식");
                                                            setState(() {
                                                            });
                                                          } else if (serviceName[idx] ==
                                                              '패션') {
                                                            print("패션");
                                                          } else if (serviceName[idx] ==
                                                              '여행') {
                                                            print("여행");
                                                            setState(() {

                                                            });
                                                          } else if (serviceName[idx] ==
                                                              '문화') {
                                                            print("문화");
                                                            setState(() {

                                                            });
                                                          } else
                                                          if (serviceName[idx] == '키즈') {
                                                            print("키즈");
                                                          }
                                                        },
                                                        elevation: 0.0,
                                                        color: Colors.white,
                                                        padding: EdgeInsets.zero,
                                                        child: Center(
                                                          child: Image.asset(
                                                            serviceImage[idx],
                                                            width: 48,
                                                            height: 48,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(serviceName[idx],
                                                    style: TextStyle(
                                                        fontFamily: 'noto',
                                                        fontSize: 12,
                                                        color: black),),
                                                ],
                                              ),
                                            );
                                          },
                                          shrinkWrap: true,
                                          itemCount: 5,
                                          scrollDirection: Axis.horizontal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery
                                          .of(context).size.width,
                                      height: 90,
                                      child: Center(
                                        child: ListView.builder(
                                          itemBuilder: (context, idx) {
                                            return Padding(
                                              padding:
                                              EdgeInsets.only(right: idx < 4 ? 18 : 0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: ClipOval(
                                                      child: Container(
                                                        width: 64,
                                                        height: 64,
                                                        child: RaisedButton(
                                                          onPressed: () async {
                                                            if (serviceName[idx + 5] == '가전') {
                                                              print("가전");
                                                            } else if (serviceName[idx + 5] == '건강') {
                                                              print("건강");
                                                            } else if (serviceName[idx + 5] == '레저') {
                                                              print("레저");
                                                            } else if (serviceName[idx + 5] == '애완') {
                                                              print("애완");
                                                            } else {
                                                              print("기타");
                                                            }
                                                          },
                                                          elevation: 0.0,
                                                          padding: EdgeInsets.zero,
                                                          color: Colors.white,
                                                          child: Center(
                                                            child: Image.asset(
                                                              serviceImage[idx + 5],
                                                              width: 48,
                                                              height: 48,
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),),
                                                  Text(serviceName[idx+5],
                                                    style: TextStyle(
                                                        fontFamily: 'noto',
                                                        fontSize: 12,
                                                        color: black),),
                                                ],
                                              ),
                                            );
                                          },
                                          shrinkWrap: true,
                                          itemCount: 5,
                                          scrollDirection: Axis.horizontal,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 6,
                          color: Color(0xFFF2F2F2)
                        ),
                        whiteSpaceH(20),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("우리 동네 맛집",
                                      style: TextStyle(
                                          fontFamily: 'noto',
                                          fontSize: 14,
                                          color: black,
                                          fontWeight: FontWeight.w600),),
                                    InkWell(
                                      onTap: () async {
                                        await P.Provider.of<StoreProvider>(context, listen: false).clearMap();
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => MainMap())
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Text("지도로 보기"),
                                          whiteSpaceW(4.0),
                                          Image.asset(
                                            "assets/resource/main/go-map.png",
                                            width: 30,
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: sp == null?
                                  Center(
                                        child: CircularProgressIndicator(
                                            backgroundColor: mainColor,
                                            valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
                                        )
                                    )
                                      :
                                  Column(
                                    children: sp.store.map((e) {
                                      print(e.toString());
                                      return storeItem(e);
                                    }).toList() ,
                                  ),
                                ),
                              ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
    ),
    ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog( context: context,
      builder: (context) => AlertDialog( title: Text("앱을 종료하시겠습니까?"),
        actions: <Widget>[ FlatButton( child: Text("예"),
          onPressed: () => Navigator.pop(context, true), ),
          FlatButton( child: Text("아니요"), onPressed: () => Navigator.pop(context, false), ), ], ), ) ?? false;

  }

  Widget storeItem(StoreModel store) {

      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16.0),
        height: 110,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1))
        ),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: store.store.shop_img1,
              imageBuilder: (context, img) => Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(6.0)
                      ),
                      image: DecorationImage(
                          image: img, fit: BoxFit.fill
                      )
                  )
              ),
            ),
            whiteSpaceW(12),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(store.store.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'noto',
                        color: Color(0xFF333333),
                      )
                    ),
                    whiteSpaceW(5),
                    store.store.deliveryStatus == "1" ?
                    Container(
                        height: 20,
                        width: 20,
                        child: Center(
                          child:Text("포장",
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 9,
                                color: white),
                          ),
                        ),
                      decoration: BoxDecoration(
                          color: Color(0xFF55BBFF),
                        borderRadius: BorderRadius.all(Radius.circular(8.0))
                      ),
                    )
                  :
                    Text(""),
                whiteSpaceW(5),
                store.scrap.scrap == "1" ?
                Image.asset(
                  "assets/resource/main/scrap.png",
                  width: 20,
                  height: 20,
                ) : Text(""),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (store.store.useDL_Percent == null) ? "BZA 결제한도가 없습니다." : "${store.store.useDL_Percent}%",
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'noto',
                    color: Color(0xFF666666)
                  ),
                ),
              ],
            ),
            whiteSpaceH(4.0),
            Row(
              children: [
                Text(store.store.short_description,
                  style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'noto',
                      color: Color(0xFF666666)
                  ),),
              ],
            ),
                whiteSpaceH(4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${store.store.category_name} / ${store.store.category_sub_name}",
                      style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'noto',
                          color: Color(0xFFFFAA00),
                          fontWeight: FontWeight.w600
                      ),),
                    whiteSpaceW(10.0),
                    (store.store.deliveryTime == null) ?
                        Text("배달없음",
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'noto',
                            color: Color(0xFF666666)
                          )
                        )
                        :
                        Text("배달 ${store.store.deliveryTime}",
                            style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'noto',
                                color: Color(0xFF666666)
                            )
                        ),
                    Text(" · ",
                        style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'noto',
                            color: Color(0xFF666666)
                        )
                    ),
                    (store.store.minOrderAmount == null) ?
                    Text("최소주문금액 없음",
                        style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'noto',
                            color: Color(0xFF666666)
                        )
                    )
                    :
                    Text("최소주문 ${store.store.minOrderAmount}원",
                        style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'noto',
                            color: Color(0xFF666666)
                        )
                    ) 
                    ,
                  ],
                ),
          ],
        ),
      ],
     ),
    );
  }

}