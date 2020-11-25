import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/screens/main/storeDetail_3.dart';
import 'package:cashcook/src/utils/CustomBottomNavBar.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        title: Text("찜한매장",
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
        SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child:
              Container(
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
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children:
                          sp.scrapList.map((e) =>
                              scrapItem(e)
                          ).toList()
                      );
                    }
                ),
              )
          ),
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
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CachedNetworkImage(
                imageUrl: scrap.store.shop_img1,
                fit: BoxFit.fill,
                width: 64,
                height: 64,
              ),
            ),
            whiteSpaceW(10),
            Expanded(
                flex: 4,
                child:Container(
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(scrap.store.name,
                              style: Body1,
                            ),
                            whiteSpaceW(10),
                            Text(scrap.store.category_name + "/" + scrap.store.category_sub_name,
                              style: Caption.apply(
                                color: primary
                              ),
                            ),
                          ],
                        ),
                        Text(scrap.store.short_description,
                            style: Body2.apply(
                              color: secondary
                            )
                        )
                      ],
                    )
                )
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Provider.of<StoreServiceProvider>(context, listen: false).cancleScrap(scrap.id);
                  },
                  child: Image.asset(
                    "assets/icon/delete.png",
                    width: 48,
                    height: 48,
                    color: black,
                    fit: BoxFit.fill,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}