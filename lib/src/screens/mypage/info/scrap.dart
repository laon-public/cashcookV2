import 'package:cashcook/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/model/scrap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/widgets/whitespace.dart';

class Scrap extends StatefulWidget {
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
    );
  }

  Widget body(context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<StoreServiceProvider>(context, listen: false).readScrap();
    });
    return SingleChildScrollView(
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
          )
        ],
      ),
    );
  }
}