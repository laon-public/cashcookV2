import 'dart:convert';
import 'dart:io';
import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/datastorage.dart';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class StoreService {
  http.Client client = http.Client();

  Future<String> getStore(String start, String end) async {
    Response response =
        await Dio().get(cookURL + "/franchises?start=$start&end=$end",
            options: Options(
              headers: {"Authorization": "BEARER ${dataStorage.token}"},
            ));

    return response.toString();
  }

  Future<bool> postStore(FormData formData) async {
    try {
      Response response = await Dio().post(cookURL + "/franchises",
          data: formData,
          options: Options(
            headers: {"Authorization": "BEARER ${dataStorage.token}"},
          ));
      print(response);
      print(response.toString());
      print(response.statusCode);
      print(response.statusMessage);

      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> patchStore(Map<String, String> data, String bn_path) async {
    FormData formData = new FormData();
    if (bn_path != "") {
      formData = new FormData.fromMap({
        "business_license": await MultipartFile.fromFile(bn_path),
      });
    }

    (data['shop_uri1'] != null && data['shop_uri1'] != "") ? formData.files.add(MapEntry("new_shop_img1", MultipartFile.fromFileSync(data['shop_uri1']))) : print("no Shop img1");
    (data['shop_uri2'] != null && data['shop_uri2'] != "") ? formData.files.add(MapEntry("new_shop_img2", MultipartFile.fromFileSync(data['shop_uri2']))) : print("no Shop img2");
    (data['shop_uri3'] != null && data['shop_uri3'] != "") ? formData.files.add(MapEntry("new_shop_img3", MultipartFile.fromFileSync(data['shop_uri3']))) : print("no Shop img3");

    formData.fields.addAll(data.entries);
    print(formData.fields);
    print(formData.files);
    try {
      Response response = await Dio()
          .patch(cookURL + "/users/me/franchise",
              data: formData,
              options: Options(
                headers: {"Authorization": "BEARER ${dataStorage.token}"},
              ));
      print(response);
      print(response.toString());
      print(response.statusCode);
      print(response.statusMessage);

      if (response.statusCode >= 200 && response.statusCode < 400) {
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<String> getCategory() async {
    print("cookURL : " + cookURL);
    final response = await client.get(cookURL + "/franchises/category",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getSubCategory(String code) async {
    print("cookURL : " + cookURL);
    final response = await client.get(cookURL + "/franchises/subCategory?code=$code",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> fetchOrderList(int storeId, int page) async {
    final response = await client.get(cookURL + "/franchises/orderlist/$storeId",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> patchOrder(Map<String, dynamic> data) async {
    final response = await client.patch(cookURL + "/franchises/order",
      body: json.encode(data),
        headers: {
            "Content-Type" : "application/json",
            "Authorization": "BEARER ${dataStorage.token}"
        }
    );

    return utf8.decode(response.bodyBytes);
  }

}
