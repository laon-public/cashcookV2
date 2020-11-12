import 'dart:convert';

import 'package:cashcook/src/model/place.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/services/Search.dart';
import 'package:flutter/cupertino.dart';

class PlaceProvider with ChangeNotifier {
  SearchService service = SearchService();

  List<StoreMinify> placeList = [];
  bool isLoading = false;

  String queryType = "google";

  void setQueryType(String type) {
    queryType = type;

    notifyListeners();
  }

  void startLoading() {
    isLoading = true;

    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;

    notifyListeners();
  }

  void clearPlace() {
    placeList.clear();

    notifyListeners();
  }
  

  void fetchStoreSearch(String query, String start, String end) async {
    placeList.clear();

    startLoading();

    final response = await service.getStoreSearch(query, start, end);
    Map<String,dynamic> storeJson = jsonDecode(response);

    print(response);
    for (var store in storeJson['data']['list']) {
      placeList.add(StoreMinify.fromJson(store));
    }

    stopLoading();
  }

}