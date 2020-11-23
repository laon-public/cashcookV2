import 'dart:convert';
import 'dart:io';
import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/datastorage.dart';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class MenuService {
  http.Client client = http.Client();

  Future<String> getStore(String start, String end) async {
    Response response =
        await Dio().get(cookURL + "/franchises?start=$start&end=$end");

    return response.toString();
  }

  Future<String> getCategory() async {
    final response = await client.get(cookURL + "/franchises/category",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getSubCategory(String code) async {
    final response = await client.get(cookURL + "/franchises/subCategory?code=$code",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

}
