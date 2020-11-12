import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/qr/qr.dart';
import 'package:cashcook/src/screens/storemanagement/orderMenu.dart';
import 'package:cashcook/src/utils/Share.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/StoreServiceItem.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreDetail extends StatefulWidget {
  final StoreModel store;

  StoreDetail({this.store});

  @override
  _StoreDetail createState() => _StoreDetail();
}

class _StoreDetail extends State<StoreDetail> {
  @override
  Widget build(BuildContext context) {
    UserCheck my = Provider.of<UserProvider>(context, listen: false).loginUser;

    // TODO: implement build
    return Stack(
      children: [
        Scaffold(
            backgroundColor: white,
            appBar: AppBar(
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
              elevation: 0,
            ),
            body: Container(
                child:
                SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: widget.store.store.shop_img1,
                                  imageBuilder: (context, img) => Container(
                                      width: 64,
                                      height: 64,
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
                                whiteSpaceW(10),
                                Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          children: <Widget>[
                                            Text(
                                              widget.store.store.name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: Color(0xFF444444),
                                                  fontFamily: 'noto'),
                                            ),
                                            whiteSpaceW(15),
                                            Text(
                                              "${widget.store.store.category_name} / ${widget.store.store.category_sub_name}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w100,
                                                  fontSize: 12,
                                                  color: mainColor,
                                                  fontFamily: 'noto'),
                                            )
                                          ]
                                      ),
                                      whiteSpaceH(10),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            widget.store.store.short_description,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w100,
                                                fontSize: 12,
                                                color: Color(0xFF888888),
                                                fontFamily: 'noto'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                Spacer(),
                                my.id.toString() == widget.store.user_id ?
                                Container(
                                  width: 56,
                                  height: 32,
                                  child: RaisedButton(
                                    onPressed: () {},
                                    color: white,
                                    elevation: 0,
                                    child: Text("수정",
                                      style: TextStyle(
                                        fontFamily: 'noto',
                                        fontSize: 12,
                                        color: Color(0xFF333333),
                                        fontWeight: FontWeight.w400
                                      )
                                    ),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Color(0xFFDDDDDD),
                                        ),
                                        borderRadius: BorderRadius.circular(20)),
                                  ),
                                ) :
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => Qr(),
                                          settings: RouteSettings(
                                              arguments: widget.store.id
                                          )),);
                                  },
                                  child: Image.asset(
                                    "assets/resource/map/qr.png",
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Consumer<StoreServiceProvider>(
                            builder: (context, ss, _) {
                              return ss.serviceNum == 0 ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children:[
                                    whiteSpaceH(15),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RaisedButton(
                                            onPressed: () async {
                                              await ss.doScrap(
                                                  widget.store.id.toString()
                                              );
                                            },
                                            color: white,
                                            disabledColor: white,
                                            elevation: 0.0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20.0),
                                                side: BorderSide(color: mainColor)
                                            ),
                                            child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/icon/star_blue.png",
                                                  width: 20,
                                                  height: 20,
                                                  color: mainColor,
                                                ),
                                                whiteSpaceW(2.0),
                                                Text(
                                                  "찜하기",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: mainColor,
                                                      fontFamily: 'noto',
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        whiteSpaceW(7.0),
                                        Expanded(
                                          child: RaisedButton(
                                            onPressed: () async {
                                              onKakaoStoreShare(widget.store.store.name, widget.store.store.shop_img1, widget.store.store.short_description);
                                            },
                                            color: white,
                                            disabledColor: white,
                                            elevation: 0.0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20.0),
                                                side: BorderSide(color: mainColor)
                                            ),
                                            child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/icon/share_blue.png",
                                                  width: 20,
                                                  height: 20,
                                                  color: mainColor,
                                                ),
                                                whiteSpaceW(2.0),
                                                Text(
                                                  "공유하기",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: mainColor,
                                                      fontFamily: 'noto',
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        whiteSpaceW(7.0),
                                        Expanded(
                                          child: RaisedButton(
                                            onPressed: () async {
                                              launch("tel://" + widget.store.store.tel);
                                            },
                                            color: white,
                                            disabledColor: white,
                                            elevation: 0.0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20.0),
                                                side: BorderSide(color: mainColor)
                                            ),
                                            child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/icon/tel_blue.png",
                                                  width: 20,
                                                  height: 20,
                                                  color: mainColor,
                                                ),
                                                whiteSpaceW(2.0),
                                                Text(
                                                  "연락처",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: mainColor,
                                                      fontFamily: 'noto',
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]
                              ) : Container();
                            },
                          ),
                        ),
                        whiteSpaceH(10),
                        Consumer<StoreServiceProvider>(
                          builder: (context, ss, _){
                            return (ss.serviceNum == 0) ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child:
                                        InkWell(
                                          onTap: () {

                                          },
                                          child: CachedNetworkImage(
                                            imageUrl: widget.store.store.shop_img1,
                                            fit: BoxFit.fill,
                                            width: MediaQuery.of(context).size.width/3.5,
                                            height: 130,
                                          ),
                                        ),
                                      ),
                                      whiteSpaceW(5),
                                      Expanded(
                                        child:
                                        InkWell(
                                          onTap: () {
                                            // showBigImage(sp.selStore.store.shop_img2);
                                          },
                                          child: CachedNetworkImage(
                                            imageUrl: widget.store.store.shop_img2,
                                            fit: BoxFit.fill,
                                            width: MediaQuery.of(context).size.width/3.5,
                                            height: 130,
                                          ),
                                        ),
                                      ),
                                      whiteSpaceW(5),
                                      Expanded(
                                        child:
                                        InkWell(
                                          onTap: () {
                                            // showBigImage(sp.selStore.store.shop_img3);
                                          },
                                          child: CachedNetworkImage(
                                            imageUrl: widget.store.store.shop_img3,
                                            fit: BoxFit.fill,
                                            width: MediaQuery.of(context).size.width/3.5,
                                            height: 130,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  whiteSpaceH(15),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        widget.store.store.description,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w100,
                                            fontSize: 14,
                                            color: Color(0xFF888888),
                                            fontFamily: 'noto'),
                                      ),
                                    ],
                                  ),
                                  whiteSpaceH(15),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex:1,
                                        child:Text(
                                          "연락처",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w100,
                                              fontSize: 12,
                                              color: Color(0xFF888888),
                                              fontFamily: 'noto'),
                                        ),
                                      ),
                                      Expanded(
                                        flex:3,
                                        child:Text(
                                          widget.store.store.tel,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 12,
                                              color: black,
                                              fontFamily: 'noto'),
                                        ),
                                      )
                                    ],
                                  ),
                                  whiteSpaceH(2),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex:1,
                                        child:Text(
                                          "영업시간",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w100,
                                              fontSize: 12,
                                              color: Color(0xFF888888),
                                              fontFamily: 'noto'),
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
                                        child:Text(
                                          widget.store.store.store_time,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 12,
                                              color: black,
                                              fontFamily: 'noto'),
                                        ),
                                      )
                                    ],
                                  ),
                                  whiteSpaceH(2),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex:1,
                                        child:Text(
                                          "주소",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w100,
                                              fontSize: 12,
                                              color: Color(0xFF888888),
                                              fontFamily: 'noto'),
                                        ),
                                      ),
                                      Expanded(
                                        flex:3,
                                        child:Text(
                                          "${widget.store.address.address} ${widget.store.address.detail}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 12,
                                              color: black,
                                              fontFamily: 'noto'),
                                        ),
                                      )
                                    ],
                                  ),
                                  whiteSpaceH(2),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex:1,
                                        child:Text(
                                          "BZA 결제한도",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w100,
                                              fontSize: 12,
                                              color: Color(0xFF888888),
                                              fontFamily: 'noto'),
                                        ),
                                      ),
                                      Expanded(
                                        flex:3,
                                        child:Text(
                                          widget.store.store.limitDL == null?
                                          "결제한도가 없습니다." : "${widget.store.store.limitDL}% BZA",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 12,
                                              color: black,
                                              fontFamily: 'noto'),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ) : Container();
                          },
                        ),
                        Consumer<StoreServiceProvider>(
                          builder: (context, ss, _){
                            return ss.serviceNum == 0 ?
                            whiteSpaceH(50.0)
                                :
                            Container();
                          },
                        ),
                        Consumer<StoreServiceProvider>(
                          builder: (context, ss, _){
                            return Container(
                              padding: EdgeInsets.only(right: 16, left: 16),
                              child: Row(
                                  children: [
                                    Expanded(
                                      child:InkWell(
                                          onTap: () async {
                                            await Provider.of<StoreServiceProvider>(context, listen: false).setServiceNum(0, widget.store.id);
                                          },
                                          child: Container(
                                            height: 30,
                                            child:Text(
                                                "상품정보",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'noto',
                                                    color: ss.serviceNum == 0 ?
                                                    mainColor
                                                        :
                                                    Color(0xFF444444)
                                                )
                                            ),
                                            decoration: ss.serviceNum == 0 ? BoxDecoration(
                                                border: Border(bottom: BorderSide(color: mainColor, width: 4.0))
                                            ): BoxDecoration(),
                                          )
                                      ),
                                    ),
                                    Expanded(
                                      child:InkWell(
                                          onTap: () async {
                                            await Provider.of<StoreServiceProvider>(context, listen: false).setServiceNum(1, widget.store.id);
                                          },
                                          child: Container(
                                            height: 30,
                                            child: Text(
                                              "매장리뷰",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'noto',
                                                  color: ss.serviceNum == 1 ?
                                                  mainColor
                                                      :
                                                  Color(0xFF444444)
                                              ),
                                            ),
                                            decoration: ss.serviceNum == 1 ? BoxDecoration(
                                                border: Border(bottom: BorderSide(color: mainColor, width: 4.0))
                                            ): BoxDecoration(),
                                          )
                                      ),
                                    ),
                                    Expanded(
                                      child:InkWell(
                                        onTap: () {
                                          Provider.of<StoreServiceProvider>(context, listen: false).setServiceNum(2, widget.store.id);
                                        },
                                        child: Container(
                                          height: 30,
                                          child:Text(
                                              "매장정보",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'noto',
                                                  color: ss.serviceNum == 2 ?
                                                  mainColor
                                                      :
                                                  Color(0xFF444444)
                                              )
                                          ),
                                          decoration: ss.serviceNum == 2 ? BoxDecoration(
                                              border: Border(bottom: BorderSide(color: mainColor, width: 4.0))
                                          ): BoxDecoration(),
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                            );
                          },
                        ),
                        Consumer<StoreServiceProvider>(
                          builder: (context, ss, _){
                            return Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children:[
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: (ss.serviceNum == 0) ? 12 : 1,
                                      color: Color(0xFFEEEEEE)
                                  ),
                                  Consumer<StoreServiceProvider>(
                                      builder: (context, ss, _) {
                                        return (ss.serviceNum == 0) ?
                                        menuForm(context)
                                            :
                                        (ss.serviceNum == 1) ?
                                        reviewForm(context, widget.store)
                                            :
                                        otherForm(context, widget.store);
                                      }
                                  )
                                ]
                            );
                          },
                        ),
                        whiteSpaceH(50.0)
                      ],
                    )
                )
            )
        ),
        Consumer<StoreServiceProvider>(
          builder: (context, ss, _){
            return (ss.serviceNum == 0) ?
            Positioned(
                bottom: 0,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
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
                                    store_id: widget.store.user_id.toString(),
                                  store: widget.store,
                                )
                              )
                            );
                          } else {
                            showToast("메뉴를 한가지 이상 선택해주세요.");
                          }
                        },
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
        )
      ],
    );
  }
}