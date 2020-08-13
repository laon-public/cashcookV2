import 'dart:convert';

import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:http/http.dart' as http;
class QRService{
  http.Client client = new http.Client();

  postCreateQR(int price, int dilling, String payment)async{
    print(123);
    Map<String, dynamic> data = {
      "price":price,
      "dilling": dilling,
      "payment": payment,
    };
    final response = await client.post(APIURL+"/payment/request", body: json.encode(data), headers: {
      "Content-Type": "application/json",
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return response.body;
  }

  checkQR(String uuid) async {
    final response = await client.get(APIURL+"/payment/$uuid", headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }

  applyPayment(String uuid) async {
    final response = await client.post(APIURL+"/payment/$uuid/pay", headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });

    return utf8.decode(response.bodyBytes);
  }

  discountPayment(String uuid) async {
    final response = await client.post(APIURL+"/payment/$uuid/discount", headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });

    return utf8.decode(response.bodyBytes);
  }

  confirmPayment(String uuid) async {
    final response = await client.post(APIURL+"/payment/$uuid/confirm", headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }


}