import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/StoreItem.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MainStoreList extends StatefulWidget {
  final Map<String, dynamic> storeInfo;
  // final String categoryCode;
  final double lat;
  final double lon;
  final dynamic changeView;

  MainStoreList({this.storeInfo, this.lat, this.lon, this.changeView});

  @override
  MainStoreListState createState() => MainStoreListState();
}

class MainStoreListState extends State<MainStoreList> {
  bool isLoading = true;
  bool isEmpty = false;
  List<StoreModel> storeList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(widget.storeInfo["category_code"]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if(this.isLoading){
            String start = (widget.lat + 0.04).toString() +
                "," +
                (widget.lon + 0.04).toString();
            String end = (widget.lat - 0.04).toString() +
                "," +
                (widget.lon - 0.04).toString();

        List<StoreModel> storeList  = await Provider.of<StoreServiceProvider>(context, listen: false).getStore(start, end, "main", widget.storeInfo["category_code"]);

        if(storeList.length == 0) {
          setState(() {
            isEmpty = true;
            this.isLoading = false;
          });
        } else {
          print(storeList.toString());
          setState(() {
            this.storeList = storeList;
            this.isLoading = false;
          });
        }
      }
    });

    return
      this.isLoading ?
      Container(
          width: MediaQuery.of(context).size.width,
          height: 800,
          child:
            LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFF7F7F7)),
        )
      )
          :
      this.isEmpty ?
    Container()
        :
    Column(
      children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.storeInfo["title"], style: Subtitle2,),
                          Container(
                            width: 90,
                            child:
                            Row(
                              children: [
                                SizedBox(
                                    width: 10.0,
                                    child:
                                    IconButton(
                                        iconSize: 17.0, icon: Icon(Icons.add_circle_outline), onPressed: null)),

                                SizedBox(
                                  width: 80.0,
                                  child:
                                  FlatButton(onPressed: (){
                                    widget.changeView(widget.storeInfo["idx"]);
                                  }, child: Text('더보기')),
                                )
                              ],
                            ),)
                            ]

            )
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child:
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
              child: Row(
                children: storeList.map((e) =>
                storeItem(e, context)
              ).toList(),
            ),
          )
        )
      ],
    );
  }
}