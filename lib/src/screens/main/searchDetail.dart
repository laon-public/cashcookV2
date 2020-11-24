import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/widgets/StoreItem.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/colors.dart';

class SearchDetail extends StatefulWidget {
  final String filter;
  final String filterType;

  SearchDetail({this.filter, this.filterType});

  @override
  _SearchDetail createState() => _SearchDetail();
}

class _SearchDetail extends State<SearchDetail> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
                        padding: EdgeInsets.symmetric(horizontal: 6.0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Image.asset(
                                "assets/resource/public/prev.png",
                                width: 24,
                                height: 24,
                              ),
                            ),
                            whiteSpaceW(8),
                            Image.asset(
                              "assets/resource/main/search_blue.png",
                              width: 24,
                              height: 24,
                              color: mainColor,
                            ),
                            whiteSpaceW(8),
                            Text(
                              widget.filter,
                              style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'noto'
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                                child: Consumer<StoreServiceProvider>(
                                  builder: (context, ssp, _){
                                    return
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        child:
                                        Column(
                                          children: ssp.searchStore.map((e) =>
                                          (widget.filterType == "none") ?
                                          (e.store.name != widget.filter) ?
                                              Container()
                                              :
                                              storeItem(e, context)
                                              :
                                          (!e.store.name.contains(widget.filter)) ?
                                            Container()
                                                :
                                            storeItem(e, context)
                                          ).toList() ,
                                        ),
                                      );
                                  },
                                ),
                          )
              ],
            )
        )
            ]
    ),
        )
    );
  }
}