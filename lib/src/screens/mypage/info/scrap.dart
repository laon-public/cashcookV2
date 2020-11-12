import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/CustomBottomNavBar.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/model/scrap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/widgets/whitespace.dart';

class Scrap extends StatefulWidget {
  bool isHome;

  Scrap({this.isHome = false});

  @override
  _Scrap createState() => _Scrap();
}
class _Scrap extends State<Scrap> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("찜한매장",
            style: TextStyle(
                fontSize: 14,
                fontFamily: 'noto',
                color: black,
                fontWeight: FontWeight.w600
            )),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: SafeArea(top: false, child: body(context)),
    ),
        onWillPop: ExitPressed
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
                              backgroundColor: mainColor,
                              valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
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

  Widget scrapItem(ScrapModel scrap) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
            Expanded(
              flex: 1,
              child: CachedNetworkImage(
                imageUrl: scrap.img,
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
                        Text(scrap.name,
                          style: TextStyle(
                            color: Color(0xFF444444),
                            fontSize: 14,
                            fontFamily: 'noto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        whiteSpaceW(10),
                        Text(scrap.cat_name + "/" + scrap.sub_cat_name,
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 12,
                              fontFamily: 'noto'
                          ),
                        ),
                      ],
                    ),
                    Text(scrap.description,
                      style: TextStyle(
                        fontFamily: 'noto',
                        fontSize: 12,
                        color: Color(0xFF888888)
                      )
                    )
                  ],
                )
            )
          ),
          Row(
              children: [
                InkWell(
                  onTap: () async {
                    await Provider.of<StoreProvider>(context, listen: false).clearMap();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => MainMap(
                          lat: scrap.lat,
                          lon: scrap.lng,
                        )
                      ),
                        (route) => false
                    );
                  },
                  child: Image.asset(
                    "assets/icon/grey_mk.png",
                    width: 36,
                    height: 36,
                    fit: BoxFit.fill,
                  ),
                ),
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
    );
  }

  Future<bool> ExitPressed() {
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
}