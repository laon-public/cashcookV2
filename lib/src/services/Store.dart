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

  Future<bool> patchStore(Map<String, String> data, String bn_path,
      String shop1_path, String shop2_path, String shop3_path) async {
    FormData formData = new FormData();
    if (bn_path != "") {
      formData = new FormData.fromMap({
        "business_license": await MultipartFile.fromFile(bn_path),
      });
    }

    (shop1_path != "" && shop1_path != null) ? formData.files.add(MapEntry("new_shop_img1", MultipartFile.fromFileSync(shop1_path))) : print("no Shop img1");
    (shop2_path != "" && shop2_path != null) ? formData.files.add(MapEntry("new_shop_img2", MultipartFile.fromFileSync(shop2_path))) : print("no Shop img2");
    (shop3_path != "" && shop3_path != null) ? formData.files.add(MapEntry("new_shop_img3", MultipartFile.fromFileSync(shop3_path))) : print("no Shop img3");

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

}
