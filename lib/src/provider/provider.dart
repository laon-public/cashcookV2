import 'dart:convert';

import 'package:cashcook/src/utils/datastorage.dart';
import 'package:http/http.dart';

class Provider {
  Client client = Client();
  final baseUrl = "http://192.168.100.219/auth_api/";
//    final baseUrl = "http://auth.cashlink.kr/auth_api/";
  String userCheckUrl = "http://192.168.100.219/cook_api/api/users/me";
//    String userCheckUrl = "http://auth.cashlink.kr/cook_api/api/users/me";
  final getToken = "oauth/token";

  Future<String> authToken() async {
    final response = await client.post("$baseUrl$getToken", body: {
      "client_id": "cashcook",
      "client_secret": "Laonpp00..L",
      "grant_type": "authorization_code",
      "code": dataStorage.oauthCode,
      "scope": "read write",
//      "redirect_uri": "https://m.naver.com"
        "redirect_uri": "http://192.168.100.219/auth_api/users/login/success"
    });

    print(utf8.decode(response.bodyBytes));

    return utf8.decode(response.bodyBytes);
  }

  Future<String> authCheck(accessToken) async {
    final response = await client
        .get(userCheckUrl, headers: {"authorization": "Bearer $accessToken"});
    print("---");
    print(utf8.decode(response.bodyBytes));
    return utf8.decode(response.bodyBytes);
  }

}

final provider = Provider();