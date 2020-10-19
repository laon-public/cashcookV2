import 'dart:convert';

import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:http/http.dart';

class PointMgmtService {
  Client client = Client();

  Future<String> getMgmtFran(String viewType) async {
    print("cookURL : " + cookURL);
    final response = await client.get(cookURL + "/users/me/pointmgmt/fran?type=$viewType",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getMgmtUser(String viewType) async {
    print("cookURL : " + cookURL);
    final response = await client.get(cookURL + "/users/me/pointmgmt/user?type=$viewType",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getMgmtOther(String username) async {
    print("cookURL : " + cookURL);
    final response = await client.get(cookURL + "/users/other/accounts?username=$username",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getMgmtBiz(String type) async {
    print("cookURL : " + cookURL);
    final response = await client.get(cookURL + "/users/me/pointmgmt/biz?type=$type",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }
}