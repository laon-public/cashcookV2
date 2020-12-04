import 'dart:convert';

import 'package:cashcook/src/model/place.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/services/Search.dart';
import 'package:flutter/cupertino.dart';

class PlaceProvider with ChangeNotifier {
  SearchService service = SearchService();

  List<StoreMinify> placeList = [];
  List<Place> googlePlaces = [];
  bool isLoading = false;

  String queryType = "google";

  void clearPlaces() {
    googlePlaces.clear();

    notifyListeners();
  }

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

  void fetchPlaceSearch(String query) async {
    googlePlaces.clear();
    startLoading();

    final response = await service.getGoogleSearch(query);


    Map<String, dynamic> json = jsonDecode(response);

    (json['predictions'] as List).forEach((element) {
      googlePlaces.add(
        Place.fromGoogleJson(element)
      );
    });

    stopLoading();
  }


  Future<PlaceDetail> fetchPlaceDetail(String placeId) async {
    final res = await service.getPlaceDetail(placeId);

    Map<String, dynamic> json = jsonDecode(res);

    final PlaceDetail placeDetail = PlaceDetail.fromGoogleJson(json['result']);

    return placeDetail;
  }

  void fetchStoreSearch(String query, String start, String end) async {
    placeList.clear();

    startLoading();

    final response = await service.getStoreSearch(query, start, end);
    Map<String,dynamic> storeJson = jsonDecode(response);

    for (var store in storeJson['data']['list']) {
      placeList.add(StoreMinify.fromJson(store));
    }

    stopLoading();
  }

}