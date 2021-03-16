import 'dart:convert';

import 'package:cashcook/src/services/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class AuthProvider with ChangeNotifier {
  Client client = Client();

  Future<String> authToken(String code) async {
    final response = await client.post(baseUrl + "/oauth/token", body: {
      "client_id": "cashcook",
      "client_secret": "Laonpp00..L",
      "grant_type": "authorization_code",
      "code": code,
      "scope": "read write",
      "redirect_uri": loginSuccessUrl
    });

    print(utf8.decode(response.bodyBytes));

    return utf8.decode(response.bodyBytes);
  }

  Future<String> authCheck(String accessToken) async {
    final response = await client
        .get(cookURL + "/users/me", headers: {"authorization": "Bearer $accessToken"});
    print("---");
    print(utf8.decode(response.bodyBytes));
    return utf8.decode(response.bodyBytes);
  }
}