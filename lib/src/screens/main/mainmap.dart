import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/franchisee/franchisee.dart';
import 'package:cashcook/src/model/place.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/qr/qr.dart';
import 'package:cashcook/src/screens/referrermanagement/referrermanagement.dart';
import 'package:cashcook/src/screens/storemanagement/storemanagement.dart';
import 'package:cashcook/src/screens/mypage/mypage.dart';
import 'package:cashcook/src/services/Search.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/dialog.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/model/place.dart';
import 'dart:async';

class MainMap extends StatefulWidget {
  @override
  _MainMap createState() => _MainMap();
}

class _MainMap extends State<MainMap> {
  TextEditingController searchCtrl = TextEditingController();

  AppBar appBar;

  var currentLocation;
  Location location = Location();
  CameraPosition cameraPosition;

  GoogleMapController googleMapController;

  bool mapLoad = false;

  List<Franchisee> franchiseeData = List();

  SearchService searchService = SearchService();
  PlaceDetail placeDetail;

  Set<Marker> markers = {};

  bool detailView = false;
  String detailImage = "";
  String detailName = "";
  String detailAddress = "";
  String detailType = "";
  String detailPhone = "";
  int isCurrentPage = 0; // 0: 지도, 1: 배달서비스, 2: 마이페이지

  @override
  void initState() {
    super.initState();
    getLocation();
//    franchiseeData.add(Franchisee(
//        imageUrl:
//            "https://s3.ap-northeast-2.amazonaws.com/img.kormedi.com/news/article/__icsFiles/artimage/2016/03/29/c_km601/911811_540.jpg",
//        address: "서울 뭐시구 뭐시로 24, 치킨타운 701호",
//        name: "라온치킨",
//        phone: "070-0000-0000",
//        type: "치킨",
//        lat: "37.468569",
//        lon: "126.887354"));
//
//    markerAdds();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initSetting());
    isCurrentPage = 0;
  }

  moveCamera() async {
    googleMapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(placeDetail.lat, placeDetail.lng),
      ),
    );

    final icon = await getBitmapDescriptorFromAssetBytes("assets/icon/a.png", 128);

    setState(() {
      markers.add(Marker(
        markerId: MarkerId("marker"),
        position: LatLng( placeDetail.lat, placeDetail.lng ),
        icon: icon,
      ));
    });

  }

  initSetting() {
    markerAdds();
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

  getLocation() async {
    currentLocation = await location.getLocation();
    print(currentLocation);
    /*
    cameraPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 14);
    */
    cameraPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 14);
    setState(() {
      mapLoad = true;
    });
  }

  setMyLocation() async {
    currentLocation = await location.getLocation();
    googleMapController.animateCamera(CameraUpdate.newLatLng(
        LatLng(currentLocation.latitude, currentLocation.longitude)));
  }

  markerAdds() {
    markers = {};
    int len = Provider.of<StoreProvider>(context, listen: false).store.length;
    for (int i = 0; i < len; i++) {
      final MarkerId markerId = MarkerId(i.toString());
      addMarker(i, markerId);
    }
  }

  double myLat;
  double myLon;

  distanceLocation(num) async {
    currentLocation = await location.getLocation();
    myLat = currentLocation.latitude;
    myLon = currentLocation.longitude;
    List<StoreModel> stores =
        Provider.of<StoreProvider>(context, listen: false).store;
    setState(() {
      distance = calculateDistance(
          myLat,
          myLon,
          double.parse(stores[num].address.coords.split(",").first),
          double.parse(stores[num].address.coords.split(",").last));
    });
  }

  addMarker(num, markerId) async {
    final icon = await getBitmapDescriptorFromAssetBytes(
        "assets/resource/map/marker.png", 128);
    List<StoreModel> stores =
        Provider.of<StoreProvider>(context, listen: false).store;
    print(stores);
    setState(() {
      markers.add(Marker(
          markerId: markerId,
          position: LatLng(
              double.parse(stores[num].address.coords.split(",").first),
              double.parse(stores[num].address.coords.split(",").last)),
          icon: icon,
          onTap: () {
            setState(() {
              print("checkMarker");
              detailView = true;
              detailImage = stores[num].store.shop_img1;
              detailName = stores[num].store.name;
              detailAddress = stores[num].address.address;
              detailType = "타입";
              detailPhone = stores[num].store.tel;
              distanceLocation(num);
            });
          }));
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
      String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double distance = 0.0;

  String getTitle() {
    if (isCurrentPage == 0)
      return "CASH COOK";
    else if (isCurrentPage == 1)
      return "CASH COOK";
    else if (isCurrentPage == 2) return "마이페이지";
  }

  Widget getChild() {
    if (isCurrentPage == 0) {
      return Stack(
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
              markers: markers,
              onCameraIdle: () {
                googleMapController
                    .getVisibleRegion()
                    .then((value) async {
//                        print(value.northeast.toString());
//                        print(value.southwest.toString());
                  String start = value.northeast.latitude.toString() +
                      "," +
                      value.northeast.longitude.toString();
                  String end = value.southwest.latitude.toString() +
                      "," +
                      value.southwest.longitude.toString();

                  await Provider.of<StoreProvider>(context, listen: false)
                      .getStore(start, end);
                  markerAdds();
                });
              },
              onMapCreated: (GoogleMapController controller) {
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
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.15), blurRadius: 8)
                  ],
                ),
                child: SingleChildScrollView(
                    child: Column (
                      children: [
                        TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: searchCtrl,
                            decoration: InputDecoration(
                              hintText: "검색",
                              hintStyle: TextStyle(
                                  fontFamily: 'noto',
                                  color: black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                            ),
                          ),
                          suggestionsCallback: (pattern) async{
                            return await searchService.getSearchList(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion.description),
                            );
                          },
                          onSuggestionSelected: (suggestion) async{
                            placeDetail = await searchService.getPlaceDetail(
                                suggestion.placeId
                            );
                            moveCamera();
                          },
                          hideOnEmpty: true,
                        ),
                      ],
                    )
                ),
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
          )
        ],
      );
    }
