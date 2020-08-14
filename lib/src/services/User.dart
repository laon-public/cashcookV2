import 'dart:convert';

import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserService {
  http.Client client = http.Client();

  Future<String> userSync() async {
    final response = await client.post(APIURL + "/users/me/sync",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getUserAccounts() async {
    print("APIURL : " + APIURL);
    final response = await client.get(APIURL + "/users/me/accounts",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getUserAccountsOne(id) async {
    final response = await client.get(APIURL + "/users/me/accounts/$id",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> postCharge(String id, int quantity, String payment) async {
    final response = await client.post(APIURL + "/accounts/$id/charge",
        headers: {"Authorization": "BEARER ${dataStorage.token}","Content-Type": "application/json",},
        body: json.encode({"quantity": quantity, "payment": payment}));
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getAccountsHistory(String id, page) async {
    print(1);
    final response = await client.get(APIURL + "/users/me/accounts/$id/tx?page=$page", headers: {"Authorization": "BEARER ${dataStorage.token}"});
    print(response);
    return utf8.decode(response.bodyBytes);
  }

  Future<String> postReco() async {
    final response = await client.post(APIURL+"/users/me/reco/init",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });

    print(response.body);

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getReco() async {
    final response = await client.get(APIURL+"/users/me/reco/",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });

    print(response.body);

    return utf8.decode(response.bodyBytes);
  }

  Future<String> postManualReco(idx) async {
    final response = await client.post(APIURL+"/users/me/reco/$idx",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    print(response.body);
    return utf8.decode(response.bodyBytes);
  }

  Future<String> withoutReco() async {
    final response = await client.post(APIURL+"/users/me/reco/without",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    print(response.body);
    return utf8.decode(response.bodyBytes);
  }

  Future<String> exchangeRp(String id, Map<String, String> data) async {
    final response = await client.post(APIURL + "/accounts/$id/exchange",
        headers: {"Authorization": "BEARER ${dataStorage.token}","Content-Type": "application/json",},
        body: json.encode(data));
    print(response.body);
    return utf8.decode(response.bodyBytes);
  }

}
