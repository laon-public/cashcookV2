import 'dart:convert';

import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/services/Store.dart';
import 'package:cashcook/src/utils/responseCheck.dart';
import 'package:flutter/material.dart';

class StoreProvider with ChangeNotifier{
  final StoreService service = StoreService();
  List<StoreModel> store = [];

    Future<void> getStore(String start, String end) async {
      print("getStore");
      print(start);
      print(end);
    store.clear();
    print("여기 부르냐?");
    String response = await service.getStore(start, end);
    print(response);
    Map<String, dynamic> mapJson = jsonDecode(response);
    if(isResponse(mapJson)){
      for(var storeList in mapJson['data']["list"]){
        var tmp = StoreModel.fromJson(storeList);
        store.add(tmp);
      }
    }
    print("여기 부르냐?");
    notifyListeners();
  }

  Future<bool> postStore(Map<String, String> data, String bn_uri, String shop1_uri, String shop2_uri, String shop3_uri) async {
    print("post");
    bool isReturn = await service.postStore(data, bn_uri, shop1_uri, shop2_uri, shop3_uri);
    return isReturn;
  }

  Future<bool> patchStore(Map<String, String> data, String bn_uri, String shop1_uri, String shop2_uri, String shop3_uri) async {
    print("patch");
    bool isReturn = await service.patchStore(data, bn_uri, shop1_uri, shop2_uri, shop3_uri);
    return isReturn;
  }


}