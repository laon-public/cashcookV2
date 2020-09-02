import 'dart:convert';

import 'package:cashcook/src/utils/datastorage.dart';
import 'package:http/http.dart';

import 'API.dart';

class RecoService{
  Client client = new Client();

  Future<String> postReco(Map<String, dynamic> data) async{
    final response = await client.post(cookURL+"/reco", body: json.encode(data), headers: {
      "Content-Type": "application/json",
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }

  Future<String> fetchReco(page) async {
    final response = await client.get(cookURL + "/reco?page=$page", headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }
}