import 'dart:convert';

import 'package:cashcook/src/model/page.dart';
import 'package:cashcook/src/model/phone.dart';
import 'package:cashcook/src/model/reco.dart';
import 'package:cashcook/src/model/referrer/referrer.dart';
import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/services/Reco.dart';
import 'package:cashcook/src/utils/responseCheck.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecoProvider with ChangeNotifier {
  final service = RecoService();

//  List<RecoModel> reco = [];
  List<Referrer> referrer = [];
  int allCount = 0;
  int dirAmount = 0;
  int inDirAmount = 0;
  String typeTitle = "전체추천회원 ";

  Pageing pageing = null;
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  void fetchReco(page, type, UserCheck loginUser) async {
    if (page == 0) referrer.clear();
    final response = await service.fetchReco(page, type);
    Map<String, dynamic> recoJson = jsonDecode(response);
    if(isResponse(recoJson)){
      pageing = Pageing.fromJson(recoJson['data']['paging']);
      allCount = recoJson['data']['allCount'];
      dirAmount = recoJson['data']['dirAmount'];
      inDirAmount = recoJson['data']['inDirAmount'];
      for (var recoList in recoJson['data']['list']) {
        RecoModel tmp = RecoModel.fromJson(recoList);
        if(loginUser.username == tmp.parent.username) {
          referrer.add(Referrer(
              name: tmp.child.name,
              phone: tmp.child.phone,
              type: 0,
              byName: "me",
              date: tmp.created_at.split("T").first));
        } else {
          referrer.add(Referrer(
              name: tmp.child.name,
              phone: tmp.child.phone,
              type: 1,
              byName: tmp.parent.name,
              date: tmp.created_at.split("T").first));
        }
      }
      print(referrer);
    }

    if(type == "all") {
      typeTitle = "전체추천회원 ";
    } else if(type == "dir") {
      typeTitle = "직접추천회원 ";
    } else if(type == "inDir") {
      typeTitle = "간접추천회원 ";
    }

    stopLoading();
    notifyListeners();
  }

  Future<String> postReco(List<PhoneModel> phoneList) async {
    List<Map<String, String>> data = [];

    phoneList.forEach((phone) {
      if(phone.isCheck) {
        data.add({"name": phone.name, "phone": phone.phone});
      }
    });

    final response = await service.postReco(data);
    Map<String, dynamic> json = jsonDecode(response);
    if(isResponse(json)){
      return "true";
    }
    return json['resultMsg'];
  }

}
