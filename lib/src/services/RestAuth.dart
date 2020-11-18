import 'dart:convert';

import 'package:cashcook/src/services/API.dart';
import 'package:http/http.dart' as http;

class RestAuthService {
  http.Client client = http.Client();

  Future<String> authRequest() async {
    http.Response response = await client.head(baseUrl + "oauth/authorize?client_id=cashcook&redirect_uri=" + loginSuccessUrl + "&response_type=code" );

    return response.headers['set-cookie'].split(";")[0];
  }

  Future<String> authIn(String username, String password, String cookie) async {
    http.Response response = await client.post(baseUrl+"users/login",body: {
      "username" : username,
      "password" : password,
    }, headers: {
      "Cookie" : cookie,
    });

    print(response.headers['location']);
    if(response.headers['location'] == (baseUrl + "oauth/authorize?client_id=cashcook&redirect_uri=" + loginSuccessUrl + "&response_type=code"))
      return response.headers['set-cookie'].split(";")[0];
    else
      return "Error";
  }

  Future<String> getAuthToken(String cookie) async {
    http.Response response = await client.head(baseUrl + "oauth/authorize?client_id=cashcook&redirect_uri=" + loginSuccessUrl + "&response_type=code",
        headers: {
          "Cookie": cookie,
          "Referer": "http://192.168.1.227/auth_api/users/login",
        }
    );

    String codeLink = response.headers['location'];
    String code = codeLink.split("code=")[1];

    response = await client.post("$baseUrl/oauth/token", body: {
      "client_id": "cashcook",
      "client_secret": "Laonpp00..L",
      "grant_type": "authorization_code",
      "code": code,
      "scope": "read write",
      "redirect_uri": loginSuccessUrl
    });

    return utf8.decode(response.bodyBytes);
  }
}