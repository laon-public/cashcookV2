import 'dart:convert';

import 'package:cashcook/src/model/category.dart';
import 'package:cashcook/src/model/log/orderLog.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/model/store/review.dart';
import 'package:cashcook/src/services/Store.dart' as s;
// import 'package:cashcook/src/services/StoreService.dart ';
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
  int orderAmount = 0;
  int initAmount = 0;
  TextEditingController dlCtrl = TextEditingController();
  int pay = 0;
  BankInfo bankInfo;
  int lookIdx = -1;
  bool isMenuLoading = false;

  // reviewService
  List<ReviewModel> reviewList = [];
  double reviewAvg = 0.0;

  // scrapService
  List<StoreModel> scrapList = [];

  // main Service
  List<StoreModel> store = [];
  s.StoreService service_2 = s.StoreService();
  bool lookServiceBar = false;
  bool orderLoading = false;

  // Cat Search Service;
  List<StoreMinify> storeMiniList = [];
  List<StoreModel> searchStore = [];
  int count = 0;
  bool isCategoryFetching = false;

  bool isDeliveryLoading = false;

  String address = "";

  void setAddress(String address) {
    this.address = address;
  }

  void setLookIdx(int idx) {
    lookIdx = idx;

    notifyListeners();
  }

  void setBankInfo(String cardName, String cardNumber) {
    bankInfo = BankInfo(cardName: cardName, cardNumber: cardNumber);

    notifyListeners();
  }

  void setServiceBar(bool value) {
    if (this.lookServiceBar.toString() != value.toString()) {
      this.lookServiceBar = value;

      notifyListeners();
    }
  }

  void clearDlCtrl() {
    dlCtrl.text = "0";
    notifyListeners();
  }

  void clearOrderAmount() {
    bankInfo = null;
    orderLoading = false;
    orderAmount = 0;
  }

  void orderComplete() {
    bankInfo = null;
    orderLoading = false;
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

  Future<String> setOrderMap(String store_id, String logType, String imp_uid,
      String email, String comment, bool isDelivery) async {
    orderLoading = true;
    notifyListeners();

    Map<String, dynamic> orderMap = {};

    orderMap['storeId'] = store_id;
    orderMap['content'] = initAmount == 1
        ? orderList[0].menuList[0].name
        : "${orderList[0].menuList[0].name} ??? ${initAmount - 1}???";
    orderMap['pay'] = orderPay;
    orderMap['dl'] = int.parse(dlCtrl.text == "" ? "0" : dlCtrl.text);
    orderMap['logType'] = logType;
    orderMap['mainCatList'] = [];
    orderMap['impUid'] = imp_uid;
    orderMap['email'] = email;
    orderMap['comment'] = comment;

    if (bankInfo != null) {
      orderMap['bankInfo'] = {
        "cardName": bankInfo.cardName,
        "cardNumber": bankInfo.cardNumber,
      };
    }

    if (isDelivery) {
      orderMap['status'] = "DELIVERY_REQUEST";
      orderMap['deliveryAddress'] = {
        "address": address.split("???????????? ")[1].split("/")[0],
        "detail": address.split("/")[1]
      };
    }

    // MainCat Mapping
    orderList.forEach((mainCat) {
      // SubCat Mapping
      List<Map<String, dynamic>> subCatList = [];
      mainCat.menuList.forEach((subCat) {
        subCatList.add({
          'menuName': subCat.name,
          'amount': subCat.count,
          'price': subCat.price
        });
      });
      orderMap['mainCatList'].add({
        'menuName': mainCat.name,
        'subCatList': subCatList,
      });
    });

    final response = await service.orderPayment(orderMap);

    Map<String, dynamic> json = jsonDecode(response);
    print(response);
    if (isResponse(json)) {
      String fcmToken = json['data']['fcmToken'];
      return Future.value(fcmToken);
    }
    return Future.value(null);
  }

  Future<bool> confirmGame({int orderId = 0, int gameQuantity}) async {
    Map<String, dynamic> confirmGame = {};

    // OrderLog Mapping
    confirmGame['orderId'] = orderId;
    confirmGame['gameQuantity'] = gameQuantity;

    final response = await service.gameConfirm(confirmGame);

    Map<String, dynamic> json = jsonDecode(response);
    if (!isResponse(json)) {
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future<bool> replayGame({int orderId = 0}) async {
    Map<String, dynamic> replayGame = {};

    // OrderLog Mapping
    replayGame['orderId'] = orderId;

    final response = await service.gameReplay(replayGame);

    Map<String, dynamic> json = jsonDecode(response);
    if (!isResponse(json)) {
      showToast("RP??? ???????????????. ?????? ????????? ???????????????.");

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

  void startMenuLoading() {
    isMenuLoading = true;

    notifyListeners();
  }

  void stopMenuLoading() {
    isMenuLoading = false;

    notifyListeners();
  }

  void showView() {
    isView = true;
    notifyListeners();
  }

  void hideView() {
    isView = false;
    notifyListeners();
  }

  void fetchMenu(int store_id) async {
    menuList.clear();
    notifyListeners();

    final response = await service.fetchMenu(store_id);

    dynamic _bigMenuList = json.decode(response)['data']['list'];

    for (var _bigMenu in _bigMenuList) {
      menuList.add(BigMenuModel.fromJson(_bigMenu));
    }

    notifyListeners();
  }

  void setServiceNum(int num, int store_id) async {
    serviceNum = num;
    menuList.clear();

    reviewAvg = 0.0;
    reviewList.clear();
    if (num == 0) {
      startMenuLoading();
      final response = await service.fetchMenu(store_id);

      dynamic _bigMenuList = json.decode(response)['data']['list'];

      for (var _bigMenu in _bigMenuList) {
        menuList.add(BigMenuModel.fromJson(_bigMenu));
      }
      stopMenuLoading();
    } else if (num == 1) {
      notifyListeners();
    } else if (num == 2) {
      startLoading();
      final response = await service.fetchReview(store_id);

      dynamic _reviewList = json.decode(response)['data']['list'];
      reviewAvg = json.decode(response)['data']['avg'];

      if (_reviewList != null) {
        for (var _review in _reviewList) {
          reviewList.add(ReviewModel.fromJson(_review));
        }
      }
      stopLoading();
    }
  }

  void reviewListSelect() async {
    final response = await service.fetchReviewList();

    dynamic _reviewList = json.decode(response)['data']['avg'];
    if (_reviewList != null) {
      for (var _review in _reviewList) {
        reviewList.add(ReviewModel.fromJsonScope(_review));
      }
    }

    stopLoading();
  }

  void setCheck(bigIdx, idx, value) {
    print("bigIdx ?????? >> " + bigIdx.toString());
    print("idx ?????? >> " + idx.toString());
    print("value ?????? >> " + value.toString());

    menuList[bigIdx].menuList[idx].isCheck = value;

    value ? orderAmount += 1 : orderAmount -= 1;

    notifyListeners();
  }

  void increaseCount(bigIdx, idx) {
    orderList[bigIdx].menuList[idx].count++;
    orderPay += orderList[bigIdx].menuList[idx].price;
    orderAmount += 1;

    notifyListeners();
  }

  void decreaseCount(bigIdx, idx) {
    orderList[bigIdx].menuList[idx].count--;
    orderPay -= orderList[bigIdx].menuList[idx].price;
    orderAmount -= 1;

    notifyListeners();
  }

  void increaseDelivery(int price) {
    orderPay += price;

    notifyListeners();
  }

  void decreaseDelivery(int price) {
    orderPay -= price;

    notifyListeners();
  }

  Future<int> insertReview(
      int store_id, int scope, String contents, int order_id) async {
    final response =
        await service.insertReview(store_id, scope, contents, order_id);
    if (isResponse(jsonDecode(response))) {
      int review_id = json.decode(response)['data']['review_id'];
      return review_id;
    }
    return 0;
  }

  Future<bool> patchReview(
      int idx, int review_id, String type, String subtype) async {
    final response = await service.patchReview(review_id, type, subtype);
    if (isResponse(jsonDecode(response))) {
      showToast(json.decode(response)['data']['msg']);

      if (type == "like") {
        if (subtype == "inc") {
          reviewList[idx].isLike = 1;
          reviewList[idx].like += 1;
        } else {
          reviewList[idx].isLike = 0;
          reviewList[idx].like -= 1;
        }
      } else {
        if (subtype == "inc") {
          reviewList[idx].isHate = 1;
          reviewList[idx].hate += 1;
        } else {
          reviewList[idx].isHate = 0;
          reviewList[idx].hate -= 1;
        }
      }

      notifyListeners();

      return true;
    }
    return false;
  }

  void selSearchCategory(
      String code, String code_name, String start, String end) async {
    searchStore.clear();

    List<SubCatModel> selSubCat =
        subCatList.where((e) => e.code_name == code_name).toList();

    selectSubCat = selSubCat[0].code_name;
    selectSubCat_code = selSubCat[0].code;

    var response =
        await service.fetchStoreList(code, selectSubCat_code, start, end);

    dynamic _storeMiniList = json.decode(response)['data']['list'];
    for (var _storeMini in _storeMiniList) {
      searchStore.add(StoreModel.fromJson(_storeMini));
    }
    count = searchStore.length;

    notifyListeners();
  }

  void fetchSubCategory(String code, String start, String end) async {
    subCatList.clear();
    searchStore.clear();
    startLoading();

    var response = await service.fetchSubCategory(code);

    dynamic _subCatList = json.decode(response)['data']['list'];
    subCatList.add(SubCatModel(code: "000", code_name: "??????"));
    for (var _subCat in _subCatList) {
      subCatList.add(SubCatModel.fromJson(_subCat));
    }

    response = await service.fetchStoreList(code, "000", start, end);

    dynamic _storeMiniList = json.decode(response)['data']['list'];
    for (var _storeMini in _storeMiniList) {
      searchStore.add(StoreModel.fromJson(_storeMini));
    }
    count = searchStore.length;

    selectSubCat = subCatList[0].code_name;
    selectSubCat_code = subCatList[0].code;

    stopLoading();
  }

  void fetchNewCategory(String code_name) async {
    subCatList.clear();

    List<CatModel> selCat =
        catList.where((e) => e.code_name == code_name).toList();

    var response = await service.fetchSubCategory(selCat[0].code);

    dynamic _subCatList = json.decode(response)['data']['list'];
    for (var _subCat in _subCatList) {
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
  }

  void setSubCat(String code_name) {
    List<SubCatModel> selSubCat =
        subCatList.where((e) => e.code_name == code_name).toList();

    selectSubCat = selSubCat[0].code_name;
    selectSubCat_code = selSubCat[0].code;

    notifyListeners();
  }

  void fetchCategory(String code) async {
    catList.clear();
    subCatList.clear();

    var response = await service.fetchCategory();

    dynamic _catList = json.decode(response)['data']['list'];

    for (var _cat in _catList) {
      catList.add(CatModel.fromJson(_cat));
    }

    selectCat_code = catList[0].code;
    selectCat = catList[0].code_name;
    response = await service.fetchSubCategory(code);

    dynamic _subCatList = json.decode(response)['data']['list'];
    for (var _subCat in _subCatList) {
      subCatList.add(SubCatModel.fromJson(_subCat));
    }

    selectSubCat_code = subCatList[0].code;
    selectSubCat = subCatList[0].code_name;

    notifyListeners();
  }

  void fetchEditCategory(String code, String subCode) async {
    catList.clear();
    subCatList.clear();
    isCategoryFetching = true;
    notifyListeners();

    try {
      var response = await service.fetchCategory();

      dynamic _catList = json.decode(response)['data']['list'];

      for (var _cat in _catList) {
        catList.add(CatModel.fromJson(_cat));
      }

      selectCat =
          (catList.where((cat) => cat.code == code).toList())[0].code_name;
      response = await service.fetchSubCategory(code);

      dynamic _subCatList = json.decode(response)['data']['list'];
      for (var _subCat in _subCatList) {
        subCatList.add(SubCatModel.fromJson(_subCat));
      }

      selectSubCat =
          (subCatList.where((sCat) => sCat.code == subCode).toList())[0]
              .code_name;
    } catch (e) {
      showToast("????????? ??????????????? ??????????????????.");
    } finally {
      isCategoryFetching = false;
      notifyListeners();
    }
  }

  void patchMenu(List<Map<String, dynamic>> menuData) async {
    var response = await service.patchMenu(menuData);
  }

  void doScrap(String store_id) async {
    var response = await service.doScrap(store_id);

    showToast(json.decode(response)['data']['msg']);

    if (store.length != 0) {
      store.forEach((element) {
        if (element.id == int.parse(store_id)) {
          element.scrap.scrap = "1";
        }
      });
    }

    if (storeMiniList.length != 0) {
      storeMiniList.forEach((element) {
        if (element.id == int.parse(store_id)) {
          element.scrap = "1";
        }
      });
    }

    if (searchStore.length != 0) {
      searchStore.forEach((element) {
        if (element.id == int.parse(store_id)) {
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

    dynamic _scrapList = json.decode(response)['data']['list'];

    for (var scrap in _scrapList) scrapList.add(StoreModel.fromJson(scrap));

    stopLoading();
  }

  void cancleScrap(int store_id) async {
    var response = await service.cancleScrap(store_id);

    if (json.decode(response)['data']['result'] == 0) {
      showToast(json.decode(response)['data']['resultMsg']);
    } else {
      scrapList = scrapList.where((scrap) => scrap.id != store_id).toList();

      showToast("?????????????????????.");
      if (store.length != 0) {
        store.forEach((element) {
          if (element.id == store_id) {
            element.scrap.scrap = "0";
          }
        });
      }

      if (storeMiniList.length != 0) {
        storeMiniList.forEach((element) {
          if (element.id == store_id) {
            element.scrap = "0";
          }
        });
      }

      if (searchStore.length != 0) {
        searchStore.forEach((element) {
          if (element.id == store_id) {
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
    Map<String, dynamic> storeJson = jsonDecode(response);

    print(response);
    for (var store in storeJson['data']['list']) {
      StoreModel tmp = StoreModel.fromJson(store);
      if (searchStore
              .where((element) => element.id == tmp.id)
              .toList()
              .length ==
          0) {
        searchStore.add(tmp);
      }
    }

    stopLoading();
  }

  Future<List<StoreModel>> getStore(
      String start, String end, String type, String category) async {
    store.clear();
    // startLoading();
    int cnt = 0;
    String response = await service_2.getStore(start, end, type, category);
    Map<String, dynamic> mapJson = jsonDecode(response);
    List<StoreModel> rtnStoreList = [];
    if (isResponse(mapJson)) {
      for (var storeList in mapJson['data']["list"]) {
        StoreModel tmp = StoreModel.fromJson(storeList);
        if ((store.where((s) => (s.id == tmp.id)).toList().length == 0)) {
          // store.add(tmp);
          rtnStoreList.add(tmp);
        }
      }
    }

    // stopLoading();

    return rtnStoreList;
  }

  void patchDelivery(int storeId, String deliveryTime, String deliveryAmount,
      bool deliveryStatus, String minOrderAmount) async {
    isDeliveryLoading = true;
    notifyListeners();

    Map<String, dynamic> data = {
      "deliveryTime": deliveryTime,
      "deliveryAmount": deliveryAmount,
      "deliveryStatus": deliveryStatus,
      "minOrderAmount": minOrderAmount
    };

    try {
      final response = await service.patchDelivery(storeId, data);

      print(response);

      showToast("?????? ????????? ??????????????????.");
    } catch (e) {
      showToast("?????? ????????? ??????????????????.");
    } finally {
      isDeliveryLoading = false;
      notifyListeners();
    }
  }
}
