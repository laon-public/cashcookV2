import 'dart:convert';
import 'dart:io';

import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/datastorage.dart';

//import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class StoreService {
  Future<String> getStore(String start, String end) async {
    Response response =
        await Dio().get(APIURL + "/franchises?start=$start&end=$end");

    return response.toString();
  }

  Future<bool> postStore(Map<String, String> data, String bn_path,
      String shop1_path, String shop2_path, String shop3_path) async {
    FormData formData = new FormData.fromMap({
      "business_license": await MultipartFile.fromFile(bn_path),
    });
    formData.files.addAll([
      MapEntry("shop_images", MultipartFile.fromFileSync(shop1_path)),
      MapEntry("shop_images", MultipartFile.fromFileSync(shop2_path)),
      MapEntry("shop_images", MultipartFile.fromFileSync(shop3_path)),
    ]);

    formData.fields.addAll(data.entries);
    print(formData.fields);
    print(formData.files);
    try {
      Response response = await Dio().post(APIURL + "/franchises",
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

    if (shop1_path != "" && shop2_path != "" && shop3_path != "") {
      formData.files.addAll([
        MapEntry("shop_images", MultipartFile.fromFileSync(shop1_path)),
        MapEntry("shop_images", MultipartFile.fromFileSync(shop2_path)),
        MapEntry("shop_images", MultipartFile.fromFileSync(shop3_path)),
      ]);
    }

    formData.fields.addAll(data.entries);
    print(formData.fields);
    print(formData.files);
    try {
      Response response = await Dio()
//          .patch("http://192.168.100.237:8008/cook_api/api/users/me/franchise",
            .patch("http://192.168.100.215:8008/cook_api/api/users/me/franchise",
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
}