//    else if(isCurrentPage == 1){
//
//    }
    else if (isCurrentPage == 2) {
      return MyPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: true,
      appBar: appBar = AppBar(
        backgroundColor: white,
        elevation: 0.5,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          getTitle(),
          style: TextStyle(
              fontFamily: 'noto',
              color: isCurrentPage == 0 ? mainColor : Color(0xff444444),
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          detailView
              ? Padding(
            padding: EdgeInsets.only(right: 14),
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Qr()));
              },
              child: Image.asset(
                "assets/resource/map/qr.png",
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ),
          )
              : Container()
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom -
              appBar.preferredSize.height,
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
                      appBar.preferredSize.height -
                      53,
                  child: getChild(),
                ),
              ),
              detailView
                  ? Positioned(
                bottom: 222,
                right: 16,
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
                        "내 위치에서의 거리",
                        style: TextStyle(
                            color: Color(0xFF888888),
                            fontFamily: 'noto',
                            fontSize: 12),
                      ),
                      whiteSpaceW(8),
                      Text(
                        "${distance.toStringAsFixed(1)}km",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'noto',
                            color: mainColor),
                      )
                    ],
                  ),
                ),
              )
                  : Container(),
              detailView
                  ? Positioned(
                bottom: 53,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 153,
                  color: white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            detailView = false;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                          child: Center(
                            child: Container(
                              width: 32,
                              height: 4,
                              decoration: BoxDecoration(
                                  color: Color(0xFF888888),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: Color(0xFFDDDDDD),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 132,
                        color: white,
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: detailImage,
                              fit: BoxFit.fill,
                              width: 64,
                              height: 64,

                            ),
                            whiteSpaceW(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    detailName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: black,
                                        fontFamily: 'noto'),
                                  ),
                                  whiteSpaceH(5),
                                  Text(
                                    detailAddress,
                                    style: TextStyle(
                                        fontFamily: 'noto',
                                        color: Color(0xFF888888),
                                        fontSize: 12),
                                  ),
                                  whiteSpaceH(12),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        detailType,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: mainColor,
                                            fontFamily: 'noto'),
                                      ),
                                      whiteSpaceW(12),
                                      Text(
                                        detailPhone,
                                        style: TextStyle(
                                            fontFamily: 'noto',
                                            color: Color(0xFF888888),
                                            fontSize: 12),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            whiteSpaceW(12),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => Qr()));
                              },
                              child: Image.asset(
                                "assets/resource/map/qr.png",
                                width: 24,
                                height: 24,
                                fit: BoxFit.contain,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
                  : Container(),
              Positioned(
                bottom: 52,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: Color(0xFFDDDDDD),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 52,
                  color: white,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 52,
                          child: RaisedButton(
                            color: white,
                            onPressed: () {
                              showAlert();
                            },
                            elevation: 0.0,
                            child: Center(
                              child: Text(
                                "배달서비스",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF888888),
                                    fontFamily: 'noto'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      whiteSpaceW(80),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 52,
                          child: RaisedButton(
                            color: white,
                            onPressed: () {
                              setState(() {
                                detailView = false;
                                isCurrentPage = 2;
                              });
                            },
                            elevation: 0.0,
                            child: Center(
                              child: Text(
                                "마이페이지",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF888888),
                                    fontFamily: 'noto'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isCurrentPage = 0;
                      });
                    },
                    child: Image.asset(
                      "assets/icon/logo2.png",
                      width: 72,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}