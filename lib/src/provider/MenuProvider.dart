import 'dart:convert';

import 'package:cashcook/src/model/category.dart';
import 'package:cashcook/src/model/menu.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/services/Menu.dart';
import 'package:cashcook/src/services/Store.dart';
import 'package:cashcook/src/utils/responseCheck.dart';
import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier{
  final MenuService service = MenuService();
  List<MenuModel> menu = [];
  bool isLoading = true;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

}