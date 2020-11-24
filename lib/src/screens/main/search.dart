import 'dart:async';

import 'package:cashcook/src/model/place.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/screens/main/searchDetail.dart';
import 'package:cashcook/src/services/Search.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

class SearchPage extends StatefulWidget {
  bool isHome;

  SearchPage({this.isHome = false});

  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  TextEditingController queryCtrl = TextEditingController();

  Timer _debounce;
  int _debouncetime = 700;

  PlaceDetail placeDetail;

  SearchService service = SearchService();

  Location location = Location();

  var currentLocation;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      queryCtrl.addListener(_onSearchChanged);
    });

    super.initState();
  }

  _onSearchChanged() {
    if(_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: _debouncetime), () {
      if(queryCtrl.text != "") {
        print("검색어 있움");
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          var currentLocation =  await location.getLocation();

          String start = (currentLocation.latitude + 0.04).toString() +
              "," +
              (currentLocation.longitude + 0.04).toString();
          String end = (currentLocation.latitude - 0.04).toString() +
              "," +
              (currentLocation.longitude - 0.04).toString();

          await Provider.of<StoreServiceProvider>(context,listen: false).fetchStoreSearch(queryCtrl.text, start, end);
        });
      } else {
        Provider.of<StoreServiceProvider>(context,listen: false).claerSearchStore();
      }
    });
  }

  Widget body(BuildContext context) {
    return SingleChildScrollView(
        child:  Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child:
          Column(
            children: [
              Consumer<StoreServiceProvider>(
                builder: (context, pp, _) {
                  return TextField(
                    cursorColor: Color(0xff000000),
                    style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 16,
                        fontFamily: 'noto',
                        fontWeight: FontWeight.bold
                    ),
                    controller: queryCtrl,
                    autofocus: false,
                    onSubmitted: (value) async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SearchDetail(
                            filter: queryCtrl.text,
                            filterType: "contain",
                          )
                        )
                      );
                    },
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                        color: mainColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: mainColor),
                      ),
                      prefixIcon: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          child: Image.asset(
                            "assets/resource/main/search_blue.png",
                            width: 24,
                            height: 24,
                            color: mainColor,
                          ),
                        ),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          queryCtrl.text = "";
                        },
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          child: Image.asset(
                            "assets/icon/cancle.png",
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              whiteSpaceH(24.0),
              Consumer<StoreServiceProvider>(
                builder: (context, pp, _) {
                  return
                    pp.isLoading ?
                    Center(
                        child: CircularProgressIndicator(
                            backgroundColor: mainColor,
                            valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
                        )
                    )
                    :
                            Column(
                              children:
                            pp.searchStore.length == 0 ?
                              [
                                Text("검색어를 입력해주세요.")
                              ]
                                :
                              pp.searchStore.map((e) =>
                                PlaceItem(e)
                              ).toList(),
                            );
                },
              ),
            ],
          ),
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          elevation: 0,
          leading: widget.isHome ? null : IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Image.asset(
              "assets/resource/public/prev.png",
              width: 24,
              height: 24,
            ),
          ),
          title: Text("검색",
            style: appBarDefaultText,
          ),
          centerTitle: true,
        ),
        body: body(context),
    );
  }

  Widget PlaceItem(StoreModel place) {
    return Consumer<StoreServiceProvider>(
      builder: (context, ssp, _){
        return Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child:
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child:Image.asset(
                    "assets/icon/place.png",
                    height: 24,
                    width: 24,
                    fit: BoxFit.contain,
                  ) ,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => SearchDetail(
                                filter: place.store.name,
                                filterType: "none",
                              )
                          )
                      );
                    },
                    child: Text(
                        place.store.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 14,
                            fontFamily: 'noto',
                            fontWeight: FontWeight.w500
                        )
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
