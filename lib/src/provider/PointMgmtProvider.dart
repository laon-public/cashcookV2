import 'dart:convert';

import 'package:cashcook/src/model/point.dart';
import 'package:cashcook/src/services/PointMgmt.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:flutter/cupertino.dart';

class PointMgmtProvider with ChangeNotifier {
  bool isLoading = true;
  PointMgmtService pmService = PointMgmtService();

  // Biz
  Map<String, dynamic> disMap = {};
  Map<String, dynamic> ageMap = {};

  // My
  List<Map<String,dynamic>> pfmList = [];
  List<Map<String,dynamic>> pumList = [];
  int adp = 0;
  int pay = 0;
  int dl = 0;


  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  void fetchFranMgmt() async {
    startLoading();

    print("fetchFranMgmt");
    final response = await pmService.getMgmtFran();
    Map<String, dynamic> json = jsonDecode(response);

    print(json);
    adp = json['data']['ADP'];
    dl = json['data']['DL'];
    pay = json['data']['PAY'];
    disMap = json['data']['dis'];
    ageMap = json['data']['age'];

    String date = "";
    Map<String, dynamic> obj = {};
    pfmList.clear();

    for (var history in json["data"]['list']) {
      try {
        PointFranModel pfmModel = PointFranModel.fromJson(history);
        print(pfmModel.point_img);
        String time = pfmModel.created_at.split("T").first;
        if (date != time) {
          if (date != "") {
            pfmList.add(obj);
            obj = {};
          }
          date = pfmModel.created_at.split("T").first;
          obj["date"] = date;
          obj["history"] = [];
          obj["history"].add({
            "title": pfmModel.type == "DILLING" ? numberFormat.format(double.parse(pfmModel.amount)) + " BZA"
              : numberFormat.format(double.parse(pfmModel.amount)) + " 원",
            "time": pfmModel.created_at.split("T").last.split(".").first,
            "price": demicalFormat.format(double.parse(pfmModel.amount)),
            "point_img": pfmModel.point_img,
          });
        } else {
          print("여기겠지");
          obj["history"].add({
            "title": pfmModel.type == "DILLING" ? numberFormat.format(double.parse(pfmModel.amount)) + " BZA"
                : numberFormat.format(double.parse(pfmModel.amount)) + " 원",
            "time": pfmModel.created_at.split("T").last.split(".").first,
            "price": numberFormat.format(double.parse(pfmModel.amount)),
            "point_img": pfmModel.point_img,
          });
        }
      } catch (e) {
        print(e.toString());
      }
    }
    if (obj.isNotEmpty) pfmList.add(obj);

    print(pfmList.toString());

    stopLoading();
  }

  void fetchUserMgmt() async {
    startLoading();

    print("fetchUserMgmt");
    final response = await pmService.getMgmtUser();
    Map<String, dynamic> json = jsonDecode(response);

    print(json);
    dl = json['data']['DL'];
    pay = json['data']['PAY'];

    String date = "";
    Map<String, dynamic> obj = {};
    pumList.clear();

    for (var history in json["data"]['list']) {
      try {
        PointFranModel pfmModel = PointFranModel.fromJson(history);
        print(pfmModel.point_img);
        String time = pfmModel.created_at.split("T").first;
        if (date != time) {
          if (date != "") {
            pumList.add(obj);
            obj = {};
          }
          date = pfmModel.created_at.split("T").first;
          obj["date"] = date;
          obj["history"] = [];
          obj["history"].add({
            "title": pfmModel.type == "DILLING" ? numberFormat.format(double.parse(pfmModel.amount)) + " BZA"
                : numberFormat.format(double.parse(pfmModel.amount)) + " 원",
            "time": pfmModel.created_at.split("T").last.split(".").first,
            "price": demicalFormat.format(double.parse(pfmModel.amount)),
            "point_img": pfmModel.point_img,
            "description": history['description']
          });
        } else {
          print("여기겠지");
          obj["history"].add({
            "title": pfmModel.type == "DILLING" ? numberFormat.format(double.parse(pfmModel.amount)) + " BZA"
                : numberFormat.format(double.parse(pfmModel.amount)) + " 원",
            "time": pfmModel.created_at.split("T").last.split(".").first,
            "price": numberFormat.format(double.parse(pfmModel.amount)),
            "point_img": pfmModel.point_img,
            "description": history['description']
          });
        }
      } catch (e) {
        print(e.toString());
      }
    }
    if (obj.isNotEmpty) pumList.add(obj);

    print(pumList.toString());

    stopLoading();
  }
}