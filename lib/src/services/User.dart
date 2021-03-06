import 'dart:convert';

import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:http/http.dart' as http;

class UserService {
  http.Client client = http.Client();

  Future<String> fetchServiceList(int page) async {
    print("cookURL >>> " + cookURL);
    final response = await client.get(cookURL + "/users/me/service/list?page=$page",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});

    print('리스폰스 테스트 >>> ' + response.toString());
    return utf8.decode(response.bodyBytes);
  }

  Future<String> userSync() async {
    final response = await client.post(cookURL + "/users/me/sync",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getUserAccounts() async {
    final response = await client.get(cookURL + "/users/me/point",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getUserAccountsOne(id) async {
    final response = await client.get(cookURL + "/users/me/accounts/$id",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> postCharge(int quantity, String point, String payment, int dlQuantity) async {
    final response = await client.post(cookURL + "/accounts/charge",
        headers: {"Authorization": "BEARER ${dataStorage.token}","Content-Type": "application/json",},
        body: json.encode({"quantity": quantity, "payment": payment , "point" : point, "dlQuantity" : dlQuantity}));
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getAccountsHistory(String type, page) async {
    final response = await client.get(cookURL + "/users/me/accounts/$type/tx?page=$page", headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> postReco() async {
    final response = await client.post(cookURL+"/users/me/reco/init",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getReco() async {
    final response = await client.get(cookURL+"/users/me/reco/",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });

    return utf8.decode(response.bodyBytes);
  }

  Future<String> postManualReco(idx) async {
    final response = await client.post(cookURL+"/users/me/reco/$idx",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }

  Future<String> withoutReco() async {
    final response = await client.post(cookURL+"/users/me/reco/without",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }

  Future<String> withoutRecoDis() async {
    final response = await client.post(cookURL+"/users/dis/reco/without",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }

  Future<String> withoutRecoAge() async {
    final response = await client.post(cookURL+"/users/age/reco/without",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }

  Future<String> inserDis(username) async {
    final response = await client.post(cookURL+"/users/dis/insert", body: json.encode({"username" : username }),
        headers: {
          "Content-Type": "application/json",
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }

  Future<String> selectDis() async {
    final response = await client.get(cookURL+"/users/dis",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }

  Future<String> selectAge(String username) async {
    final response = await client.get(cookURL+"/users/age?username=$username",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }

  Future<String> exchangeRp(Map<String, String> data) async {
    final response = await client.post(cookURL + "/accounts/exchange",
        headers: {"Authorization": "BEARER ${dataStorage.token}","Content-Type": "application/json",},
        body: json.encode(data));
    return utf8.decode(response.bodyBytes);
  }

  Future<String> recoemberlist() async {

    final response = await client.get(cookURL+"/users/me/reco/memberlist",
      headers: {"Authorization": "BEARER ${dataStorage.token}","Content-Type": "application/json",},);

    return utf8.decode(response.bodyBytes);

  }

  Future<String> recomemberinsert(String selectedmember, String type) async {
    final response = await client.post(cookURL+"/users/me/reco/memberinsert",
      body: json.encode({
        "username" : selectedmember,
        "type" : type
      }),
      headers: {"Authorization": "BEARER ${dataStorage.token}","Content-Type": "application/json",},);

    return utf8.decode(response.bodyBytes);
  }

  Future<String> recognitionSelect() async {
    final response = await client.post(cookURL+"/users/me/reco/recognitionSelect",
      headers: {"Authorization": "BEARER ${dataStorage.token}","Content-Type": "application/json",},);
    return utf8.decode(response.bodyBytes);
  }

  Future<String> changeLimitDL(Map<String, dynamic> data) async {
    final response = await client.patch(cookURL+"/users/me/franchise/limitdl", body: json.encode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "BEARER ${dataStorage.token}"
        });
    return utf8.decode(response.bodyBytes);
  }

  Future<String> selectMyAgency() async {
    final response = await client.get(cookURL+"/users/me/gradeReco/myAgency",
      headers: {"Authorization": "BEARER ${dataStorage.token}","Content-Type": "application/json",},);
    return utf8.decode(response.bodyBytes);
  }

  Future<String> confirmPurchase(int orderId) async {
    final response = await client.patch(cookURL + "/payment/$orderId/confirm", headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });

    return utf8.decode(response.bodyBytes);
  }

  Future<String> requestRefund(Map<String, dynamic> data) async {
    final response = await client.post(cookURL+"/payment/refund", body: json.encode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "BEARER ${dataStorage.token}"
        });
    return utf8.decode(response.bodyBytes);
  }

  Future<String> fetchRefundRequest(int storeId) async {
    final response = await client.get(cookURL+"/payment/refund/$storeId",
        headers: {
          "Authorization": "BEARER ${dataStorage.token}"
        });
    return utf8.decode(response.bodyBytes);
  }

  Future<String> patchRefundRequest(Map<String, dynamic> data) async {
    final response = await client.patch(cookURL+"/payment/refund", body: json.encode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "BEARER ${dataStorage.token}"
        });
    return utf8.decode(response.bodyBytes);
  }

  Future<String> patchFcmToken(String fcmToken) async {
    final response = await client.patch(cookURL + "/users/me/token",
      body: fcmToken,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "BEARER ${dataStorage.token}"
        }
    );

    return utf8.decode(response.bodyBytes);
  }

  Future<String> deleteUser() async {
    final response = await client.post(cookURL+"/users/me/deleteUser", headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }


}