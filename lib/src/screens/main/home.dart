import 'package:cashcook/src/provider/CarouselProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/CustomBottomNavBar.dart';
import 'package:cashcook/src/widgets/StoreItem.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart' as P;
import 'dart:async';
import 'package:location/location.dart';
import 'package:cashcook/src/utils/MenuSlidePop.dart' as slideDialog;

class Home extends StatefulWidget {

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  Location location = Location();
  int viewType = 0;
  int idx = 0;

  double lat;
  double lon;
  String filterAddress = "현위치 사용";

  List<dynamic> serviceName = [
    {
      "code": '01', "code_name": '음식'
    },
    {
      "code": '02', "code_name": '패션'
    },
    {
      "code": '03', "code_name": '여행'
    },
    {
      "code": '04', "code_name": '문화'
    },
    {
      "code": '05', "code_name": '키즈'
    },
    {
      "code": '06', "code_name": '가전'
    },
    {
      "code": '07', "code_name": '건강'
    },
    {
      "code": '08', "code_name": '레저'
    },
    {
      "code": '09', "code_name": '애완'
    },
    {
      "code": '10', "code_name": '기타'
    },
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

  void getData(address, lat, lon){
    setState(() {
      this.lat = lat;
      this.lon = lon;
      this.filterAddress = address.toString().split(" ")[3];
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await P.Provider.of<UserProvider>(context,listen: false).fetchMyInfo(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
      onWillPop: _onBackPressed,
          child: Scaffold(
            backgroundColor: white,
            appBar: viewType == 0 ? AppBar(
              elevation: 0.5,
              centerTitle: false,
              title: Container(
                padding: EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
                child: Image.asset(
                  "assets/icon/cashcook_logo.png",
                  width: 108,
                  height: 32,
                ),
              ),
              actions: [
                InkWell(
                  onTap: () async {
                    Map<String, dynamic> args = {
                      "getData": getData,
                    };
                    await Navigator.of(context).pushNamed("/store/findAddress",arguments: args);
                  },
                  child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Text(this.filterAddress,
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'noto',
                              color: Color(0xFF333333)
                            ),
                            textAlign: TextAlign.end,
                          ),
                          Icon(Icons.arrow_drop_down,color: Color(0xFF333333)),
                        ]
                      )
                  ),
                )
              ],
            ) : null,
            body: Stack(
                children: [
                  Positioned.fill(child:
                    viewType == 0 ?
                    main()
                        :
                    categorySearch()
                  ),
                  CustomBottomNavBar(context, "home")
                ],
              ),
    ),
    );
  }

  Widget main() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if(this.lat == null && this.lon == null){
        var currentLocation =  await location.getLocation();

        String start = (currentLocation.latitude + 0.04).toString() +
            "," +
            (currentLocation.longitude + 0.04).toString();
        String end = (currentLocation.latitude - 0.04).toString() +
            "," +
            (currentLocation.longitude - 0.04).toString();

        await P.Provider.of<StoreServiceProvider>(context, listen: false).getStore(start, end);
      } else {
        String start = (this.lat + 0.04).toString() +
            "," +
            (this.lon + 0.04).toString();
        String end = (this.lat - 0.04).toString() +
            "," +
            (this.lon - 0.04).toString();

        await P.Provider.of<StoreServiceProvider>(context, listen: false).getStore(start, end);
      }
    });
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(bottom: 60.0),
        color: white,
        child: Column(
          children: [
            P.Consumer<CarouselProvider>(
              builder: (context, cp, _){
                return Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 140,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          initialPage: 0,
                          height: 140,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds:1000),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            cp.changePage(index);
                          },
                        ),
                        items: [
                          Image.asset(
                            "assets/resource/ad/banner1.png",
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                          Image.asset(
                            "assets/resource/ad/banner2.jpg",
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                          Image.asset(
                            "assets/resource/ad/ad_1.PNG",
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                          Image.asset(
                            "assets/resource/ad/ad_2.PNG",
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        margin: EdgeInsets.only(left: 24.0, bottom: 12.0),
                        width: 130,
                        height: 40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "${cp.nowPage + 1}/${cp.allPage + 1}",
                              style: TextStyle(
                                fontSize: 8,
                                fontFamily: 'noto',
                                color: white,
                              ),
                            ),
                            whiteSpaceH(4.0),
                            Container(
                                child: Stack (
                                  children: [
                                    Opacity(
                                      opacity: 0.3,
                                      child: Container(
                                        width: 120,
                                        height: 3,
                                        decoration: BoxDecoration(
                                            color: Color(0xFFAAAAAA),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)
                                            )
                                        ),
                                      ),
                                    ),
                                    AnimatedPositioned(
                                      left: 30.0 * cp.nowPage,
                                      child: Container(
                                        width: 30,
                                        height: 3,
                                        decoration: BoxDecoration(
                                            color: white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)
                                            )
                                        ),
                                      ),
                                      duration: Duration(milliseconds: 200),
                                    )
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 19.0, horizontal: 8.0),
                width: MediaQuery.of(context).size.width,
                height: 170,
                child: Stack(
                  children: [
                    ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,idx) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                if (serviceName[idx]['code_name'] == '음식') {
                                  print("음식");
                                } else if (serviceName[idx]['code_name'] ==
                                    '패션') {
                                  print("패션");
                                } else if (serviceName[idx]['code_name'] ==
                                    '여행') {
                                  print("여행");
                                } else if (serviceName[idx]['code_name'] ==
                                    '문화') {
                                  print("문화");
                                } else
                                if (serviceName[idx]['code_name'] == '키즈') {
                                  print("키즈");
                                }

                                setState(() {
                                  viewType = 1;
                                  this.idx = idx;
                                });
                              },
                              child: Container(
                                width: 72,
                                height: 64,
                                child: Center(
                                    child : Column(
                                      children: [
                                        Image.asset(
                                            serviceImage[idx],
                                            width: 32,
                                            height: 32
                                        ),
                                        whiteSpaceH(6),
                                        Text(serviceName[idx]['code_name'],
                                          style: TextStyle(
                                              fontFamily: 'noto',
                                              fontSize: 10,
                                              color: Color(0xFF666666)),),
                                      ],
                                    )
                                ),
                              ),
                            ),
                            whiteSpaceH(12),
                            InkWell(
                              onTap: () {
                                if (serviceName[idx + 5]['code_name'] == '가전') {
                                  print("가전");
                                } else if (serviceName[idx + 5]['code_name'] == '건강') {
                                  print("건강");
                                } else if (serviceName[idx + 5]['code_name']  == '레저') {
                                  print("레저");
                                } else if (serviceName[idx + 5]['code_name']  == '애완') {
                                  print("애완");
                                } else {
                                  print("기타");
                                }

                                setState(() {
                                  viewType = 1;
                                  this.idx = idx + 5;
                                });
                              },
                              child: Center(
                                  child : Column(
                                    children: [
                                      Image.asset(
                                          serviceImage[idx+5],
                                          width: 32,
                                          height: 32
                                      ),
                                      whiteSpaceH(6),
                                      Text(serviceName[idx+5]['code_name'],
                                        style: TextStyle(
                                            fontFamily: 'noto',
                                            fontSize: 10,
                                            color: Color(0xFF666666)),),
                                    ],
                                  )
                              ),
                            )
                          ],
                        );
                      },
                      itemCount: 5,
                    ),
                    Positioned(
                      right:0,
                      top: 0,
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.white,
                              Colors.white,
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Container(
                          color: white,
                        width: 40,
                        height: MediaQuery.of(context).size.height
                      ),
                      ),
                    )
                  ]
                )
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
                                width: 24,
                                height: 24,
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
            P.Consumer<StoreServiceProvider>(
              builder: (context, ssp, _){
                return ssp.isLoading ?
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 220,
                    child:
                    Center(
                        child: CircularProgressIndicator(
                            backgroundColor: mainColor,
                            valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
                        )
                    )
                )
                    :
                Container(
                  width: MediaQuery.of(context).size.width,
                  child:
                  Column(
                    children: ssp.store.map((e) {
                      print(e.toString());
                      return storeItem(e, context);
                    }).toList() ,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget categorySearch() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if(this.lat == null && this.lon == null){
        var currentLocation =  await location.getLocation();

        String start = (currentLocation.latitude + 0.04).toString() +
            "," +
            (currentLocation.longitude + 0.04).toString();
        String end = (currentLocation.latitude - 0.04).toString() +
            "," +
            (currentLocation.longitude - 0.04).toString();

        await P.Provider.of<StoreServiceProvider>(context, listen:false).fetchSubCategory(serviceName[idx]['code'],start ,end);
      } else {
        String start = (this.lat + 0.04).toString() +
            "," +
            (this.lon + 0.04).toString();
        String end = (this.lat - 0.04).toString() +
            "," +
            (this.lon - 0.04).toString();

        await P.Provider.of<StoreServiceProvider>(context, listen:false).fetchSubCategory(serviceName[idx]['code'], start, end);
      }
    });
    return Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top,
            bottom: 60.0
          ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Color(0xFFDDDDDD), width: 1)
                  )
              ),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              viewType = 0;
                            });
                          },
                          icon: Image.asset(
                            "assets/resource/public/prev.png",
                            width: 24,
                            height: 24,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            MenuSlide();
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                serviceImage[idx],
                                width: 24,
                                height: 24,
                              ),
                              whiteSpaceW(8),
                              Text(
                                serviceName[idx]['code_name'],
                                style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'noto'
                                ),
                              ),
                              Icon(Icons.arrow_drop_down,color: Color(0xFF333333)),
                            ],
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () async {
                            Map<String, dynamic> args = {
                              "getData": getData,
                            };
                            await Navigator.of(context).pushNamed("/store/findAddress",arguments: args);
                          },
                          child: Container(
                              child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/icon/my_place.png",
                                      width: 16,
                                      height: 16,
                                    ),
                                    whiteSpaceW(4.0),
                                    Text(this.filterAddress,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'noto',
                                          color: Color(0xFF333333)
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                    Icon(Icons.arrow_drop_down,color: Color(0xFF333333)),
                                  ]
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                  P.Consumer<StoreServiceProvider>(
                    builder: (context, ssp, _){
                      return Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            child:ListView.builder(
                                itemBuilder: (context, idx) {
                                  return InkWell(
                                    onTap: () async {
                                      if(this.lat == null && this.lon == null){
                                        var currentLocation =  await location.getLocation();

                                        String start = (currentLocation.latitude + 0.04).toString() +
                                            "," +
                                            (currentLocation.longitude + 0.04).toString();
                                        String end = (currentLocation.latitude - 0.04).toString() +
                                            "," +
                                            (currentLocation.longitude - 0.04).toString();

                                        await ssp.selSearchCategory(serviceName[this.idx]['code'],ssp.subCatList[idx].code_name,start, end);
                                      } else {
                                        String start = (this.lat + 0.04).toString() +
                                            "," +
                                            (this.lon + 0.04).toString();
                                        String end = (this.lat - 0.04).toString() +
                                            "," +
                                            (this.lon - 0.04).toString();

                                        await ssp.selSearchCategory(serviceName[this.idx]['code'],ssp.subCatList[idx].code_name, start, end);
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 16),
                                      child: Center(
                                        child: Text(ssp.subCatList[idx].code_name,
                                          style: TextStyle(
                                              fontFamily: 'noto',
                                              fontSize: 13,
                                              color: Color(0xFF666666)),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(color: ssp.selectSubCat_code == ssp.subCatList[idx].code ?
                                              mainColor
                                                  :
                                              white, width: 2)
                                          )
                                      ),
                                    ),
                                  );
                                },
                                itemCount: ssp.subCatList.length,
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: [
                                      Colors.white,
                                      Colors.white,
                                      Colors.transparent,
                                      Colors.transparent,
                                    ],
                                  ).createShader(bounds);
                                },
                                blendMode: BlendMode.dstIn,
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  color: white,
                                  width: 20,
                                )
                            ),
                          )
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
            Expanded(
                child: Container(
                    child: SingleChildScrollView(
                      child: P.Consumer<StoreServiceProvider>(
                        builder: (context, ssp, _){
                          return ssp.isLoading ?
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: 220,
                              child:
                              Center(
                                  child: CircularProgressIndicator(
                                      backgroundColor: mainColor,
                                      valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
                                  )
                              )
                          )
                              :
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 22, right: 16, left: 16, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Text("${ssp.count}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'noto',
                                            color: mainColor,
                                            fontWeight: FontWeight.bold
                                        )
                                    ),
                                    Text("개 매장",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'noto',
                                            color: Color(0xFF333333),
                                            fontWeight: FontWeight.bold
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child:
                                Column(
                                  children: ssp.searchStore.map((e) {
                                    return storeItem(e, context);
                                  }).toList() ,
                                ),
                              )
                            ]
                          );
                        },
                      ),
                    )

                )
            )
          ],
        )
    );
  }

  Future<bool> _onBackPressed() {
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



  void MenuSlide() {
    slideDialog.showSlideDialog(
        context: context,
        child: Flexible(
          child: Container(
              padding: EdgeInsets.only(right: 20, left: 20),
              child:
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [0,1,2,3].map((e) =>
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    idx = e;
                                  });

                                  Navigator.of(context).pop();
                                },
                                child: Column(
                                  children: [
                                    Image.asset(serviceImage[e],
                                        width: 36,
                                        height: 36
                                    ),
                                    Text(serviceName[e]['code_name'],
                                      style: TextStyle(
                                          color: Color(0xFF666666),
                                          fontFamily: 'noto',
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                        ).toList(),
                      ),
                      whiteSpaceH(18.0),
                      Row(
                        children: [4,5,6,7].map((e) =>
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    idx = e;
                                  });

                                  Navigator.of(context).pop();
                                },
                                child: Column(
                                  children: [
                                    Image.asset(serviceImage[e],
                                        width: 36,
                                        height: 36
                                    ),
                                    Text(serviceName[e]['code_name'],
                                      style: TextStyle(
                                          color: Color(0xFF666666),
                                          fontFamily: 'noto',
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                        ).toList(),
                      ),
                      whiteSpaceH(18.0),
                      Row(
                        children: [8,9,10,11].map((e) =>
                            e <= 9 ?
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    idx = e;
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Column(
                                  children: [
                                    Image.asset(serviceImage[e],
                                        width: 36,
                                        height: 36
                                    ),
                                    Text(serviceName[e]['code_name'],
                                      style: TextStyle(
                                          color: Color(0xFF666666),
                                          fontFamily: 'noto',
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                                :
                                Expanded(
                                  child: Container(),
                                )
                        ).toList(),
                      ),
                    ],
                  ),
                )
          ),
        )
    );
  }

}