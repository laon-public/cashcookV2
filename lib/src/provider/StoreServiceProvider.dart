import 'dart:convert';

import 'package:cashcook/src/model/category.dart';
import 'package:cashcook/src/model/log/orderLog.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/model/store/review.dart';
import 'package:cashcook/src/model/scrap.dart';
import 'package:cashcook/src/services/Store.dart' as s;
import 'package:cashcook/src/services/StoreService.dart ';
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
  int orderAmount = 0;
  int initAmount = 0;
  TextEditingController dlCtrl = TextEditingController();
  int pay = 0;
  BankInfo bankInfo;

  // reviewService
  List<ReviewModel> reviewList = [];
  double reviewAvg = 0.0;

  // scrapService
  List<StoreModel> scrapList = [];

  // main Service
  List<StoreModel> store = [];
  s.StoreService service_2 = s.StoreService();

  // Cat Search Service;
  List<StoreMinify> storeMiniList = [];
  List<StoreModel> searchStore = [];
  int count = 0;

  void setBankInfo(String cardName, String cardNumber) {
      bankInfo = BankInfo(
        cardName: cardName,
        cardNumber: cardNumber
      );

      notifyListeners();
  }

  void clearDlCtrl() {
    dlCtrl.text = "0";
    notifyListeners();
  }

  void clearOrderAmount() {
    bankInfo = null;
    orderAmount = 0;
  }

  void orderComplete() {
    bankInfo = null;
    orderAmount = initAmount;
  }

  void setOrderMenu(List<BigMenuModel> setMenus, int orderPay) {
    orderList.clear();

    orderList = setMenus;
    this.orderPay = orderPay;
    this.pay = orderPay;
    dlCtrl.text = "0";
    initAmount = orderAmount;

    notifyListeners();
  }

  Future<bool> setOrderMap(String store_id, String logType) async {
    Map<String, dynamic> orderMap = {};

    orderMap['storeId'] = store_id;
    orderMap['content'] = initAmount == 1 ? orderList[0].menuList[0].name
        : "${orderList[0].menuList[0].name} 외 ${initAmount - 1}건";
    orderMap['pay'] = orderPay;
    orderMap['dl'] = int.parse(dlCtrl.text == "" ? "0" : dlCtrl.text);
    orderMap['logType'] = logType;
    orderMap['mainCatList'] = [];

    if(bankInfo != null){
      orderMap['bankInfo'] = {
        "cardName" : bankInfo.cardName,
        "cardNumber" : bankInfo.cardNumber,
      };
    }

    // MainCat Mapping
    orderList.forEach((mainCat) {
      // SubCat Mapping
      List<Map<String, dynamic>> subCatList = [];
      mainCat.menuList.forEach((subCat) {
        subCatList.add(
            {
              'menuName': subCat.name,
              'amount': subCat.count,
              'price': subCat.price
            }
        );
      });
      orderMap['mainCatList'].add(
          {
            'menuName' : mainCat.name,
            'subCatList' : subCatList,
          }
      );
    });

    print(orderMap.toString());

    final response = await service.orderPayment(orderMap);

    Map<String, dynamic> json = jsonDecode(response);
    print(json);
    if(!isResponse(json)){
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future<bool> confirmGame({int orderId = 0, int gameQuantity}) async {
    Map<String, dynamic> confirmGame = {};

    // OrderLog Mapping
    confirmGame['orderId'] = orderId;
    confirmGame['gameQuantity'] = gameQuantity;

    print(confirmGame.toString());

    final response = await service.gameConfirm(confirmGame);

    Map<String, dynamic> json = jsonDecode(response);
    print(json);
    if(!isResponse(json)){
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future<bool> replayGame({int orderId = 0}) async {
    Map<String, dynamic>replayGame = {};

    // OrderLog Mapping
    replayGame['orderId'] = orderId;

    print(confirmGame.toString());

    final response = await service.gameReplay(replayGame);

    Map<String, dynamic> json = jsonDecode(response);
    print(json);
    if(!isResponse(json)){
      showToast("RP가 부족합니다. 이전 결과로 출력됩니다.");

      return Future.value(false);
    }
    return Future.value(true);
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

  void reviewListSelect() async{
    final response = await service.fetchReviewList();
    print(response);

    dynamic _reviewList = json.decode(response)['data']['avg'];
    // dynamic _reviewList = json.decode(response)['data']['list'];
    // reviewAvg = json.decode(response)['data']['avg'];

    print("reviewListSelect1");
    if(_reviewList != null){
      print("reviewListSelect2");
      for(var _review in _reviewList) {
        reviewList.add(ReviewModel.fromJsonScope(_review));
      }
      print("reviewListSelect3");
    }

    stopLoading();
  }

  void setCheck(bigIdx, idx, value){
    menuList[bigIdx].menuList[idx].isCheck = value;

    value ? orderAmount += 1 : orderAmount -= 1;

    notifyListeners();
  }

  void increaseCount(bigIdx, idx) {
    orderList[bigIdx].menuList[idx].count++;
    orderPay += orderList[bigIdx].menuList[idx].price;
    orderAmount += 1;

    print(orderAmount);

    notifyListeners();
  }

  void decreaseCount(bigIdx,idx) {
    orderList[bigIdx].menuList[idx].count--;
    orderPay -= orderList[bigIdx].menuList[idx].price;
    orderAmount -= 1;

    print(orderAmount);

    notifyListeners();
  }

  Future<bool> orderMenu(int store_user, int pay, String type, int dl) async {
    print('=============');
    print(store_user);
    print(pay);
    print('=============');
    print(123);
    // final response = await service.orderPayment(pay, store_user, type, dl);
    // print(response);
    // if (isResponse(jsonDecode(response))) {
    //   return true;
    // }
    // return false;
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

  void selSearchCategory(String code, String code_name, String start, String end) async {
    searchStore.clear();

    List<SubCatModel> selSubCat = subCatList.where((e) => e.code_name == code_name).toList();

    selectSubCat = selSubCat[0].code_name;
    selectSubCat_code = selSubCat[0].code;

    var response = await service.fetchStoreList(code, selectSubCat_code,start ,end);
    print(response);

    dynamic _storeMiniList = json.decode(response)['data']['list'];
    for(var _storeMini in _storeMiniList) {
      searchStore.add(StoreModel.fromJson(_storeMini));
    }
    count = searchStore.length;

    notifyListeners();
  }

  void fetchSubCategory(String code,String start, String end) async {
    subCatList.clear();
    searchStore.clear();
    notifyListeners();

    var response = await service.fetchSubCategory(code);

    print(response);

    dynamic _subCatList = json.decode(response)['data']['list'];
    subCatList.add(SubCatModel(
        code: "000",
        code_name: "전체"
    ));
    for(var _subCat in _subCatList) {
      subCatList.add(SubCatModel.fromJson(_subCat));
    }

    response = await service.fetchStoreList(code, "000", start, end);
    print(response);

    dynamic _storeMiniList = json.decode(response)['data']['list'];
    for(var _storeMini in _storeMiniList) {
      searchStore.add(StoreModel.fromJson(_storeMini));
    }
    count = searchStore.length;

    selectSubCat = subCatList[0].code_name;
    selectSubCat_code = subCatList[0].code;

    notifyListeners();
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

    if(store.length != 0){
      store.forEach((element) {
        if(element.id == int.parse(store_id)) {
          element.scrap.scrap = "1";
        }
      });
    }

    if(storeMiniList.length != 0){
      storeMiniList.forEach((element) {
        if(element.id == int.parse(store_id)) {
          element.scrap = "1";
        }
      });
    }

    if(searchStore.length != 0){
      searchStore.forEach((element) {
        if(element.id == int.parse(store_id)) {
          element.scrap.scrap = "1";
        }
      });
    }

    notifyListeners();
  }

  void readScrap() async {
    scrapList.clear();

    startLoading();

    var response = await service.readScrap();

    print(response);

    dynamic _scrapList = json.decode(response)['data']['list'];

    for(var scrap in _scrapList)
      scrapList.add(StoreModel.fromJson(scrap));

    stopLoading();
  }

  void cancleScrap(int store_id) async {
    var response = await service.cancleScrap(store_id);

    print(response);

    if(json.decode(response)['data']['result'] == 0){
      showToast(json.decode(response)['data']['resultMsg']);
    } else {
      scrapList = scrapList.where((scrap) => scrap.id != store_id).toList();

      showToast("취소되었습니다.");
      if(store.length != 0){
        store.forEach((element) {
          if(element.id == store_id) {
            element.scrap.scrap = "0";
          }
        });
      }

      if(storeMiniList.length != 0){
        storeMiniList.forEach((element) {
          if(element.id == store_id) {
            element.scrap = "0";
          }
        });
      }

      if(searchStore.length != 0){
        searchStore.forEach((element) {
          if(element.id == store_id) {
            element.scrap.scrap = "0";
          }
        });
      }

      notifyListeners();
    }
  }

  void claerSearchStore() {
    searchStore.clear();

    notifyListeners();
  }

  void fetchStoreSearch(String query, String start, String end) async {
    searchStore.clear();

    startLoading();

    final response = await service.getStoreSearch(query, start, end);
    Map<String,dynamic> storeJson = jsonDecode(response);

    print(response);
    for (var store in storeJson['data']['list']) {
        searchStore.add(StoreModel.fromJson(store));
    }

    stopLoading();
  }

  void getStore(String start, String end) async {
    store.clear();
    startLoading();

    int cnt = 0;
    String response = await service_2.getStore(start, end);
    print("=================");
    print(response);
    Map<String, dynamic> mapJson = jsonDecode(response);
    if(isResponse(mapJson)){
      for(var storeList in mapJson['data']["list"]){
        StoreModel tmp = StoreModel.fromJson(storeList);
        if((store.where((s) => (s.id == tmp.id)).toList().length == 0)){
          store.add(tmp);
        }
      }
    }

    stopLoading();
  }

}