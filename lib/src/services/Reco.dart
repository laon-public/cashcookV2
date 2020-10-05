import 'dart:convert';

import 'package:cashcook/src/utils/datastorage.dart';
import 'package:http/http.dart';

import 'API.dart';

class RecoService{
  Client client = new Client();

  Future<String> postReco(List<Map<String,String>> data) async{
    print("hi");
    final response = await client.post(cookURL+"/reco", body: json.encode(data), headers: {
      "Content-Type": "application/json",
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }

  Future<String> fetchReco(page, type) async {
    final response = await client.get(cookURL + "/reco?page=$page&type=$type", headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }

}