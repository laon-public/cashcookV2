import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/provider/CarouselProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/screens/main/storeDetail.dart';
import 'package:cashcook/src/screens/main/storeDetail_2.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Widget storeMiniItem(StoreMinify store, BuildContext context) {
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
          imageUrl: store.store_img,
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
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(store.store_name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'noto',
                        color: Color(0xFF333333),
                      )
                  ),
                  whiteSpaceW(5),
                  store.deliveryStatus ?
                  Container(
                    width: 23,
                    height: 14,
                    child: Center(
                      child:Text("포장",
                        style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 8,
                            color: white),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xFF55BBFF),
                        borderRadius: BorderRadius.all(Radius.circular(50.0))
                    ),
                  )
                      :
                  Text(""),
                  Spacer(),
                  Consumer<StoreServiceProvider>(
                    builder: (context, ssp, _){
                      return store.scrap == "1" ?
                      InkWell(
                        onTap: () async {
                          await Provider.of<StoreServiceProvider>(context, listen:false).cancleScrap(store.id);
                        },
                        child: Image.asset(
                          "assets/resource/main/steam-color.png",
                          width: 20,
                          height: 20,
                        ),
                      )
                          :
                      InkWell(
                        onTap: () async {
                          await Provider.of<StoreServiceProvider>(context, listen:false).doScrap(store.id.toString());
                        },
                        child: Image.asset(
                          "assets/resource/main/steam.png",
                          width: 20,
                          height: 20,
                        ),
                      );
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/icon/star_full_color.png",
                    width: 12,
                    height: 12,
                  ),
                  whiteSpaceW(2.0),
                  Text(
                    "${NumberFormat("#.#").format(store.store_scope)}",
                    style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'noto',
                        color: Color(0xFF666666)
                    ),
                  ),
                  Text(" · ",
                      style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'noto',
                          color: Color(0xFF666666)
                      )
                  ),
                  Text(
                    "DL ",
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'noto',
                      color: Color(0xFFFFBC2C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    (store.store_dl == 0) ? " 결제한도가 없습니다." : "${store.store_dl}%",
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
                  Text(store.store_description,
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
                  Text("${store.store_cat} / ${store.store_sub_cat} ",
                    style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'noto',
                        color: Color(0xFFFFAA00),
                        fontWeight: FontWeight.w600
                    ),),
                  whiteSpaceW(10.0),
                  store.deliveryStatus ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("배달 ",
                          style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'noto',
                              color: Color(0xFF666666)
                          )
                      ),
                      Image.asset(
                        "assets/icon/time-dark.png",
                        width: 12,
                        height: 12,
                      ),
                      Text("${store.deliveryTime}",
                          style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'noto',
                              color: Color(0xFF666666)
                          )
                      )
                    ],
                  )
                  :
                  Text("배달없음",
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
                  (store.minOrderAmount == null) ?
                  Text("최소주문금액 없음",
                      style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'noto',
                          color: Color(0xFF666666)
                      )
                  )
                      :
                  Text("최소주문 ${store.minOrderAmount}원",
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
        )
      ],
    ),
  );
}

Widget storeItem(StoreModel store, BuildContext context) {
  return InkWell(
    onTap: () async {
      await Provider.of<StoreServiceProvider>(
          context, listen: false).setServiceNum(
          0, store.id);
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => StoreDetail(
      //       store: store,
      //     )
      //   )
      // );
      await Provider.of<CarouselProvider>(context, listen:false).changePage(1);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => StoreDetail2(
            store: store,
          )
        )
      );
    },
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(16.0),
      height: 120,
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
                    border: Border.all(
                      color: Color(0xFFDDDDDD),
                      width: 1,
                    ),
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
          Expanded(
            child: Column(
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
                      width: 23,
                      height: 14,
                      child: Center(
                        child:Text("포장",
                          style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 8,
                              color: white),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Color(0xFF55BBFF),
                          borderRadius: BorderRadius.all(Radius.circular(50.0))
                      ),
                    )
                        :
                    Text(""),
                    Spacer(),
                    Consumer<StoreServiceProvider>(
                      builder: (context, ssp, _){
                        return store.scrap.scrap == "1" ?
                        InkWell(
                          onTap: () async {
                            await Provider.of<StoreServiceProvider>(context, listen:false).cancleScrap(store.id);
                          },
                          child: Image.asset(
                            "assets/resource/main/steam-color.png",
                            width: 20,
                            height: 20,
                          ),
                        )
                            :
                        InkWell(
                          onTap: () async {
                            await Provider.of<StoreServiceProvider>(context, listen:false).doScrap(store.id.toString());
                          },
                          child: Image.asset(
                            "assets/resource/main/steam.png",
                            width: 20,
                            height: 20,
                          ),
                        );
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/icon/star_full_color.png",
                      width: 12,
                      height: 12,
                    ),
                    whiteSpaceW(2.0),
                    Text(
                      "${NumberFormat("#.#").format(store.store.scope)}",
                      style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'noto',
                          color: Color(0xFF666666)
                      ),
                    ),
                    Text(" · ",
                        style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'noto',
                            color: Color(0xFF666666)
                        )
                    ),
                    Text(
                      "DL ",
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'noto',
                        color: Color(0xFFFFBC2C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      (store.store.limitDL == null) ? " 결제한도가 없습니다." : "${store.store.limitDL}%",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("배달 ",
                            style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'noto',
                                color: Color(0xFF666666)
                            )
                        ),
                        Image.asset(
                          "assets/icon/time-dark.png",
                          width: 12,
                          height: 12,
                        ),
                        Text("${store.store.deliveryTime}",
                            style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'noto',
                                color: Color(0xFF666666)
                            )
                        )
                      ],
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
          )
        ],
      ),
    ),
  );
}