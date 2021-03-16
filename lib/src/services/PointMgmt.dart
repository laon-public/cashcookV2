import 'dart:convert';

import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:http/http.dart';

class PointMgmtService {
  Client client = Client();

  Future<String> getMgmtFran(String viewType, int page) async {
    final response = await client.get(cookURL + "/users/me/pointmgmt/fran?type=$viewType&page=$page",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getMgmtUser(String viewType) async {
    final response = await client.get(cookURL + "/users/me/pointmgmt/user?type=$viewType",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getMgmtOther(String username) async {
    final response = await client.get(cookURL + "/users/other/accounts?username=$username",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getMgmtBiz(String type) async {
    final response = await client.get(cookURL + "/users/me/pointmgmt/biz?type=$type",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }
}