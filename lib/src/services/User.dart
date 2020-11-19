import 'dart:convert';

import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:http/http.dart' as http;

class UserService {
  http.Client client = http.Client();

  Future<String> fetchServiceList(int page) async {
    print("cookURL : " + cookURL);
    final response = await client.get(cookURL + "/users/me/service/list?page=$page",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> userSync() async {
    final response = await client.post(cookURL + "/users/me/sync",
        headers: {"Authorization": "BEARER ${dataStorage.token}"});
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getUserAccounts() async {
    print("cookURL : " + cookURL);
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
    print(1);
    print(type);
    final response = await client.get(cookURL + "/users/me/accounts/$type/tx?page=$page", headers: {"Authorization": "BEARER ${dataStorage.token}"});
    print(response);
    return utf8.decode(response.bodyBytes);
  }

  Future<String> postReco() async {
    final response = await client.post(cookURL+"/users/me/reco/init",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });

    print(response.body);

    return utf8.decode(response.bodyBytes);
  }

  Future<String> getReco() async {
    final response = await client.get(cookURL+"/users/me/reco/",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });

    print(response.body);

    return utf8.decode(response.bodyBytes);
  }

  Future<String> postManualReco(idx) async {
    final response = await client.post(cookURL+"/users/me/reco/$idx",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    print(response.body);
    return utf8.decode(response.bodyBytes);
  }

  Future<String> withoutReco() async {
    final response = await client.post(cookURL+"/users/me/reco/without",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    print(response.body);
    return utf8.decode(response.bodyBytes);
  }

  Future<String> withoutRecoDis() async {
    final response = await client.post(cookURL+"/users/dis/reco/without",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    print(response.body);
    return utf8.decode(response.bodyBytes);
  }

  Future<String> withoutRecoAge() async {
    final response = await client.post(cookURL+"/users/age/reco/without",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    print(response.body);
    return utf8.decode(response.bodyBytes);
  }

  Future<String> inserDis(username) async {
    final response = await client.post(cookURL+"/users/dis/insert", body: json.encode({"username" : username }),
        headers: {
          "Content-Type": "application/json",
      "Authorization": "BEARER ${dataStorage.token}"
    });
    print(response.body);
    return utf8.decode(response.bodyBytes);
  }

  Future<String> selectDis() async {
    final response = await client.get(cookURL+"/users/dis",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    print(response.body);
    return utf8.decode(response.bodyBytes);
  }

  Future<String> selectAge(String username) async {
    final response = await client.get(cookURL+"/users/age?username=$username",headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    print(response.body);
    return utf8.decode(response.bodyBytes);
  }

  Future<String> exchangeRp(Map<String, String> data) async {
    final response = await client.post(cookURL + "/accounts/exchange",
        headers: {"Authorization": "BEARER ${dataStorage.token}","Content-Type": "application/json",},
        body: json.encode(data));
    print(response.body);
    return utf8.decode(response.bodyBytes);
  }

  Future<String> recoemberlist() async {

    final response = await client.get(cookURL+"/users/me/reco/memberlist",
      headers: {"Authorization": "BEARER ${dataStorage.token}","Content-Type": "application/json",},);

    print(response.body);
    return utf8.decode(response.bodyBytes);

  }

  Future<String> recomemberinsert(String selectedmember, String type) async {

    // List<String> selectmember = selectedmember.split('/') ;
    // String name = selectmember[0];
    // String phone = selectmember[1];
    print("recomemberinsert");
    print('확인 : $selectedmember');
    // print('확인 : $phone');
    //실제로 저장 되는 것은 나를 추천한 유저의 아이디 이다.

    // print('확인 : selectedmember');
    final response = await client.post(cookURL+"/users/me/reco/memberinsert",
      body: json.encode({
        "username" : selectedmember,
        "type" : type
      }),
      headers: {"Authorization": "BEARER ${dataStorage.token}","Content-Type": "application/json",},);

    print(response.body);
    return utf8.decode(response.bodyBytes);

  }

  Future<String> recognitionSelect() async {
    print("UserProvider recognitionSelect");
    final response = await client.post(cookURL+"/users/me/reco/recognitionSelect",
      headers: {"Authorization": "BEARER ${dataStorage.token}","Content-Type": "application/json",},);
    return utf8.decode(response.bodyBytes);
  }

  Future<String> changeLimitDL(Map<String, dynamic> data) async {
    print(data.toString());
    final response = await client.patch(cookURL+"/users/me/franchise/limitdl", body: json.encode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "BEARER ${dataStorage.token}"
        });
    print(response.body);
    return utf8.decode(response.bodyBytes);
  }




  Future<String> authRequest() async {
    http.Response response = await client.head(baseUrl + "oauth/authorize?client_id=cashcook&redirect_uri=" + loginSuccessUrl + "&response_type=code" );

    return response.headers['set-cookie'];
  }

  Future<String> authCashcook(String id, String pw, String cookie) async {
    final response = await client.post(baseUrl+"users/login",body: {
      "username" : id,
      "password" : pw,
    }, headers: {
      "Cookie" : cookie,
    });

    print(response.headers.toString());

    print(response.headers['location']);
    if(response.headers['location'] == (baseUrl + "oauth/authorize?client_id=cashcook&redirect_uri=" + loginSuccessUrl + "&response_type=code")) {
      String new_cookie = response.headers['set-cookie'];

      await authSuccess(new_cookie.split(";")[0]);
    }


    print(utf8.decode(response.bodyBytes));

    return utf8.decode(response.bodyBytes);
  }

  Future<String> authSuccess(String cookie) async {
    print("로그인 성공");
    http.Response response = await client.head("http://192.168.1.227/auth_api/oauth/authorize?client_id=cashcook&redirect_uri=http://192.168.1.227/auth_api/users/login/success&response_type=code",
        headers: {
          "Cookie": cookie,
          "Referer": "http://192.168.1.227/auth_api/users/login",
        }
    );
    print(response.headers.toString());

    /*
    JSESSION만 가지고 있으면 code 따기 가능.
    response = await client.head("http://192.168.1.227/auth_api/oauth/authorize?client_id=cashcook&redirect_uri=http://192.168.1.227/auth_api/users/login/success&response_type=code",
        headers: {
          "Cookie": cookie,
          "Referer": "http://192.168.1.227/auth_api/users/login",
        }
    );
     */

    String codeLink = response.headers['location'];
    String code = codeLink.split("code=")[1];

    print(code);

    response = await client.post("$baseUrl/oauth/token", body: {
      "client_id": "cashcook",
      "client_secret": "Laonpp00..L",
      "grant_type": "authorization_code",
      "code": code,
      "scope": "read write",
      "redirect_uri": loginSuccessUrl
    });

    print(response.body.toString());
  }
}