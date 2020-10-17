import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as u;

import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/model/store/menuedit.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/services/Store.dart';
import 'package:cashcook/src/services/StoreService.dart' as ss;
import 'package:cashcook/src/utils/FromAsset.dart';
import 'package:cashcook/src/utils/responseCheck.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class StoreProvider with ChangeNotifier{
  final StoreService service = StoreService();
  final StoreServiceProvider ssp = StoreServiceProvider();
  final ss.StoreService service_2 = ss.StoreService();
  List<StoreModel> store = [];
  List<StoreModel> newStore = [];
  Set<Marker> markers = {};

  // storeService View controll;
  bool isStoreSuccess = false;
  bool isMenuSuccess = false;
  int isCurrentPage = 0; // 0: 지도, 1: 배달서비스, 2: 마이페이지
  bool detailView = false;
  double distance = 0.0;
  StoreModel selStore;
  var currentLocation;
  Location location = Location();

  // 메뉴 Editing
  List<BigMenuEditModel> menuList = [BigMenuEditModel.autoConf()];
  List<BigMenuEditModel> menuEditList = [];
  FormData formData;
  List<Map<String, dynamic>> menuData = [];

  void setPage(int page){
    isCurrentPage = page;

    if(page == 2) {
      detailView = false;
    }

    notifyListeners();
  }

  void showDetailView(store){
    detailView = true;
    selStore = store;

    notifyListeners();
  }

  void hideDetailView() {
    detailView = false;

    notifyListeners();
  }

  void bak_store2(Map<String, String> data,String bn_path,
      String shop1_path, String shop2_path, String shop3_path) async {
    formData = new FormData.fromMap({
      "business_license": await MultipartFile.fromFile(bn_path),
    });
    formData.files.addAll([
      MapEntry("shop_images", MultipartFile.fromFileSync(shop1_path)),
      MapEntry("shop_images", MultipartFile.fromFileSync(shop2_path)),
      MapEntry("shop_images", MultipartFile.fromFileSync(shop3_path)),
    ]);

    formData.fields.addAll(data.entries);

    print("bak okay");
    print(formData.fields.toString());
  }

  void bak_comment(String comment) {
    formData.fields.addAll({"comment" : comment}.entries);
  }

  void bak_menu() {
    menuData.clear();
    List<BigMenuModel> _bigMenuList = [];

    for(BigMenuEditModel bigMenu in menuList) {
      List<MenuModel> _menuList = [];

      for(MenuEditModel menu in bigMenu.menuEditList) {
        _menuList.add(
          MenuModel(
            name: menu.nameCtrl.text,
            price: int.parse(menu.priceCtrl.text)
          )
        );
      }

      _bigMenuList.add(
        BigMenuModel(
          name: bigMenu.nameCtrl.text,
          menuList: _menuList
        )
      );
    }

    print(_bigMenuList.toString());

    _bigMenuList.forEach((bm) {
      List<Map<String, String>> menuMapList = [];
      bm.menuList.forEach((m) {
        menuMapList.add({
          "menu_name": m.name,
          "menu_price": m.price.toString(),
        });
      });

      menuData.add({
        "big_name": bm.name,
        "menuList" : menuMapList
      });
    });

    print(menuData.toString());
    print("bak_menu Okay");
  }

  Future<List> getStore(String start, String end) async {
      newStore.clear();
      print("getStore");
      print(start);
      print(end);
      int cnt = 0;
      String response = await service.getStore(start, end);
      print(response);
      Map<String, dynamic> mapJson = jsonDecode(response);
      if(isResponse(mapJson)){
        for(var storeList in mapJson['data']["list"]){
         StoreModel tmp = StoreModel.fromJson(storeList);

         if((store.where((s) => (s.id == tmp.id)).toList().length == 0)){
           newStore.add(tmp);
           store.add(tmp);
         }
       }
    }

      if(newStore.length != 0){
        markerAdds(newStore);
      }

      notifyListeners();
    return store;
  }

  markerAdds(List<StoreModel> newStore) {
    for (StoreModel store in newStore) {
      final MarkerId markerId = MarkerId(store.id.toString());
      addMarker(store, markerId);
    }
  }

  addMarker(store, markerId) async {
    final icon = await getBitmapDescriptorFromAssetBytes(
        "assets/icon/other_mk.png", 96);
    final my_icon = await getBitmapDescriptorFromAssetBytes(
        "assets/icon/my_mk.png", 72);
    UserProvider userProvider = UserProvider();
    StoreServiceProvider ssp = StoreServiceProvider();

      markers.add(Marker(
          markerId: markerId,
          position: LatLng(
              double.parse(store.address.coords.split(",").first),
              double.parse(store.address.coords.split(",").last)),
          icon: /*(userProvider.storeModel.id == newStore[num].id) ? my_icon : */icon,
          onTap: () async {
            // await ssp.setServiceNum(0, store.id);
            currentLocation = await location.getLocation();

            distance = calculateDistance(
                currentLocation.latitude,
                currentLocation.longitude,
                double.parse(store.address.coords.split(",").first),
                double.parse(store.address.coords.split(",").last));
            showDetailView(store);
          }));
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<bool> postStore() async {
    print("post");

    print(formData.fields.toString());
    bool isReturn = await service.postStore(formData);
    return isReturn;
  }

  Future<bool> patchStore(Map<String, String> data, String bn_uri, String shop1_uri, String shop2_uri, String shop3_uri) async {
    print("patch");
    bool isReturn = await service.patchStore(data, bn_uri, shop1_uri, shop2_uri, shop3_uri);
    return isReturn;
  }

  void clearBigMenu() {
    menuList.clear();
    menuList.add(BigMenuEditModel.autoConf());
  }

  void appendBigMenu() {
    menuList.add(BigMenuEditModel.autoConf());

    notifyListeners();
  }

  void appendMenu(int idx) {
      menuList[idx].menuEditList.add(MenuEditModel.autoConf());

      notifyListeners();
  }

  void removeBigMenu(int idx) {
    menuList.removeAt(idx);

    notifyListeners();
  }

  void removeMenu(int bigIdx, int idx){
    menuList[bigIdx].menuEditList.removeAt(idx);

    notifyListeners();
  }

  void postStoreService() async {
      await postStore();
      isStoreSuccess = true;
      notifyListeners();

      await ssp.postMenu(menuData);
      isMenuSuccess = true;
      notifyListeners();
  }

  void clearSuccess() {
    isStoreSuccess = false;
    isMenuSuccess = false;
  }

  void fetchEditMenu(int store_id) async {
    menuList.clear();

    final response = await service_2.fetchMenu(store_id);

    print(response);

    dynamic _bigMenuList = json.decode(response)['data']['list'];
  }
}