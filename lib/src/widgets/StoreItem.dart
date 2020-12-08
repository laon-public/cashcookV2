import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/provider/CarouselProvider.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/screens/main/storeDetail_3.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
                      style: Body1,
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
                            fontSize: 10,
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
                          color: primary
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
                    color: mainColor,
                  ),
                  whiteSpaceW(2.0),
                  Text(
                    "${NumberFormat("#.#").format(store.store_scope)}",
                    style: Caption
                  ),
                  Text(" · ",
                      style: Caption
                  ),
                  Text(
                    "DL ",
                    style: Caption
                  ),
                  Text(
                    (store.store_dl == 0) ? " 결제한도가 없습니다." : "${store.store_dl}%",
                    style: Caption.apply(color: secondary),
                  ),
                ],
              ),
              whiteSpaceH(4.0),
              Row(
                children: [
                  Text(store.store_description,
                    style: Body2,),
                ],
              ),
              whiteSpaceH(4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${store.store_cat} / ${store.store_sub_cat} ",
                    style: Caption.apply(color: mainColor),),
                  whiteSpaceW(10.0),
                  store.deliveryStatus ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("배달 ",
                          style: Caption.apply(color: secondary)
                      ),
                      Image.asset(
                        "assets/icon/time-dark.png",
                        width: 12,
                        height: 12,
                      ),
                      Text("${store.deliveryTime}",
                          style: Caption.apply(color: secondary)
                      )
                    ],
                  )
                  :
                  Text("배달없음",
                      style: Caption.apply(color: secondary)
                  ),
                  Text(" · ",
                      style: Caption.apply(color: secondary)
                  ),
                  (store.minOrderAmount == null) ?
                  Text("최소주문금액 없음",
                      style: Caption.apply(color: secondary)
                  )
                      :
                  Text("최소주문 ${store.minOrderAmount}원",
                      style: Caption.apply(color: secondary)
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
      await Provider.of<CarouselProvider>(context, listen:false).changePage(1);
      await Provider.of<StoreProvider>(context, listen: false).setAppbar(false);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => StoreDetail3(
            store:store
          )
        )
      );
    },
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 68,
            height: 68,
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
                    store.store.shop_img1,
                  ),
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
                        style: Body1.apply(
                          fontWeightDelta: 1
                        )
                    ),
                    whiteSpaceW(5),
                    (store.store.deliveryTime != null) ?
                    Image.asset(
                      "assets/icon/isPacking.png",
                      width: 27,
                      height: 14,
                    )
                        :
                    Text(""),
                    whiteSpaceW(4),
                    (store.store.deliveryTime != null) ?
                    Image.asset(
                      "assets/icon/isDelivery.png",
                      width: 27,
                      height: 14,
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
                            color: primary
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
                      color: etcYellow
                    ),
                    whiteSpaceW(2.0),
                    Text(
                      "${NumberFormat("#.#").format(store.store.scope)}",
                      style: Caption.apply(color: secondary),
                    ),
                    Text(" · ",
                        style: Caption.apply(color: secondary)
                    ),
                    Text(
                      "DL ",
                      style: Caption.apply(color: etcYellow, fontWeightDelta: 1),
                    ),
                    Text(
                      (store.store.limitDL == null) ? " 결제한도가 없습니다." :
                      (store.store.limitType == "PERCENTAGE") ?
                      "${store.store.limitDL}%"
                      :
                      "${numberFormat.format(int.parse(store.store.limitDL))}DL",
                      style: Caption.apply(color: secondary),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(store.store.short_description,
                      style: Body2,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${store.store.category_name} / ${store.store.category_sub_name}",
                      style: Caption.apply(color: mainColor),),
                    whiteSpaceW(10.0),
                    (store.store.deliveryTime == null) ?
                    Text("배달없음",
                        style: Caption.apply(color: secondary)
                    )
                        :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("배달 ",
                            style: Caption.apply(color: secondary)
                        ),
                        Image.asset(
                          "assets/icon/time-dark.png",
                          width: 12,
                          height: 12,
                          color: secondary
                        ),
                        Text("  ${store.store.deliveryTime}",
                            style: Caption.apply(color: secondary)
                        )
                      ],
                    ),
                    Text(" · ",
                        style: Caption.apply(color: secondary)
                    ),
                    (store.store.minOrderAmount == null) ?
                    Text("최소주문금액 없음",
                        style: Caption.apply(color: secondary)
                    )
                        :
                    Text("최소주문 ${store.store.minOrderAmount}원",
                        style: Caption.apply(color: secondary)
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

Widget storeItemRow(StoreModel store, BuildContext context) {
  return InkWell(
    onTap: () async {
      await Provider.of<StoreServiceProvider>(
          context, listen: false).setServiceNum(
          0, store.id);
      await Provider.of<CarouselProvider>(context, listen:false).changePage(1);
      await Provider.of<StoreProvider>(context, listen: false).setAppbar(false);
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => StoreDetail3(
                  store:store
              )
          )
      );
    },
    child: Container(
      width: MediaQuery.of(context).size.width * 3 / 4,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 68,
            height: 68,
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
                    store.store.shop_img1,
                  ),
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
                        style: Body1.apply(
                            fontWeightDelta: 1
                        )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/icon/star_full_color.png",
                        width: 12,
                        height: 12,
                        color: etcYellow
                    ),
                    whiteSpaceW(2.0),
                    Text(
                      "${NumberFormat("#.#").format(store.store.scope)}",
                      style: Caption.apply(color: secondary),
                    ),
                    Text(" · ",
                        style: Caption.apply(color: secondary)
                    ),
                    Text(
                      "DL ",
                      style: Caption.apply(color: etcYellow, fontWeightDelta: 1),
                    ),
                    Text(
                      (store.store.limitDL == null) ? "100%" : "${store.store.limitDL}%",
                      style: Caption.apply(color: secondary),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${store.store.category_name} / ${store.store.category_sub_name}",
                      style: Caption.apply(color: mainColor),),
                    whiteSpaceW(10.0),
                    (store.store.deliveryTime == null) ?
                    Text("배달없음",
                        style: Caption.apply(color: secondary)
                    )
                        :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("배달 ",
                            style: Caption.apply(color: secondary)
                        ),
                        Image.asset(
                            "assets/icon/time-dark.png",
                            width: 12,
                            height: 12,
                            color: secondary
                        ),
                        Text("  ${store.store.deliveryTime}",
                            style: Caption.apply(color: secondary)
                        )
                      ],
                    ),
                  ],
                ),
                whiteSpaceH(6),
                Row(
                  children: [
                    (store.store.deliveryTime != null) ?
                    Image.asset(
                      "assets/icon/isPacking.png",
                      width: 27,
                      height: 14,
                    )
                        :
                    Text(""),
                    whiteSpaceW(4),
                    (store.store.deliveryTime != null) ?
                    Image.asset(
                      "assets/icon/isDelivery.png",
                      width: 27,
                      height: 14,
                    )
                        :
                    Text(""),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}