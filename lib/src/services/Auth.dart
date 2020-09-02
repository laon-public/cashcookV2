import 'dart:convert';
import 'package:cashcook/src/utils/datastorage.dart';

import 'package:cashcook/src/services/API.dart';
import 'package:http/http.dart' as http;

class AuthService{
  http.Client client = http.Client();
  String userCheckUrl = "/users/me";
  final getToken = "oauth/token";

  Future<String> authToken() async {
//    final response = await client.post("$baseUrl$getToken", body: {
    final response = await client.post("$baseUrl$getToken", body: {
      "client_id": "cashcook",
      "client_secret": "Laonpp00..L",
      "grant_type": "authorization_code",
      "code": dataStorage.oauthCode,
      "scope": "read write",
        "redirect_uri": "https://m.naver.com"
    });

    print(utf8.decode(response.bodyBytes));

    return utf8.decode(response.bodyBytes);
  }

  Future<String> authCheck(accessToken) async {
    final response = await client
        .get(userCheckUrl, headers: {"authorization": "Bearer $accessToken"});

    return utf8.decode(response.bodyBytes);
  }
}