import 'dart:convert';
import 'dart:io';
import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/model/store/content.dart';
import 'package:cashcook/src/services/StoreApply.dart';
import 'package:cashcook/src/utils/responseCheck.dart';
import 'package:cashcook/src/widgets/showToast.dart';
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

  bool isFetching = false;
  bool isPatching = false;
  bool isPosting = false;
  bool isDeleting = false;

  // Content
  List<ContentModel> contentsList = [];
  bool isContentFetch = false;
  bool isContenting = false;
  bool isContentDeleting = false;

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
    isDeleting = true;
    notifyListeners();

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

    try {
      String res = await service.deleteMenu(menuIds);
      Map<String, dynamic> json = jsonDecode(res);

      if(isResponse(json)){
        return true;
      }

      return false;
    } catch(e) {
      return false;
    } finally {
      isDeleting = false;
      notifyListeners();
    }
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

    isDeleting = true;
    notifyListeners();

    try{
      String res = await service.deleteBigMenu(bigMenuIds);
      Map<String, dynamic> json = jsonDecode(res);

      if(isResponse(json)){
        return true;
      }

      return false;
    } catch(e) {
      return false;
    } finally {
      isDeleting = false;
      notifyListeners();
    }
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
    isFetching = true;
    notifyListeners();

    try {
      String res = await service.fetchBigMenu(storeId);
      Map<String, dynamic> json = jsonDecode(res);
      dynamic _bigMenuList = json['data']['list'];

      for (var _bigMenu in _bigMenuList) {
        bigMenuList.add(BigMenuModel.fromJson(_bigMenu));
      }
    } catch(e) {
      showToast("리스트를 불러오는 데 실패했습니다.");
    } finally {
      isFetching = false;
      notifyListeners();
    }
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
    isPosting = true;
    notifyListeners();
    try {
      String res = await service.postMenu(bigId, menuName, menuPrice, menuImg);
      Map<String, dynamic> json = jsonDecode(res);

      if(isResponse(json)){
        return true;
      }
      return false;
    } catch(e) {
      print(e);
      return false;
    } finally {
      isPosting = false;
      notifyListeners();
    }
  }

  Future<bool> patchBigMenu(int id, String menuName) async {
    isPatching = true;
    notifyListeners();

    try{
      String res = await service.patchBigMenu(id, menuName);

      Map<String, dynamic> json = jsonDecode(res);

      if(isResponse(json)){
        return true;
      }

      return false;
    } catch(e) {
      return false;
    } finally {
      isPatching = false;
      notifyListeners();
    }
  }

  Future<bool> patchMenu(int id, String menuName, String menuPrice, PickedFile menuImg) async {
    isPatching = true;
    notifyListeners();

    try{
      String res = await service.patchMenu(id, menuName, menuPrice, menuImg);

      Map<String, dynamic> json = jsonDecode(res);

      if(isResponse(json)){
        return true;
      }

      return false;
    } catch(e) {
      return false;
    } finally {
      isPatching = false;
      notifyListeners();
    }
  }

  Future<bool> postBigMenu(int storeId, String name) async {
    isPosting = true;
    notifyListeners();

    try{
      String res = await service.postBigMenu(storeId, name);

      Map<String, dynamic> json = jsonDecode(res);

      if(isResponse(json)){
        return true;
      }

      return false;
    } catch(e) {
      return false;
    } finally {
      isPosting = false;
      notifyListeners();
    }

  }

  Future updateImg(int index, PickedFile img) async {
    contentsList[index].updateFile = img;

    notifyListeners();
  }

  Future<bool> patchContent(int storeId, String content, List<PickedFile> imgList) async {
    isContenting = true;
    notifyListeners();

    List<int> updateImgSeqs = [];
    List<PickedFile> updateImgs = [];

    contentsList.where((element) => element.updateFile != null).forEach((element) {
      updateImgSeqs.add(element.id);
      updateImgs.add(element.updateFile);
    });

    try {
      String res = await service.patchContent(
          storeId, content, updateImgSeqs, updateImgs, imgList);
      Map<String, dynamic> json = jsonDecode(res);

      if(isResponse(json)) {
        return true;
      }
      return false;
    } catch(e) {
      return false;
    } finally {
      isContenting = false;
      notifyListeners();
    }
  }

  Future fetchContent(int storeId) async {
    isContentFetch = true;
    notifyListeners();

    try {
      final res = await service.fetchContent(storeId);

      contentsList.clear();
      notifyListeners();

      Map<String, dynamic> json = jsonDecode(res);

      (json['data']['contents'] as List).forEach((e) {
        contentsList.add(
            ContentModel.fromJson(e)
        );
      });
    } catch(e) {
      showToast("사진 리스트를 불러오는데 실패했습니다.");
    } finally {
      isContentFetch = false;
      notifyListeners();
    }
  }

  Future<bool> deleteContent(int contentId) async {
    isContentDeleting = true;
    notifyListeners();
    try {
      final res = await service.deleteContentImg(contentId);

      Map<String, dynamic> json = jsonDecode(res);
      if(isResponse(json)) {
        return true;
      }

      return false;
    } catch(e) {
      return false;
    } finally {
      isContentDeleting = false;
      notifyListeners();
    }
  }
}