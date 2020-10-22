import 'dart:convert';

import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:http/http.dart' as http;
class StoreService{
  http.Client client = new http.Client();

  orderPayment(int pay, int store_user, String type, int dl)async{
    Map<String, dynamic> data = {
      "pay":pay,
      "store_user": store_user,
      "type": type,
      "dl" : dl
    };
    final response = await client.post(cookURL+"/payment/orderPay", body: json.encode(data), headers: {
      "Content-Type": "application/json",
      "Authorization": "BEARER ${dataStorage.token}"
    });

    return response.body;
  }

  fetchMenu(int store_id) async {
    final response = await client.get(cookURL+"/franchises/menu?store_id=$store_id", headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });

    return utf8.decode(response.bodyBytes);
  }

  fetchReview(int store_id) async {
    final response = await client.get(cookURL+"/franchises/review?store_id=$store_id", headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });

    return utf8.decode(response.bodyBytes);
  }

  insertReview(int store_id, int scope, String contents)async{
    Map<String, dynamic> data = {
      "store_id": store_id,
      "scope": scope,
      "contents": contents
    };
    final response = await client.post(cookURL+"/franchises/review", body: json.encode(data), headers: {
      "Content-Type": "application/json",
      "Authorization": "BEARER ${dataStorage.token}"
    });

    return response.body;
  }

  patchReview(int review_id,String type, String subtype) async{
    Map<String, dynamic> data = {
      "review_id" : review_id,
      "type" : type,
      "subtype" : subtype
    };
    final response = await client.patch(cookURL+"/franchises/review", body: json.encode(data), headers: {
      "Content-Type": "application/json",
      "Authorization": "BEARER ${dataStorage.token}"
    });

    return response.body;
  }

  fetchCategory() async {
    final response = await client.get(cookURL+"/franchises/category", headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });

    return utf8.decode(response.bodyBytes);
  }

  fetchSubCategory(String code) async {
    final response = await client.get(cookURL+"/franchises/category/sub?code=$code", headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });

    return utf8.decode(response.bodyBytes);
  }

  postMenu(List<Map<String, dynamic>> menuData) async {
    final response = await client.post(cookURL+"/franchises/menu", body: json.encode(menuData), headers: {
      "Content-Type": "application/json",
      "Authorization": "BEARER ${dataStorage.token}"
    });

    return utf8.decode(response.bodyBytes);
  }

  patchMenu(List<Map<String, dynamic>> menuData) async {
    final response = await client.patch(cookURL+"/franchises/menu", body: json.encode(menuData), headers: {
      "Content-Type": "application/json",
      "Authorization": "BEARER ${dataStorage.token}"
    });

    return utf8.decode(response.bodyBytes);
  }

  doScrap(String store_id) async {
    final response = await client.post(cookURL+"/franchises/scrap", body: json.encode({
      "store_id" : store_id
    }), headers: {
      "Content-Type": "application/json",
      "Authorization": "BEARER ${dataStorage.token}"
    });

    return utf8.decode(response.bodyBytes);
  }

  readScrap() async {
    final response = await client.get(cookURL+"/franchises/scrap", headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });

    return utf8.decode(response.bodyBytes);
  }
}