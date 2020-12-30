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







class storeItemView extends StatefulWidget {
  //좌우 스크롤 과목 리스트

  StoreModel store;
  BuildContext context;


  storeItemView( { @required this.store, this.context} );

  @override
  State createState() {
    return storeItemViewState(  store, context );
  }
}

class storeItemViewState extends State<storeItemView> {

    StoreModel store;
    BuildContext context;

    storeItemViewState(this.store, this.context);

    @override
    void initState() {
      super.initState();

    }

  @override
  Widget build(BuildContext context) {

      return Text('asdfsdf');

  }

  



}

