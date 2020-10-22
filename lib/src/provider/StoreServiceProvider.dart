import 'dart:convert';

import 'package:cashcook/src/model/category.dart';
import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/model/store/review.dart';
import 'package:cashcook/src/model/scrap.dart';
import 'package:cashcook/src/services/StoreService.dart';
import 'package:cashcook/src/utils/responseCheck.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:flutter/cupertino.dart';

class StoreServiceProvider with ChangeNotifier {
  int serviceNum = 0;
  bool isLoading = false;
  bool isView = false;

  // categoryService
  List<CatModel> catList = [];
  String selectCat;
  String selectCat_code;
  List<SubCatModel> subCatList = [];
  String selectSubCat;
  String selectSubCat_code;

  // menuService
  StoreService service = StoreService();
  List<BigMenuModel> menuList = [];
  List<BigMenuModel> orderList = [];
  int orderPay = 0;
  TextEditingController bzaCtrl = TextEditingController();
  int pay = 0;

  // reviewService
  List<ReviewModel> reviewList = [];
  double reviewAvg = 0.0;

  // scrapService
  List<ScrapModel> scrapList = [];

  void clearBzaCtrl() {
    bzaCtrl.text = "0";
    notifyListeners();
  }

  void setOrderMenu(List<BigMenuModel> setMenus, int orderPay) {
    orderList.clear();

    orderList = setMenus;
    this.orderPay = orderPay;
    this.pay = orderPay;
    bzaCtrl.text = "0";

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

  void showView() {
    print("Button Show");
    isView = true;
    notifyListeners();
  }

  void hideView() {
    print("Button Hide");
    isView = false;
    notifyListeners();
  }

  void fetchMenu(int store_id) async {
    final response = await service.fetchMenu(store_id);

    print(response);

    dynamic _bigMenuList = json.decode(response)['data']['list'];

    for(var _bigMenu in _bigMenuList){
      menuList.add(BigMenuModel.fromJson(
          _bigMenu
      ));
    }

    notifyListeners();
  }

  void setServiceNum(int num, int store_id) async {
    serviceNum = num;
    menuList.clear();

    reviewAvg = 0.0;
    reviewList.clear();

    print("들어옹");
    startLoading();
    if(num == 0){
      final response = await service.fetchMenu(store_id);

      print(response);

      dynamic _bigMenuList = json.decode(response)['data']['list'];

      for(var _bigMenu in _bigMenuList){
        menuList.add(BigMenuModel.fromJson(
            _bigMenu
        ));
      }

      // menuList.forEach((e) {
      //   print("bigMenu is " + e.name );
      //   e.menuList.forEach((e) {
      //     print("menu is " + e.name);
      //   });
      // });

    } else if(num == 1){
      final response = await service.fetchReview(store_id);
      print(response);

      dynamic _reviewList = json.decode(response)['data']['list'];
      reviewAvg = json.decode(response)['data']['avg'];

      if(_reviewList != null){
        for(var _review in _reviewList) {
          reviewList.add(ReviewModel.fromJson(_review));
        }
      }
    }

    stopLoading();
  }

  void setCheck(bigIdx, idx, value){
    menuList[bigIdx].menuList[idx].isCheck = value;

    notifyListeners();
  }

  void increaseCount(bigIdx, idx) {
    orderList[bigIdx].menuList[idx].count++;
    orderPay += orderList[bigIdx].menuList[idx].price;

    notifyListeners();
  }

  void decreaseCount(bigIdx,idx) {
    orderList[bigIdx].menuList[idx].count--;
    orderPay -= orderList[bigIdx].menuList[idx].price;

    notifyListeners();
  }

  Future<bool> orderMenu(int store_user, int pay, String type, int dl) async {
    print('=============');
    print(store_user);
    print(pay);
    print('=============');
    print(123);
    final response = await service.orderPayment(pay, store_user, type, dl);
    print(response);
    if (isResponse(jsonDecode(response))) {
      return true;
    }
    return false;
  }

  Future<bool> insertReview(int store_id, int scope, String contents) async {
    final response = await service.insertReview(store_id, scope, contents);
    print(response);
    if (isResponse(jsonDecode(response))) {
      return true;
    }
    return false;
  }

  Future<bool> patchReview(int idx,int review_id,String type, String subtype) async {
    final response = await service.patchReview(review_id, type, subtype);
    print(response);
    if (isResponse(jsonDecode(response))) {
      showToast(json.decode(response)['data']['msg']);

      if(type == "like"){
        if(subtype == "inc") {
          reviewList[idx].isLike = 1;
          reviewList[idx].like += 1;
        }
        else {
          reviewList[idx].isLike = 0;
          reviewList[idx].like -= 1;
        }
      } else {
        if(subtype == "inc") {
          reviewList[idx].isHate = 1;
          reviewList[idx].hate += 1;
        }
        else {
          reviewList[idx].isHate = 0;
          reviewList[idx].hate -= 1;
        }
      }

      notifyListeners();

      return true;
    }
    return false;
  }

  void fetchNewCategory(String code_name) async {
    subCatList.clear();

    print(code_name);
    List<CatModel> selCat = catList.where((e) => e.code_name == code_name).toList();

    var response = await service.fetchSubCategory(selCat[0].code);

    print(response);

    dynamic _subCatList = json.decode(response)['data']['list'];
    for(var _subCat in _subCatList) {
      subCatList.add(SubCatModel.fromJson(_subCat));
    }

    selectCat = selCat[0].code_name;
    selectCat_code = selCat[0].code;
    selectSubCat_code = subCatList[0].code;
    selectSubCat = subCatList[0].code_name;

    notifyListeners();
  }

  void postMenu(List<Map<String, dynamic>> menuData) async {
    var response = await service.postMenu(menuData);

    print(response);
  }

  void setSubCat(String code_name) {
    List<SubCatModel> selSubCat = subCatList.where((e) => e.code_name == code_name).toList();

    selectSubCat = selSubCat[0].code_name;
    selectSubCat_code = selSubCat[0].code;

    notifyListeners();
  }

  void fetchCategory(String code) async {
    catList.clear();
    subCatList.clear();

    var response = await service.fetchCategory();

    print(response);

    dynamic _catList = json.decode(response)['data']['list'];

    for(var _cat in _catList) {
      catList.add(CatModel.fromJson(_cat));
    }

    selectCat_code = catList[0].code;
    selectCat = catList[0].code_name;
    response = await service.fetchSubCategory(code);

    print(response);

    dynamic _subCatList = json.decode(response)['data']['list'];
    for(var _subCat in _subCatList) {
      subCatList.add(SubCatModel.fromJson(_subCat));
    }

    selectSubCat_code = subCatList[0].code;
    selectSubCat = subCatList[0].code_name;

    notifyListeners();
  }

  void fetchEditCategory(String code, String subCode) async {
    catList.clear();
    subCatList.clear();

    var response = await service.fetchCategory();

    print(response);

    dynamic _catList = json.decode(response)['data']['list'];

    for(var _cat in _catList) {
      catList.add(CatModel.fromJson(_cat));
    }


    selectCat = (catList.where((cat) => cat.code == code).toList())[0].code_name;
    response = await service.fetchSubCategory(code);

    print(response);

    dynamic _subCatList = json.decode(response)['data']['list'];
    for(var _subCat in _subCatList) {
      subCatList.add(SubCatModel.fromJson(_subCat));
    }

    selectSubCat = (subCatList.where((sCat) => sCat.code == subCode).toList())[0].code_name;

    notifyListeners();
  }

  void patchMenu(List<Map<String, dynamic>> menuData) async {
    var response = await service.patchMenu(menuData);

    print(response);
  }

  void doScrap(String store_id) async {
    var response = await service.doScrap(store_id);

    print(response);

    showToast(json.decode(response)['data']['msg']);
  }

  void readScrap() async {
    scrapList.clear();

    startLoading();

    var response = await service.readScrap();

    print(response);

    dynamic _scrapList = json.decode(response)['data']['list'];

    for(var scrap in _scrapList)
      scrapList.add(ScrapModel.fromJson(scrap));

    stopLoading();
  }

}