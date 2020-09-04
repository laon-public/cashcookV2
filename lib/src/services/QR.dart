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
    final response = await client.post(cookURL+"/payment/request", body: json.encode(data), headers: {
      "Content-Type": "application/json",
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return response.body;
  }

  checkQR(int id,String uuid) async {
    final response = await client.get(cookURL+"/payment/$id/$uuid", headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }

  applyPayment(String uuid) async {
    final response = await client.post(cookURL+"/payment/$uuid/pay", headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });

    return utf8.decode(response.bodyBytes);
  }

  discountPayment(String uuid) async {
    final response = await client.post(cookURL+"/payment/$uuid/discount", headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });

    return utf8.decode(response.bodyBytes);
  }

  confirmPayment(String uuid) async {
    final response = await client.post(cookURL+"/payment/$uuid/confirm", headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }


}