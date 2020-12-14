import 'package:image_picker/image_picker.dart';

class ContentModel {
  int id;
  int storeId;
  String imgUrl;
  PickedFile updateFile;

  ContentModel.fromJson(Map<String, dynamic> json)
    :
      this.id = json['id'],
      this.storeId = json['storeId'],
      this.imgUrl = json['imgUrl'],
      this.updateFile = null;
}