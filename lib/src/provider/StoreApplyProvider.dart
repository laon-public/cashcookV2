import 'dart:io';

import 'package:cashcook/src/services/StoreApply.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StoreApplyProvider extends ChangeNotifier {
  List<PickedFile> imageList = [];
  StoreApplyService service = StoreApplyService();
  MultipartFile imageFile;

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
}