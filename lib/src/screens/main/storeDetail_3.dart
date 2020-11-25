import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/provider/CarouselProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/qr/qr.dart';
import 'package:cashcook/src/screens/storemanagement/orderMenu.dart';
import 'package:cashcook/src/utils/Share.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/StoreServiceItem.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';

class StoreDetail3 extends StatefulWidget {
  StoreModel store;

  StoreDetail3({this.store});
  @override
  _StoreDetail3 createState() => _StoreDetail3();
}

class _StoreDetail3 extends State<StoreDetail3> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<StoreServiceProvider>(context, listen: false).clearOrderAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<StoreProvider>(
          builder: (context, sp, _){
            return Scaffold (
              backgroundColor: white,
              body: SafeArea(
                child: Container(
                    child:ListView.builder(
                      itemBuilder: (context, index) {
                        return StickyHeaderBuilder(
                            overlapHeaders: true,
                            builder: (BuildContext context, double stuckAmount) {
                              stuckAmount = stuckAmount.abs().clamp(0.0, 1.0);
                              return Container(
                                  padding: EdgeInsets.only(right: 16.0,),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    // color : null
                                    color: stuckAmount <= 0.55 ? null : Color.lerp(null, white, stuckAmount),
                                  ),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            icon: Image.asset(
                                              "assets/resource/public/prev.png",
                                              width: 24,
                                              height: 24,
                                              color: Color.lerp(white, black, stuckAmount),
                                            ),
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () {
                                              onKakaoStoreShare(widget.store.store.name, widget.store.store.shop_img1, widget.store.store.short_description);
                                            },
                                            child: Image.asset(
                                              "assets/icon/share_blue.png",
                                              width: 24,
                                              height: 24,
                                              color: Color.lerp(white, black, stuckAmount),
                                            ),
                                          ),
                                          whiteSpaceW(12.0),
                                          Consumer<StoreServiceProvider>(
                                            builder: (context, ssp, _) {
                                              return InkWell(
                                                onTap: widget.store.scrap.scrap == "0" ? () {
                                                  ssp.doScrap(
                                                      widget.store.id.toString()
                                                  );
                                                } : () {
                                                  ssp.cancleScrap(
                                                      widget.store.id
                                                  );
                                                },
                                                child: Image.asset(
                                                  "assets/resource/main/steam.png",
                                                  width: 24,
                                                  height: 24,
                                                  color: widget.store.scrap.scrap == "0" ? Color.lerp(white, black, stuckAmount) : mainColor,
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                      Opacity(
                                        opacity: stuckAmount < 0.55 ? 0.0 : stuckAmount,
                                        child: Center(
                                          child: Container(
                                              height: 55,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(widget.store.store.name,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontFamily: 'noto',
                                                        fontWeight: FontWeight.w600,
                                                        color: Color.lerp(Colors.transparent, black, stuckAmount * 1.1),
                                                      )
                                                  ),
                                                ],
                                              )
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              );
                            },
                            content: Column(
                              children: [
                                Container(
                                  width:MediaQuery.of(context).size.width,
                                  height: 210,
                                  child:
                                  Stack(
                                    children: [
                                      CarouselSlider(
                                        options: CarouselOptions(
                                          initialPage: 0,
                                          height: 210,
                                          autoPlayInterval: Duration(seconds: 3),
                                          autoPlayAnimationDuration: Duration(milliseconds:1000),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          viewportFraction: 1.0,
                                          onPageChanged: (index, reason) {
                                            Provider.of<CarouselProvider>(context, listen:false).changePage(index+1);
                                          },
                                        ),
                                        items: [
                                          Stack(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: widget.store.store.shop_img2,
                                                fit: BoxFit.fill,
                                                width: MediaQuery.of(context).size.width,
                                                height: MediaQuery.of(context).size.height,
                                              ),
                                              Opacity(
                                                opacity: 0.2,
                                                child: ShaderMask(
                                                  shaderCallback: (Rect bounds) {
                                                    return LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: [
                                                        Colors.black,
                                                        Colors.black,
                                                        Colors.transparent,
                                                      ],
                                                    ).createShader(bounds);
                                                  },
                                                  blendMode: BlendMode.dstIn,
                                                  child: Container(
                                                      color: black,
                                                      width: MediaQuery.of(context).size.width,
                                                      height: MediaQuery.of(context).size.height
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Stack(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: widget.store.store.shop_img3,
                                                fit: BoxFit.fill,
                                                width: MediaQuery.of(context).size.width,
                                                height: MediaQuery.of(context).size.height,
                                              ),
                                              Opacity(
                                                opacity: 0.2,
                                                child: ShaderMask(
                                                  shaderCallback: (Rect bounds) {
                                                    return LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: [
                                                        Colors.black,
                                                        Colors.black,
                                                        Colors.transparent,
                                                      ],
                                                    ).createShader(bounds);
                                                  },
                                                  blendMode: BlendMode.dstIn,
                                                  child: Container(
                                                      color: black,
                                                      width: MediaQuery.of(context).size.width,
                                                      height: MediaQuery.of(context).size.height
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Stack(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: widget.store.store.shop_img1,
                                                fit: BoxFit.fill,
                                                width: MediaQuery.of(context).size.width,
                                                height: MediaQuery.of(context).size.height,
                                              ),
                                              Opacity(
                                                opacity: 0.2,
                                                child: ShaderMask(
                                                  shaderCallback: (Rect bounds) {
                                                    return LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: [
                                                        Colors.black,
                                                        Colors.black,
                                                        Colors.transparent,
                                                      ],
                                                    ).createShader(bounds);
                                                  },
                                                  blendMode: BlendMode.dstIn,
                                                  child: Container(
                                                      color: black,
                                                      width: MediaQuery.of(context).size.width,
                                                      height: MediaQuery.of(context).size.height
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // CustomAppBar

                                      Positioned(
                                          bottom: 45,
                                          left: 28,
                                          child: Opacity(
                                              opacity: 0.4,
                                              child: Consumer<CarouselProvider>(
                                                builder: (context, cp, _){
                                                  return Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                                                    child: Center(
                                                      child: Opacity(
                                                          opacity: 1,
                                                          child:Text("${cp.nowPage}/3",
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                fontFamily: 'noto',
                                                                color: white
                                                            ),
                                                          )
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: black,
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(3.0)
                                                        )
                                                    ),
                                                  );
                                                },
                                              )
                                          )
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 18.0, bottom: 12.0),
                                    width: MediaQuery.of(context).size.width,
                                    height: 102,
                                    decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(2,2),
                                          blurRadius: 3,
                                          color: Color(0xff888888).withOpacity(0.15),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Text("${widget.store.store.name}",
                                            style: Subtitle2
                                        ),
                                        whiteSpaceH(12.0),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/icon/steam_color.png",
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                  whiteSpaceW(4.0),
                                                  Text("${NumberFormat("#.#").format(widget.store.store.scope)}",
                                                    style: Body1.apply(color: secondary, fontWeightDelta: -1),
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                              ),
                                            ),
                                            Container(
                                              color: Color(0xFFDDDDDD),
                                              height: 8,
                                              width: 1,
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Text("DL ",
                                                      style: Body1.apply(
                                                        color: primary
                                                      )
                                                  ),
                                                  whiteSpaceW(4.0),
                                                  Text("${widget.store.store.limitDL == null ? "100" : widget.store.store.limitDL }%",
                                                    style: Body1.apply(color: secondary, fontWeightDelta: -1),
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                              ),
                                            ),
                                            Container(
                                              color: Color(0xFFDDDDDD),
                                              height: 8,
                                              width: 1,
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) => Qr(),
                                                        settings: RouteSettings(
                                                            arguments: {
                                                              "store_id": widget.store.id,
                                                              "store_name" : widget.store.store.name
                                                            }
                                                        )
                                                    ),);
                                                },
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      "assets/icon/qr_scan.png",
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                    whiteSpaceW(4.0),
                                                    Text("QR 스캔",
                                                      style: Body1.apply(color: secondary, fontWeightDelta: -1),
                                                      textAlign: TextAlign.center,
                                                    )
                                                  ],
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Consumer<StoreServiceProvider>(
                                  builder: (context, ss, _){
                                    return Container(
                                      transform: Matrix4.translationValues(0.0, -24.0, 0.0),
                                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex:1,
                                                child:Text(
                                                    "업종",
                                                    style: Body1.apply(color: third)
                                                ),
                                              ),
                                              Expanded(
                                                flex:3,
                                                child:Text(
                                                  "${widget.store.store.category_name} / ${widget.store.store.category_sub_name}",
                                                  style: Body1.apply(color: mainColor),
                                                ),
                                              )
                                            ],
                                          ),
                                          whiteSpaceH(12),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex:1,
                                                child:Text(
                                                  "배달",
                                                  style: Body1.apply(color: third),
                                                ),
                                              ),
                                              Image.asset(
                                                "assets/icon/time-dark.png",
                                                width: 12,
                                                height: 12,
                                              ),
                                              whiteSpaceW(4.0),
                                              Expanded(
                                                flex:3,
                                                child:Row(
                                                    children: [
                                                      Text(
                                                        "${widget.store.store.deliveryTime == null ? "배달 X" : widget.store.store.deliveryTime}",
                                                        style: Body1.apply(color: secondary),
                                                      ),
                                                      Text(
                                                        " ㆍ ",
                                                        style: Body1.apply(color: secondary),
                                                      ),
                                                      Text(
                                                        "최소주문 ${widget.store.store.minOrderAmount == null ?
                                                        "금액없음"
                                                            :
                                                        widget.store.store.minOrderAmount + "원"
                                                        }",
                                                        style: Body1.apply(color: secondary),
                                                      ),
                                                    ]
                                                ),
                                              )
                                            ],
                                          ),
                                          whiteSpaceH(12),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex:1,
                                                child:Text(
                                                  "연락처",
                                                  style: Body1.apply(color: third),
                                                ),
                                              ),
                                              Expanded(
                                                flex:3,
                                                child:Text(
                                                  "${
                                                      widget.store.store.tel.substring(0,3) + "-" +
                                                          widget.store.store.tel.substring(3,7) + "-" +
                                                          widget.store.store.tel.substring(7,widget.store.store.tel.length)
                                                  }",
                                                  style: Body1.apply(color: secondary),
                                                ),
                                              )
                                            ],
                                          ),
                                          whiteSpaceH(12),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex:1,
                                                child:Text(
                                                    "영업시간",
                                                    style: Body1.apply(color: third)
                                                ),
                                              ),
                                              Expanded(
                                                flex:3,
                                                child:Text(
                                                  widget.store.store.store_time,
                                                  style: Body1.apply(color: secondary),
                                                ),
                                              )
                                            ],
                                          ),
                                          whiteSpaceH(12),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                flex:1,
                                                child:Text(
                                                  "주소",
                                                  style: Body1.apply(color: third),
                                                ),
                                              ),
                                              Expanded(
                                                flex:3,
                                                child:Text(
                                                  "${widget.store.address.address},\n${widget.store.address.detail}",
                                                  style: Body1.apply(color: secondary),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                Consumer<StoreServiceProvider>(
                                    builder: (context, ss, _){
                                      return StickyHeaderBuilder(
                                        builder: (BuildContext context, double stuckAmount) {
                                          return Container(
                                              margin: EdgeInsets.only(
                                                top: 40,
                                              ),
                                              width: MediaQuery.of(context).size.width,
                                              color: white,
                                              height: 55,
                                              child: Stack(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(context).size.width,
                                                        height: 6,
                                                        color: Color(0xFFF2F2F2),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child:InkWell(
                                                                onTap: () async {
                                                                  await Provider.of<StoreServiceProvider>(context, listen: false).setServiceNum(0, widget.store.id);
                                                                },
                                                                child: Container(
                                                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                                                  child:Text(
                                                                      "상품",
                                                                      textAlign: TextAlign.center,
                                                                      style: Body1.apply(
                                                                        fontWeightDelta: -1,
                                                                        color: ss.serviceNum == 0 ?
                                                                            black
                                                                            :
                                                                            third
                                                                      )
                                                                  ),
                                                                )
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:InkWell(
                                                              onTap: () {
                                                                Provider.of<StoreServiceProvider>(context, listen: false).setServiceNum(1, widget.store.id);
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                                                child:Text(
                                                                    "정보",
                                                                    textAlign: TextAlign.center,
                                                                    style: Body1.apply(
                                                                        fontWeightDelta: -1,
                                                                        color: ss.serviceNum == 1 ?
                                                                        black
                                                                            :
                                                                        third
                                                                    )
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:InkWell(
                                                                onTap: () async {
                                                                  await Provider.of<StoreServiceProvider>(context, listen: false).setServiceNum(2, widget.store.id);
                                                                },
                                                                child: Container(
                                                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                                                  child: Text(
                                                                    "리뷰",
                                                                    textAlign: TextAlign.center,
                                                                    style: Body1.apply(
                                                                        fontWeightDelta: -1,
                                                                        color: ss.serviceNum == 2 ?
                                                                        black
                                                                            :
                                                                        third
                                                                    )
                                                                  ),
                                                                )
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),

                                                  Positioned(
                                                    bottom: 0,
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width,
                                                      height: 2,
                                                      color: Color(0xFFF2F2F2),
                                                      child: Stack(
                                                          children: [
                                                            Consumer<StoreServiceProvider>(
                                                              builder: (context, ssp, _){
                                                                return AnimatedPositioned(
                                                                  left: (MediaQuery.of(context).size.width * 1 / 3) * (ssp.serviceNum),
                                                                  child: Container(
                                                                    width: MediaQuery.of(context).size.width * 1 / 3,
                                                                    height: 1,
                                                                    decoration: BoxDecoration(
                                                                      color: mainColor,
                                                                    ),
                                                                  ),
                                                                  duration: Duration(milliseconds: 350),
                                                                );
                                                              },
                                                            )
                                                          ]
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                          );
                                        },
                                        content: Container(
                                          child: (ss.serviceNum == 0) ?
                                          menuForm(context)
                                              :
                                          (ss.serviceNum == 1) ?
                                          otherForm(context, widget.store)
                                              :
                                          reviewForm(context, widget.store),
                                          constraints: BoxConstraints(
                                            minHeight: MediaQuery.of(context).size.height - 85,
                                            minWidth: MediaQuery.of(context).size.width,
                                          ),
                                        ),
                                      );
                                    }
                                )
                              ],
                            )
                        );
                      },
                      itemCount:  1,
                    )
                ),
              ),
            );
          },
        ),
        Consumer<StoreServiceProvider>(
          builder: (context, ss, _){
            return (ss.serviceNum == 0) ?
            Positioned(
                bottom: 0,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    color: white,
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child:
                    RaisedButton(
                        color: mainColor,
                        onPressed: () async {
                          List<BigMenuModel> bigMenus = [];
                          int orderPay = 0;

                          ss.menuList.forEach((menu) {
                            List<MenuModel> menus = menu.menuList.where((m) => m.isCheck).toList();

                            if(menus != null && menus.length != 0) {
                              menus.forEach((m) {
                                m.count = 1;
                                orderPay += m.price;
                              });
                              bigMenus.add(BigMenuModel(
                                  id: menu.id,
                                  name: menu.name,
                                  menuList: menus
                              ));
                            }
                          });

                          if(bigMenus.length != 0) {
                            await ss.setOrderMenu(bigMenus,orderPay);

                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OrderMenu(
                                          name: Provider
                                              .of<UserProvider>(
                                              context,
                                              listen: false)
                                              .loginUser
                                              .name,
                                          store_id: widget.store.id.toString(),
                                          store: widget.store,
                                        )
                                )
                            );
                          } else {
                            showToast("메뉴를 한가지 이상 선택해주세요.");
                          }
                        },
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(
                            "주문하기",
                            style: TextStyle(
                                color: Colors.white
                            )
                        )
                    )
                )
            ) : Container();
          },
        ),
      ],
    );
  }
}