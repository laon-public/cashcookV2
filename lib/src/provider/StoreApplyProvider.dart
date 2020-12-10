import 'dart:convert';
import 'dart:io';
import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/model/store/content.dart';
import 'package:cashcook/src/services/StoreApply.dart';
import 'package:cashcook/src/utils/responseCheck.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StoreApplyProvider extends ChangeNotifier {
  List<PickedFile> imageList = [];
  StoreApplyService service = StoreApplyService();
  MultipartFile imageFile;

  // Menu
  List<BigMenuModel> bigMenuList = [];
  List<MenuModel> menuList = [];
  int chkQuantity = 0;

  // Content
  List<ContentModel> contentsList = [];

  Future insertImg() async {
    PickedFile pickedImg = await ImagePicker().getImage(source: ImageSource.gallery);

    if(pickedImg != null) {
      imageList.add(pickedImg);
      File image = File(pickedImg.path);
      imageFile = await MultipartFile.fromFileSync(image.absolute.path);
    }

    notifyListeners();
  }

  Future deleteImg(PickedFile file) async {
    int idx = imageList.indexOf(file);

    imageList.removeAt(idx);

    notifyListeners();
  }

  Future submitImg() async {
    File image = File(imageList[0].path);
    String res = await service.imageTest(image.absolute.path);
  }

  Future<bool> deleteMenu() async {
    String menuIds = "";
    int _tmpChkQuantity = 0;

    menuList.forEach((element) {
      if(element.isCheck){
        if(_tmpChkQuantity+1 == chkQuantity){
          menuIds += element.id.toString();
          return;
        } else {
          menuIds += "${element.id.toString()},";
          _tmpChkQuantity++;
        }
      }
    });

    String res = await service.deleteMenu(menuIds);
    Map<String, dynamic> json = jsonDecode(res);

    if(isResponse(json)){
      return true;
    }

    return false;
  }

  Future<bool> deleteBigMenu() async {
    String bigMenuIds = "";
    int _tmpChkQuantity = 0;

    bigMenuList.forEach((element) {
      if(element.isCheck){
        if(_tmpChkQuantity+1 == chkQuantity){
          bigMenuIds += element.id.toString();
          return;
        } else {
          bigMenuIds += "${element.id.toString()},";
          _tmpChkQuantity++;
        }
      }
    });

    String res = await service.deleteBigMenu(bigMenuIds);
    Map<String, dynamic> json = jsonDecode(res);

    if(isResponse(json)){
      return true;
    }

    return false;
  }

  Future allChange(bool value,String type) async {
    if(value) {
      type == "bigMenu" ?
      bigMenuList.forEach((element) {
        element.isCheck = value;
        chkQuantity++;
      })
        :
      menuList.forEach((element) {
        element.isCheck = value;
        chkQuantity++;
      });
    } else {
      type == "bigMenu" ?
      bigMenuList.forEach((element) {
        element.isCheck = value;
        chkQuantity--;
      })
          :
      menuList.forEach((element) {
      element.isCheck = value;
      chkQuantity--;
      });
    }
    notifyListeners();
  }

  Future changeMenuCheck(bool value, int idx) async {
    menuList[idx].isCheck = value;

    if(value) {
      chkQuantity++;
    } else {
      chkQuantity--;
    }

    notifyListeners();
  }

  Future changeBigMenuCheck(bool value, int idx) async {
    bigMenuList[idx].isCheck = value;

    if(value) {
      chkQuantity++;
    } else {
      chkQuantity--;
    }

    notifyListeners();
  }

  Future fetchBigMenu(int storeId) async {
    chkQuantity = 0;
    bigMenuList.clear();
    notifyListeners();

    String res = await service.fetchBigMenu(storeId);
    Map<String, dynamic> json = jsonDecode(res);
    dynamic _bigMenuList = json['data']['list'];

    for(var _bigMenu in _bigMenuList) {
      bigMenuList.add(BigMenuModel.fromJson(_bigMenu));
    }
    notifyListeners();
  }

  Future fetchMenu(int bigId) async {
    chkQuantity = 0;
    menuList.clear();
    notifyListeners();

    String res = await service.fetchMenu(bigId);
    print(res);
    Map<String, dynamic> json = jsonDecode(res);
    dynamic _menuList = json['data']['menuList'];

    for(var _menu in _menuList) {
      menuList.add(
        MenuModel.fromJson(_menu)
      );
    }
    notifyListeners();
  }

  Future<bool> postMenu(int bigId, String menuName, String menuPrice, PickedFile menuImg) async {
    String res = await service.postMenu(bigId, menuName, menuPrice, menuImg);

    Map<String, dynamic> json = jsonDecode(res);

    if(isResponse(json)){
      return true;
    }

    return false;
  }

  Future<bool> patchBigMenu(int id, String menuName) async {
    String res = await service.patchBigMenu(id, menuName);

    Map<String, dynamic> json = jsonDecode(res);

    if(isResponse(json)){
      return true;
    }

    return false;
  }

  Future<bool> patchMenu(int id, String menuName, String menuPrice, PickedFile menuImg) async {
    String res = await service.patchMenu(id, menuName, menuPrice, menuImg);

    Map<String, dynamic> json = jsonDecode(res);

    if(isResponse(json)){
      return true;
    }

    return false;
  }

  Future<bool> postBigMenu(int storeId, String name) async {
    String res = await service.postBigMenu(storeId, name);

    Map<String, dynamic> json = jsonDecode(res);

    if(isResponse(json)){
      return true;
    }

    return false;
  }

  Future patchContent(int storeId, List<PickedFile> imgList) async {
    await service.patchContent(storeId, imgList);
  }

  Future fetchContent(int storeId) async {
    final res = await service.fetchContent(storeId);

    contentsList.clear();
    notifyListeners();

    Map<String, dynamic> json = jsonDecode(res);

    (json['data']['contents'] as List).forEach((e){
      contentsList.add(
        ContentModel.fromJson(e)
      );
    });

    contentsList.forEach((element) {
      print(element.imgUrl);
    });

    notifyListeners();
  }
}