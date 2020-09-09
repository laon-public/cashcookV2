import 'dart:convert';

import 'package:flutter/material.dart';

class DiscountProvider extends ChangeNotifier {
  String discountMsg = "";

  void setMsg(String msg) {
    discountMsg = msg;

    notifyListeners();
  }
}
