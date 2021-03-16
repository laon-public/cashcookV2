import 'dart:async';

import 'package:cashcook/src/model/place.dart';
import 'package:cashcook/src/provider/PlaceProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchAddress extends StatefulWidget {
  final String initQuery;

  SearchAddress({this.initQuery});

  @override
  _SearchAddress createState() => _SearchAddress();
}

class _SearchAddress extends State<SearchAddress> {
  TextEditingController queryCtrl = TextEditingController();

  Timer _debounce;
  int _debouncetime = 750;

  _onSearchChanged() {
    if(_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: _debouncetime), () {
      if(queryCtrl.text != "") {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          Provider.of<PlaceProvider>(context, listen: false).fetchPlaceSearch(queryCtrl.text);
        });
      } else {
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      queryCtrl.addListener(_onSearchChanged);
      if(widget.initQuery != "") {
        Provider.of<PlaceProvider>(context, listen: false).fetchPlaceSearch(widget.initQuery.split("대한민국 ")[1].split(" ")[1] // 구
          + " "
            + widget.initQuery.split("대한민국 ")[1].split(" ")[2] // 동
        );
        queryCtrl.text = widget.initQuery.split("대한민국 ")[1].split(" ")[1] // 구
            + " "
            + widget.initQuery.split("대한민국 ")[1].split(" ")[2]; // 동
      } else {
        Provider.of<PlaceProvider>(context, listen: false).clearPlaces();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text("주소 설정",
            style: appBarDefaultText),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          TextField(
            controller: queryCtrl,
            cursorColor: Color(0xff000000),
            style: Subtitle2.apply(
              fontWeightDelta: 1
            ),
            autofocus: false,
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: black, width: 2.0),
              ),
              prefixIcon: InkWell(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  child: Image.asset(
                    "assets/resource/main/search_blue.png",
                    width: 24,
                    height: 24,
                    color: primary,
                  ),
                ),
              ),
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    queryCtrl.text = "";
                  });

                  Provider.of<PlaceProvider>(context, listen: false).clearPlaces();
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
          ),
          whiteSpaceH(24),
          Consumer<PlaceProvider>(
            builder: (context, pp, _){
              return pp.isLoading ?
              Center(
                  child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
                  )
              )
                  :
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      PlaceItem(pp.googlePlaces[index]),
                  itemCount: pp.googlePlaces.length,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget PlaceItem(Place place) {
    return InkWell(
      onTap: () async {
        await Provider.of<PlaceProvider>(context, listen: false).fetchPlaceDetail(place.placeId).then((value) {
            print(value.lat);
            print(value.lng);

            Navigator.of(context).pop(
              {
                "lat": value.lat,
                "lng": value.lng
              }
            );
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Image.asset(
              "assets/icon/place.png",
              height: 24,
              width: 24,
              fit: BoxFit.contain,
            ),
            whiteSpaceW(8),
            Expanded(
              child: Text(place.description,
                style: Body1.apply(
                  color: black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}