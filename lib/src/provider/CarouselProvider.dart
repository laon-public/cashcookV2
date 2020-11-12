import 'package:flutter/cupertino.dart';

class CarouselProvider with ChangeNotifier {
  int nowPage = 0;
  int allPage = 3;

  void changePage(int index) {
    nowPage = index;

    notifyListeners();
  }
}