import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StoreApplyProvider extends ChangeNotifier {
  List<PickedFile> imageList = [];

  Future insertImg() async {
    PickedFile pickedImg = await ImagePicker().getImage(source: ImageSource.gallery);

    if(pickedImg != null) {
      imageList.add(pickedImg);
    }

    notifyListeners();
  }

  Future deleteImg(PickedFile file) async {
    int idx = imageList.indexOf(file);

    imageList.removeAt(idx);

    notifyListeners();
  }
}