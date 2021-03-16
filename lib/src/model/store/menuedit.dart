import 'package:flutter/cupertino.dart';

class MenuEditModel {
  TextEditingController nameCtrl;
  TextEditingController priceCtrl;

  MenuEditModel.autoConf()
    : this.nameCtrl = TextEditingController(),
      this.priceCtrl = TextEditingController();

  MenuEditModel.fromJson(Map<String, dynamic> json)
    : this.nameCtrl = TextEditingController(text: json['menu_name']),
      this.priceCtrl = TextEditingController(text: json['menu_price'].toString());
}

class BigMenuEditModel {
  TextEditingController nameCtrl;
  List<MenuEditModel> menuEditList;

  BigMenuEditModel.autoConf()
    : this.nameCtrl = TextEditingController(),
      this.menuEditList = [MenuEditModel.autoConf()];

  BigMenuEditModel.fromJson(Map<String, dynamic> json)
    : this.nameCtrl = TextEditingController(text: json['big_name']),
      this.menuEditList = (json['menuList'] as List).map((e) => MenuEditModel.fromJson(e)).toList();
}