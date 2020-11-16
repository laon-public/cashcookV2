import 'dart:convert';

import 'package:cashcook/src/model/payment.dart';
import 'package:cashcook/src/model/qr.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/services/QR.dart';
import 'package:cashcook/src/utils/responseCheck.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QRProvider with ChangeNotifier {
  final QRService service = QRService();
  StoreModel store;
  PaymentModel paymentModel;
  PaymentEditModel paymentEditModel;


  bool isStop = false;

  void changeStop(){
    isStop = !isStop;
    print("changeStop");
    notifyListeners();
  }

  Future<String> postCreateQR(int price, int dilling, String payment) async {
    print("postCreateQR 시작");
    final response = await service.postCreateQR(price, dilling, payment);
    print("postCreateQR 시작2");
    print("response : " + response);
    final jsonResponse = json.decode(response);
    if(isResponse(jsonResponse)){
      QRModel qr = QRModel.fromJson(jsonResponse['data']);
      return qr.uuid;
    }
    return "";
  }

  // Qr 결제 Version 2
  void changeDl() {
    if(paymentEditModel.dlCtrl.text != "" && int.parse(paymentEditModel.dlCtrl.text) >= 0){
        int minusValue = (paymentModel.price -
            (int.parse(paymentEditModel.dlCtrl.text) * 100));
        paymentEditModel.priceCtrl.text = minusValue.toString();
    } else {
      paymentEditModel.priceCtrl.text = paymentModel.price.toString();
    }

    notifyListeners();
  }

  //결제 qr 확인
  Future<String> checkQR(int id,String uuid) async {
    final response = await service.checkQR(id,uuid);
    final jsonResponse = json.decode(response);
    print(jsonResponse);
    if(isResponse(jsonResponse)){
      store = StoreModel.fromJson(jsonResponse['data']['franchise']);
      paymentModel =
          PaymentModel.fromJson(jsonResponse['data']['paymentRequest']);
      paymentEditModel =
          PaymentEditModel.fromJson(jsonResponse['data']['paymentRequest']);
    }else {
      return jsonResponse["resultMsg"];
    }
    print(paymentModel.type);
    return paymentModel.type;
  }

  //결제 요청
  Future<String> applyPayment(String uuid) async {
    isStop = false;
    final response = await service.applyPayment(uuid);
    final jsonResponse = json.decode(response);
    if(isResponse(jsonResponse)){
      Map data = jsonResponse['data'] as Map;
      if (data == {} || data == null || data.isEmpty) {
        Fluttertoast.showToast(msg: "결제가 완료되었습니다.");
        return "1";
      }
      paymentModel =
          PaymentModel.fromJson(jsonResponse['data']['paymentRequest']);
      return "1";
    }
    return "";
  }

  //재흥정시
  Future<bool> discountPayment(String uuid) async {
    isStop = false;
    final response = await service.discountPayment(uuid);
    final jsonResponse = json.decode(response);
    print(jsonResponse);
    if(isResponse(jsonResponse)){
      paymentModel =
          PaymentModel.fromJson(jsonResponse['data']['paymentRequest']);

      notifyListeners();
      return Future.value(true);
    }

    return Future.value(false);
  }

  //결제 할인율 확정
  Future<String> confirmPayment(bool later ,String uuid) async {
    final response = await service.confirmPayment(uuid);
    final jsonResponse = json.decode(response);
    print(jsonResponse);
    if(isResponse(jsonResponse)){
      if(!later){
        Fluttertoast.showToast(msg: "적립이 완료되었습니다.");
      }
      return "1";
    }
  }
}
