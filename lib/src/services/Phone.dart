import 'dart:convert';

import 'package:cashcook/src/model/phone.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:http/http.dart';

import 'API.dart';

class PhoneService{
  Client client = new Client();

  Future<String> rebuildPhoneList(List<Map<String,String>> data) async{
    final response = await client.post(cookURL+"/reco/rebuild", body: json.encode(data), headers: {
      "Content-Type": "application/json",
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }
}