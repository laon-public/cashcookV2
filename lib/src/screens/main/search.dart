import 'dart:async';

import 'package:cashcook/src/model/place.dart';
import 'package:cashcook/src/provider/PlaceProvider.dart';
import 'package:cashcook/src/services/Search.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  TextEditingController queryCtrl = TextEditingController();

  Timer _debounce;
  int _debouncetime = 700;

  PlaceDetail placeDetail;

  SearchService service = SearchService();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PlaceProvider>(context, listen: false).clearPlace();
      queryCtrl.addListener(_onSearchChanged);
    });

    super.initState();
  }

  _onSearchChanged() {
    if(_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: _debouncetime), () {
      print("끝남");
      if(queryCtrl.text != "") {
        print("검색어 있움");
        Provider.of<PlaceProvider>(context, listen: false).queryRoute(queryCtrl.text);
        // Provider.of<PlaceProvider>(context,listen: false).fetchStoreSearch(queryCtrl.text);
        // Provider.of<PlaceProvider>(context,listen: false).fetchGoogleSearch(queryCtrl.text);
      } else {
        Provider.of<PlaceProvider>(context, listen: false).clearPlace();
      }
    });
  }

  Widget body(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.only(top: 30.0),
        child:  Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child:
          Column(
            children: [
              Consumer<PlaceProvider>(
                builder: (context, pp, _) {
                  return TextFormField(
                    cursorColor: Color(0xff000000),
                    style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 16,
                        fontFamily: 'noto',
                        fontWeight: FontWeight.bold
                    ),
                    controller: queryCtrl,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: pp.queryType == "google" ?
                      "장소를 입력해주세요."
                          :
                      "매장명을 입력해주세요."
                      ,
                      prefixIcon: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: EdgeInsets.all(12.0),
                            width: 16,
                            height: 16,
                            child: Image.asset(
                              "assets/resource/public/prev.png",
                              width: 16,
                              height: 16,
                            ),
                          )
                      ),
                      suffixIcon: InkWell(
                          onTap: () {
                            queryCtrl.text = "";
                          },
                          child: Container(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                                "취소",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                  fontFamily: 'noto',
                                )
                            ),
                          )
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  );
                },
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: mainColor
              ),
              Consumer<PlaceProvider>(
                builder: (context, pp, _){
                  return Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 15.0, right: 15.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            RaisedButton(
                              onPressed: (pp.queryType == "google") ? null : () {
                                pp.setQueryType("google");
                              },
                              color: white,
                              disabledColor: white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(color: (pp.queryType == "google") ? mainColor : Color(0xFF999999))
                              ),
                              child:
                              Text(
                                "장소검색",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: (pp.queryType == "google") ? mainColor : Color(0xFF999999)
                                ),
                              ),
                            ),
                            whiteSpaceW(10),
                            RaisedButton(
                              onPressed: (pp.queryType == "store") ? null : () {
                                pp.setQueryType("store");
                              },
                              color: white,
                              disabledColor: white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(color: (pp.queryType == "store") ? mainColor : Color(0xFF999999))
                              ),
                              child:
                              Text(
                                "매장검색",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: (pp.queryType == "store") ? mainColor : Color(0xFF999999)
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 20.0, left: 15.0, right: 15.0),
                  child:
                  Row(
                    children: [
                      Text("검색결과",
                          style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 16,
                              fontFamily: 'noto',
                              fontWeight: FontWeight.bold
                          )),
                    ],
                  )
              ),
              Consumer<PlaceProvider>(
                builder: (context, pp, _) {
                  return Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child:
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
                      pp.placeList.map((e) =>
                          PlaceItem(e)
                      ).toList(),
                    ),
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
        body: SafeArea(top: false, child: body(context)),
    );
  }

  Widget PlaceItem(Place place) {
    return
      Padding(
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
                    "assets/icon/grey_mk.png",
                    height: 24,
                    width: 24,
                    fit: BoxFit.contain,
                  ) ,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if(place.type == "store") {
                        Navigator.of(context).pop({
                          "lat" : place.pd.lat,
                          "lng" : place.pd.lng,
                        });
                      } else {
                         PlaceDetail pd = await service.getPlaceDetail(place.placeId);
                         Navigator.of(context).pop({
                           "lat" : pd.lat,
                           "lng" : pd.lng,
                         });
                      }
                    },
                    child: Text(
                        place.description,
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
  }
}
