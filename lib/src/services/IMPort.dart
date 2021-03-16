import 'dart:convert';

import 'package:http/http.dart' as http;

class IMPortService {
  http.Client client = new http.Client();

  Future<String> getIMPORTToken() async {
    final response = await client.post("https://api.iamport.kr/users/getToken",
        body: json.encode({
          "imp_key": "1755785518861364",
          "imp_secret": "7ubKAqnJ7SgSMNqUEgwOEbeuOtEgIyzQ3LBEbYoiREbDrBy6R5Uwg914DGklfUciFNXRLlaC0lgrXPyP"
        }),
        headers: {
          "Content-Type": "application/json"
        }
    );

    print(utf8.decode(response.bodyBytes));
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getIMPortHistory(String uid, String token) async {
    final response = await client.get("https://api.iamport.kr/payments/$uid",
        headers: {
          "Authorization": token
        }
    );

    print(utf8.decode(response.bodyBytes));
    return utf8.decode(response.bodyBytes);
  }

  Future<String> refundIMPort(String uid, String reason, String token) async {
    Map<String,String> data = {
      "reason" : "$reason",
      "imp_uid" : "$uid"
    };

    print(json.encode(data));
    
    final response = await client.post("https://api.iamport.kr/payments/cancel",
        body: json.encode(data),
        headers: {
          "Authorization": token,
          "Content-Type": "application/json"
        }
    );

    print(utf8.decode(response.bodyBytes));

    return utf8.decode(response.bodyBytes);
  }
}