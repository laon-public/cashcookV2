import 'dart:convert';

import 'package:cashcook/src/model/category.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/services/Store.dart';
import 'package:cashcook/src/utils/responseCheck.dart';
import 'package:flutter/material.dart';

class StoreProvider with ChangeNotifier{
  final StoreService service = StoreService();
  List<StoreModel> store = [];
  List<CatModel> categoryList = [];
  List<CatModel> subCategoryList = [];
  CatModel catSelected;
  CatModel subCatSelected;
  bool isLoading = true;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

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
  // Category Consumer Yeah
  void setCatSelected(String value) async {
    for(CatModel cat in categoryList) {
      if(cat.code_name == value){
        catSelected = cat;
        break;
      }
    }
    print(catSelected.code_name);

    subCategoryList.clear();

    var response = await service.getSubCategory(catSelected.code);
    print("response");
    print(response);
    Map<String,dynamic> json = jsonDecode(response);
    print(json);
    print("카테고리 테스트");

    for(var cat in json['data']['list']){
      subCategoryList.add(CatModel.fromJsonBySub(cat));
    }
    print(subCategoryList.length);
    print(subCatSelected);

    subCatSelected = subCategoryList[0];

    notifyListeners();
  }

  void setCatSubSelected(String value) async {
    print("setCatSubSelected");
    print(value);

    for(CatModel cat in subCategoryList) {
      if(cat.code_name == value){
        subCatSelected = cat;
        break;
      }
    }
    notifyListeners();
  }


//
//  void setSubCatSelected(String value){
//    subCatSelected = value;
//    notifyListeners();
//  }

  void getCategory() async {
    categoryList.clear();
    subCategoryList.clear();
    startLoading();

    var response = await service.getCategory();
    print("response");
    print(response);
    Map<String, dynamic> json = jsonDecode(response);
    print(json);
    print("카테고리 테스트");

    for(var cat in json['data']['list']){
      categoryList.add(CatModel.fromJson(cat));
    }
    print(categoryList.length);
    print(catSelected);

    catSelected = categoryList[0];

    response = await service.getSubCategory(catSelected.code);
    print("response");
    print(response);
    json = jsonDecode(response);
    print(json);
    print("카테고리 테스트");

    for(var cat in json['data']['list']){
      subCategoryList.add(CatModel.fromJsonBySub(cat));
    }
    print(subCategoryList.length);
    print(subCatSelected);

    subCatSelected = subCategoryList[0];

    stopLoading();
  }

}