import 'dart:convert';

import 'package:cashcook/src/services/RestAuth.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider with ChangeNotifier {
    RestAuthService service = RestAuthService();

    // view Controller Variable
    bool isLoading = false;

    // auth Controll Variable
    String cookie;
    bool isAuthing = false;
    bool isSuccess = false;
    bool isError = false;
    bool isEnd = false;

    // Register Store
    Map<String, String> registerForm = {
      "username" : "",
      "password" : "",
      "password_confirm" : "",
      "name" : "",
      "year" : "",
      "month" : "",
      "day" : "",
      "csrf" : "",
      "phone" : "",
      "sex" : "MAN",
      "clientId" : "CASHCOOK",
    };

    void startLoading() {
      isLoading = true;

      notifyListeners();
    }

    void stopLoading() {
      isLoading = false;

      notifyListeners();
    }

    void startAuthing() {
      isAuthing = true;

      notifyListeners();
    }

    void stopAuthing() {
      isAuthing = false;

      notifyListeners();
    }

    void setEnd(bool value) {
      isEnd = value;

      notifyListeners();
    }

    void authRequest() async {
      isSuccess = false;
      isError = false;
      startLoading();

      cookie = await service.authRequest();

      stopLoading();
    }

    void changeFormValue(key,value) {
      registerForm[key] = value;

      print(registerForm.toString());

      notifyListeners();
    }

    void authIn(String username, String password) async {
      startAuthing();

      cookie = await service.authIn(username, password, cookie);
      if(cookie == "Error") {
        isError = true;
        stopAuthing();

        return;
      }

      String response = await service.getAuthToken(cookie);
      Map<String,dynamic> json = jsonDecode(response);

      dataStorage.token = json['access_token'];
      isSuccess = true;

      stopAuthing();
    }

    void authRegister() async {

      final response = await service.authRegister(registerForm, cookie);

    }

    void requestSms() async {
      final response = await service.requestSms(registerForm["phone"], cookie);
    }
}