import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/screens/main/storeDetail_3.dart';
import 'package:cashcook/src/utils/CustomBottomNavBar.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

class Scrap extends StatefulWidget {
  bool isHome;

  Scrap({this.isHome = false});

  @override
  _Scrap createState() => _Scrap();
}
class _Scrap extends State<Scrap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("찜 매장",
            style: appBarDefaultText),
        leading: widget.isHome ? null : IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
        ),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: SafeArea(top: false, child: body(context)),
    );
  }

  Widget body(context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<StoreServiceProvider>(context, listen: false).readScrap();
    });
    return Stack(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child:
            Container(
              padding: EdgeInsets.only(bottom: 65),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Consumer<StoreServiceProvider>(
                  builder: (context, sp, _) {
                    return (sp.isLoading) ?
                    Center(
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(primary)
                        )
                    )
                        :
                    SingleChildScrollView(
                      child: Column(
                          children:
                          sp.scrapList.map((e) =>
                              scrapItem(e)
                          ).toList()
                      )
                    );
                  }
              ),
            )
        ),
        widget.isHome ? CustomBottomNavBar(context, "scrap") : Container()
      ],
    );
  }

  Widget scrapItem(StoreModel scrap) {
    return InkWell(
      onTap: () async {
        await Provider.of<StoreServiceProvider>(
            context, listen: false).setServiceNum(
            0, scrap.id);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StoreDetail3(
            store: scrap,
          )
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFF7F7F7),
              width: 1
            )
          )
        ),
        padding: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
                      scrap.store.shop_img1,
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
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(scrap.store.name,
                                    style: Body1.apply(
                                        fontWeightDelta: 1
                                    )
                                ),
                                whiteSpaceW(5),
                                (scrap.store.deliveryTime != null) ?
                                Image.asset(
                                  "assets/icon/isPacking.png",
                                  width: 27,
                                  height: 14,
                                )
                                    :
                                Text(""),
                                whiteSpaceW(4),
                                (scrap.store.deliveryTime != null) ?
                                Image.asset(
                                  "assets/icon/isDelivery.png",
                                  width: 27,
                                  height: 14,
                                )
                                    :
                                Text(""),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset("assets/icon/star_full_color.png",
                                    width: 12,
                                    height: 12,
                                    color: etcYellow
                                ),
                                whiteSpaceW(2.0),
                                Text(
                                  "${NumberFormat("#.#").format(scrap.store.scope)}",
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
                                  (scrap.store.limitDL == null) ? " 결제한도가 없습니다." :
                                  (scrap.store.limitType == "PERCENTAGE") ?
                                  "${scrap.store.limitDL}%"
                                      :
                                  "${numberFormat.format(int.parse(scrap.store.limitDL))}DL",
                                  style: Caption.apply(color: secondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Provider.of<StoreServiceProvider>(context, listen: false).cancleScrap(scrap.id);
                        },
                        child: Image.asset(
                          "assets/resource/public/close.png",
                          width: 20,
                          height: 20,
                          color: black,
                        ),
                      )
                    ],
                  ),
                  Text(scrap.store.short_description,
                    style: Body2,
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${scrap.store.category_name} / ${scrap.store.category_sub_name}",
                        style: Caption.apply(color: mainColor),),
                      whiteSpaceW(10.0),
                      (scrap.store.deliveryTime == null) ?
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
                          Text("  ${scrap.store.deliveryTime}",
                              style: Caption.apply(color: secondary)
                          )
                        ],
                      ),
                      Text(" · ",
                          style: Caption.apply(color: secondary)
                      ),
                      (scrap.store.minOrderAmount == null) ?
                      Text("최소주문금액 없음",
                          style: Caption.apply(color: secondary)
                      )
                          :
                      Text("최소주문 ${scrap.store.minOrderAmount}원",
                          style: Caption.apply(color: secondary)
                      )
                      ,
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
}