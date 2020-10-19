import 'dart:convert';

import 'package:cashcook/src/model/place.dart';
import 'package:cashcook/src/services/Search.dart';
import 'package:flutter/cupertino.dart';

class PlaceProvider with ChangeNotifier {
  SearchService service = SearchService();

  List<Place> placeList = [];
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

  void queryRoute(String query) async {
    if(queryType == "google") {
      await fetchGoogleSearch(query);
    } else {
      await fetchStoreSearch(query);
    }
  }

  void fetchStoreSearch(String query) async {
    placeList.clear();

    startLoading();

    final response = await service.getStoreSearch(query);
    Map<String,dynamic> storeJson = jsonDecode(response);

    print(response);
    for (var store in storeJson['data']['list']) {
      placeList.add(Place.fromStoreJson(store));
    }

    stopLoading();
  }

  void fetchGoogleSearch(String query) async {
      placeList.clear();

      startLoading();

      final response = await service.getGoogleSearch(query);
      Map<String,dynamic> googleJson = jsonDecode(response);

      for (var pre in googleJson['predictions']) {
        placeList.add(Place.fromGoogleJson(pre));
      }

      stopLoading();
  }
}