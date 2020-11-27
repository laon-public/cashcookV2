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
  List<PointReportModel> pfmList_my = [];
  List<Map<String,dynamic>> pumList = [];
  List<PointReportModel> pumList_my = [];
  List<Map<String,dynamic>> pomList = [];
  List<PointReportModel> pbmList = [];
  int adp = 0;
  int pay = 0;
  int dl = 0;
  int rp = 0;
  int franAmount = 0;
  bool isLastPage = false;


  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  void fetchFranMgmt(String viewType, int page) async {
      pfmList_my.clear();
      if(page == 1){
        pfmList.clear();
      }
    startLoading();

    print("fetchFranMgmt");
    final response = await pmService.getMgmtFran(viewType, page);
    Map<String, dynamic> json = jsonDecode(response);

    print(json);
    adp = json['data']['ADP'];
    dl = json['data']['DL'];
    pay = json['data']['PAY'];
    disMap = json['data']['dis'];
    ageMap = json['data']['age'];

    print("====================> ${json['data']['age']}");

    String date = "";
    Map<String, dynamic> obj = {};

      isLastPage = (json["data"]["list"] as List).length == 0;
      if(viewType == "day"){
      for (var history in json["data"]['list']) {
        try {
          PointFranModel pfmModel = PointFranModel.fromJson(history);
          print(pfmModel.point_img);
          String time = pfmModel.created_at.split("T").first;
          int existIdx = pfmList.indexWhere((pfm) => pfm["date"] == time);

          print("ExistIdx ========> $existIdx");
          if (existIdx == -1) {
            obj = {};
            date = pfmModel.created_at.split("T").first;
            obj["date"] = date;
            obj["history"] = [];
            obj["history"].add({
              "title": pfmModel.type == "DILLING" ? numberFormat.format(double.parse(pfmModel.amount)) + " DL"
                  : numberFormat.format(double.parse(pfmModel.amount)) + " 원",
              "time": pfmModel.created_at.split("T").last.split(".").first,
              "price": demicalFormat.format(double.parse(pfmModel.amount)),
              "point_img": pfmModel.point_img,
            });
            pfmList.add(obj);
          } else {
            pfmList[existIdx]["history"].add({
              "title": pfmModel.type == "DILLING" ? numberFormat.format(double.parse(pfmModel.amount)) + " DL"
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
      // if (obj.isNotEmpty) pfmList.add(obj);

      print(pfmList.toString());
    } else if(viewType == "month") {
      for (var history in json["data"]['list']) {
        try {
          pfmList_my.add(PointReportModel.fromJsonMonth(history));
        } catch (e) {
          print(e.toString());
        }
      }

      print(pfmList_my.toString());
    } else if(viewType == "year") {
      for (var history in json["data"]['list']) {
        try {
          pfmList_my.add(PointReportModel.fromJsonYear(history));
        } catch (e) {
          print(e.toString());
        }
      }

      print(pfmList_my.toString());
    }


    stopLoading();
  }

  void fetchUserMgmt(String viewType) async {
    pumList.clear();
    pumList_my.clear();

    startLoading();

    print("fetchUserMgmt");
    final response = await pmService.getMgmtUser(viewType);
    Map<String, dynamic> json = jsonDecode(response);

    print(json);
    dl = json['data']['DL'];
    pay = json['data']['PAY'];

    String date = "";
    Map<String, dynamic> obj = {};

    if(viewType == 'day'){
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
              "title": pfmModel.type == "DILLING" ? numberFormat.format(double.parse(pfmModel.amount)) + " DL"
                  : numberFormat.format(double.parse(pfmModel.amount)) + " 원",
              "type": pfmModel.type == "DILLING" ? " DL"
                  : "PAY",
              "time": pfmModel.created_at.split("T").last.split(".").first,
              "price": demicalFormat.format(double.parse(pfmModel.amount)),
              "point_img": pfmModel.point_img,
              "description": history['description']
            });
          } else {
            obj["history"].add({
              "title": pfmModel.type == "DILLING" ? numberFormat.format(double.parse(pfmModel.amount)) + " DL"
                  : numberFormat.format(double.parse(pfmModel.amount)) + " 원",
              "type": pfmModel.type == "DILLING" ? " DL"
                  : "PAY",
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
    } else if(viewType == "month") {
      for (var history in json["data"]['list']) {
        try {
          pumList_my.add(PointReportModel.fromJsonMonth(history));
        } catch (e) {
          print(e.toString());
        }
      }

      print(pumList_my.toString());
    } else if(viewType == "year") {
      for (var history in json["data"]['list']) {
        try {
          pumList_my.add(PointReportModel.fromJsonYear(history));
        } catch (e) {
          print(e.toString());
        }
      }

      print(pumList_my.toString());
    }

    stopLoading();
  }

  void fetchBizMgmt(String viewType) async {
    pbmList.clear();
    startLoading();

    print("fetchUserMgmt");
    final response = await pmService.getMgmtBiz(viewType);
    Map<String, dynamic> json = jsonDecode(response);

    print(json);

    if(viewType == "month") {
      for (var history in json["data"]['list']) {
        try {
          pbmList.add(PointReportModel.fromJsonMonth(history));
        } catch (e) {
          print(e.toString());
        }
      }

      print(pbmList.toString());
    } else if(viewType == "year") {
      for (var history in json["data"]['list']) {
        try {
          pbmList.add(PointReportModel.fromJsonYear(history));
        } catch (e) {
          print(e.toString());
        }
      }

      print(pbmList.toString());
    }

    stopLoading();
  }

  void fetchMgmtOther(String username) async {
    adp = 0;
    rp = 0;
    dl = 0;
    franAmount = 0;
    startLoading();

    print("fetchMgmtOther");
    final response = await pmService.getMgmtOther(username);
    Map<String, dynamic> json = jsonDecode(response);

    print(json);

    adp = json['data']['ADP'];
    rp = json['data']['RP'];
    dl = json['data']['DL'];
    franAmount = json['data']['franAmount'];

    String date = "";
    Map<String, dynamic> obj = {};
    pomList.clear();

    for (var history in json["data"]['list']) {
        try {
          PointUserModel pomModel = PointUserModel.fromJson(history);
          String time = pomModel.created_at.split("T").first;
          if (date != time) {
            if (date != "") {
              pumList.add(obj);
              obj = {};
            }
            date = pomModel.created_at.split("T").first;
            obj["date"] = date;
            obj["history"] = [];
            obj["history"].add({
              "title" : (pomModel.type == "DILLING") ?
              numberFormat.format(double.parse(pomModel.amount)) + " DL"
                  : (pomModel.type == "R_POINT") ?
              numberFormat.format(double.parse(pomModel.amount)) + " RP"
                  : (pomModel.type == "AD_POINT") ?
              numberFormat.format(double.parse(pomModel.amount)) + " ADP"
                  :
              numberFormat.format(double.parse(pomModel.amount)) + " 원",
              "time": pomModel.created_at.split("T").last.split(".").first,
              "point_img": pomModel.point_img,
              "description": history['description']
            });
          } else {
            obj["history"].add({
              "title" : (pomModel.type == "DILLING") ?
              numberFormat.format(double.parse(pomModel.amount)) + " DL"
                  : (pomModel.type == "R_POINT") ?
              numberFormat.format(double.parse(pomModel.amount)) + " RP"
                  : (pomModel.type == "AD_POINT") ?
              numberFormat.format(double.parse(pomModel.amount)) + " ADP"
                  :
              numberFormat.format(double.parse(pomModel.amount)) + " 원",
              "time": pomModel.created_at.split("T").last.split(".").first,
              "point_img": pomModel.point_img,
              "description": history['description']
            });
          }
        } catch (e) {
          print(e.toString());
        }
      }

    if (obj.isNotEmpty) pomList.add(obj);

    stopLoading();
  }
}