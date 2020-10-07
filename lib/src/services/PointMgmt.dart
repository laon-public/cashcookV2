import 'dart:convert';

import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:http/http.dart';

class PointMgmtService {
  Client client = Client();

  Future<String> getMgmtFran() async {
    print("cookURL : " + cookURL);
    final response = await client.get(cookURL + "/users/me/pointmgmt/fran",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getMgmtUser() async {
    print("cookURL : " + cookURL);
    final response = await client.get(cookURL + "/users/me/pointmgmt/user",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }
}