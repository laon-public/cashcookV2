import 'package:flutter/cupertino.dart';

class CarouselProvider with ChangeNotifier {
  int nowPage = 0;
  int allPage = 2;

  void changePage(int index) {
    nowPage = index;

    notifyListeners();
  }
}