import 'package:cashcook/src/provider/CarouselProvider.dart';
import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/CustomBottomNavBar.dart';
import 'package:cashcook/src/utils/MainStoreDivision.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/geocoder.dart';
import 'package:cashcook/src/widgets/StoreItem.dart';
import 'package:cashcook/src/widgets/mainStoreList.dart';
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
  String addressDetail = "";

  bool isStoreView = false;


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
      this.filterAddress = address;
      this.isStoreView = false;
    });

    P.Provider.of<StoreServiceProvider>(context, listen: false).setAddress(address);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await P.Provider.of<UserProvider>(context,listen: false).fetchMyInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if(!isStoreView) {
          if(this.lat == null && this.lon == null){
            // 초반
            var currentLocation =  await location.getLocation();
            setState(() {
              isStoreView=true;
              lat=currentLocation.latitude;
              lon=currentLocation.longitude;
            });
          } else {
            setState(() {
              isStoreView=true;
            });
          }
        }
      });

    return
      WillPopScope(
      onWillPop: viewType == 1 ?
      () {
        setState(() {
          viewType = 0;
        });

        return Future.value(false);
      }
      :_onBackPressed,
          child: Scaffold(
            backgroundColor: white,
            appBar: viewType == 0 ? AppBar(
              elevation: 0.5,
              centerTitle: false,
              leading: null,
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
                    await Navigator.of(context).pushNamed("/store/findAddress/detail",arguments: args);
                  },
                  child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icon/my_place.png",
                            width: 16,
                            height: 16
                          ),
                          whiteSpaceW(4),
                          Text("${(this.filterAddress == "현위치 사용") ?
                            this.filterAddress
                                :
                            this.filterAddress.split(" ")[3]}",
                            style: Body2.apply(color: secondary),
                            textAlign: TextAlign.end,
                          ),
                          Icon(Icons.arrow_drop_down,color: black),
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
                  CustomBottomNavBar(context, "home"),
                  Positioned(
                    bottom: 70,
                    right: 16,
                    child: InkWell(
                      onTap: () async {
                        await P.Provider.of<StoreProvider>(context, listen: false).clearMap();
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => MainMap())
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/resource/main/go-map.png",
                          width: 16,
                          height: 16,
                        ),
                        decoration: BoxDecoration(
                          color: white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(2,2),
                              blurRadius: 3,
                              color: Color(0xff888888).withOpacity(0.15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
    ),
    );
  }

  void changeView(idx) {
    setState(() {
      viewType = 1;
      this.idx = idx;
    });
  }

  Widget main() {
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
                      height: MediaQuery.of(context).size.width * 2 / 5,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          initialPage: 0,
                          height: MediaQuery.of(context).size.width * 2 / 5,
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
                            height: MediaQuery.of(context).size.height,
                            fit: BoxFit.cover,
                          ),
                          Image.asset(
                            "assets/resource/ad/banner2.png",
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            fit: BoxFit.cover,
                          ),
                          Image.asset(
                            "assets/resource/ad/banner3.png",
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            fit: BoxFit.cover,
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
                                      opacity: 0.6,
                                      child: Container(
                                        width: 90,
                                        height: 3,
                                        decoration: BoxDecoration(
                                            color: white,
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
                height: 180,
                child: Stack(
                  children: [
                    Container(
                      child: Center(
                        child: ListView.builder(
                          shrinkWrap: true,
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
                                                width: 36,
                                                height: 36
                                            ),
                                            whiteSpaceH(2),
                                             Text(serviceName[idx]['code_name'],
                                              style: Caption.apply(color: secondary),),
                                          ],
                                        )
                                    ),
                                  ),
                                ),
                                whiteSpaceH(18),
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
                                              width: 36,
                                              height: 36
                                          ),
                                          whiteSpaceH(2),
                                          Text(serviceName[idx+5]['code_name'],
                                            style: Caption.apply(color: secondary),),
                                        ],
                                      )
                                  ),
                                )
                              ],
                            );
                          },
                          itemCount: 5,
                        ),
                ),
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
            whiteSpaceH(12),
            isStoreView ?
                Column(
                  children: MAIN_STORE_DIVISION.map((e) =>
                        MainStoreList(
                          changeView: this.changeView,
                          storeInfo: e,
                          lat: this.lat,
                          lon: this.lon,
                        ),
                  ).toList()
                )
            // Column(
            //   children: [
            //     Container(
            //       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            //       child: Container(
            //         child: Column(
            //           children: [
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Text("우리 동네 맛집", style: Subtitle2,),
            //                 Container(
            //                   width: 90,
            //                   child:
            //                   Row(
            //                     children: [
            //                       SizedBox(
            //                           width: 10.0,
            //                           child:
            //                           IconButton(
            //                               iconSize: 17.0, icon: Icon(Icons.add_circle_outline), onPressed: null)),
            //
            //                       SizedBox(
            //                         width: 80.0,
            //                         child:
            //                         FlatButton(onPressed: (){
            //                           setState(() {
            //                             viewType = 1;
            //                             this.idx = 0;
            //                           });
            //                         }, child: Text('더보기')),
            //                       )
            //                     ],
            //                   ),),
            //
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     MainStoreList(
            //       categoryCode: "01",
            //       lat: this.lat,
            //       lon: this.lon,
            //     ),
            //     Container(
            //       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            //       child: Container(
            //         child: Column(
            //           children: [
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Text("내가 바로 패셔니스트", style: Subtitle2,),
            //                 Container(
            //                   width: 90,
            //                   child:
            //                   Row(
            //                     children: [
            //                       SizedBox(
            //                           width: 10.0,
            //                           child:
            //                           IconButton(
            //                               iconSize: 17.0, icon: Icon(Icons.add_circle_outline), onPressed: null)),
            //                       SizedBox(
            //                         width: 80.0,
            //                         child:
            //                         FlatButton(onPressed: (){
            //                           setState(() {
            //                             viewType = 1;
            //                             this.idx = 1;
            //                           });
            //                         }, child: Text('더보기')),
            //                       )
            //                     ],
            //                   ),),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     MainStoreList(
            //       categoryCode: "02",
            //       lat: this.lat,
            //       lon: this.lon,
            //     ),
            //     Container(
            //       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            //       child: Container(
            //         child: Column(
            //           children: [
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Text("건강 관리 필수 요소", style: Subtitle2,),
            //                 Container(
            //                   width: 90,
            //                   child:
            //                   Row(
            //                     children: [
            //                       SizedBox(
            //                           width: 10.0,
            //                           child:
            //                           IconButton(
            //                               iconSize: 17.0, icon: Icon(Icons.add_circle_outline), onPressed: null)),
            //                       SizedBox(
            //                         width: 80.0,
            //                         child:
            //                         FlatButton(onPressed: (){
            //                           setState(() {
            //                             viewType = 1;
            //                             this.idx = 6;
            //                           });
            //                         }, child: Text('더보기')),
            //                       )
            //                     ],
            //                   ),),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     MainStoreList(
            //       categoryCode: "07",
            //       lat: this.lat,
            //       lon: this.lon,
            //     ),
            //   ],
            // )
                : Container()

            //
            //
            // P.Consumer<StoreServiceProvider>(
            //   builder: (context, ssp, _){
            //     return ssp.isLoading ?
            //     Container(
            //         width: MediaQuery.of(context).size.width,
            //         height: 212,
            //         child:
            //         Center(
            //             child: CircularProgressIndicator(
            //                 valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
            //             )
            //         )
            //     )
            //         :
            //
            //   },
            // ),


            // Container(
            //    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16, ),
            //   child:
            //   Container(
            //     child: Column(
            //       children: [
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //
            //             Text("서비스 스토어", style: Subtitle2,),
            //             Container(
            //               width: 90,
            //               child:
            //               Row(
            //                 children: [
            //                   SizedBox(
            //                       width: 10.0,
            //                       child:
            //                         IconButton(
            //                             iconSize: 17.0, icon: Icon(Icons.add_outlined), onPressed: null),),
            //                   SizedBox(
            //                     width: 80.0,
            //                     child:
            //                         FlatButton(onPressed: (){
            //                           print('더보기 클릭');
            //                         }, child: Text('더보기')),
            //                   )
            //                 ],
            //               ),),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            //
            //
            // P.Consumer<StoreServiceProvider>(
            //   builder: (context, ssp, _){
            //     return ssp.isLoading ?
            //     Container(
            //         width: MediaQuery.of(context).size.width,
            //         height: 220,
            //         child:
            //         Center(
            //             child: CircularProgressIndicator(
            //                 valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
            //             )
            //         )
            //     )
            //         :
            //     //Column Version
            //     // 원본, 세로리스트
            //     Container(
            //         width: MediaQuery.of(context).size.width,
            //         child:
            //         SingleChildScrollView(
            //           scrollDirection: Axis.horizontal,
            //           child: Row(
            //             children: ssp.store.map((e) {
            //
            //               return storeItem(e, context);
            //
            //             }).toList(),
            //           ),
            //         )
            //     );
            //   },
            // ),
            //
            //
            //
            // Container(
            //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16, ),
            //   child:
            //   Container(
            //     child: Column(
            //       children: [
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //
            //             Text("제품 판매 스토어", style: Subtitle2,),
            //             Container(
            //               width: 90,
            //               child:
            //               Row(
            //                 children: [
            //                   SizedBox(
            //                     width: 10.0,
            //                     child:
            //                     IconButton(
            //                         iconSize: 17.0, icon: Icon(Icons.add_outlined), onPressed: null),),
            //                   SizedBox(
            //                     width: 80.0,
            //                     child:
            //                     FlatButton(onPressed: (){
            //                       print('더보기 클릭');
            //                     }, child: Text('더보기')),
            //                   )
            //                 ],
            //               ),),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            //
            // P.Consumer<StoreServiceProvider>(
            //   builder: (context, ssp, _){
            //     return ssp.isLoading ?
            //     Container(
            //         width: MediaQuery.of(context).size.width,
            //         height: 220,
            //         child:
            //         Center(
            //             child: CircularProgressIndicator(
            //                 valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
            //             )
            //         )
            //     )
            //         :
            //     //Column Version
            //     // 원본, 세로리스트
            //     Container(
            //         width: MediaQuery.of(context).size.width,
            //         child:
            //         SingleChildScrollView(
            //           scrollDirection: Axis.horizontal,
            //           child: Row(
            //             children: ssp.store.map((e) {
            //
            //               return storeItem(e, context);
            //
            //             }).toList(),
            //           ),
            //         )
            //     );
            //   },
            // ),


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
                                style: Body1,
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
                            await Navigator.of(context).pushNamed("/store/findAddress/detail",arguments: args);
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
                                    Text("${(this.filterAddress == "현위치 사용") ?
                                    this.filterAddress
                                        :
                                    this.filterAddress.split(" ")[3]}",
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
                            child: ssp.isLoading ?
                            LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                              valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFF7F7F7)),
                            )
                                :
                            ListView.builder(
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
                                          style: Body1.apply(
                                            fontWeightDelta: -1,
                                            color: ssp.selectSubCat_code == ssp.subCatList[idx].code ?
                                                black
                                                :
                                                third
                                          ),
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
                                      valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
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
                                        style: Subtitle2.apply(
                                          color: primary
                                        )
                                    ),
                                    Text("개 성공스토어",
                                        style: Subtitle2
                                    ),
                                    whiteSpaceW(8.0),
                                    Image.asset(
                                      "assets/resource/main/go-map.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child:
                                Column(
                                  children: ssp.searchStore.map((e) {
                                    return storeItemRow(e, context);
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
              height: MediaQuery.of(context).size.height * 1/2,
              padding: EdgeInsets.only(right: 20, left: 20),
              child:
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "카테고리",
                          style: Subtitle2
                        ),
                      ),
                      whiteSpaceH(20),
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
                                      style: Caption.apply(
                                        color: secondary
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
                                      style: Caption.apply(
                                          color: secondary
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
                                          color: secondary,
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