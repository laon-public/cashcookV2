import 'dart:convert';

import 'package:cashcook/src/widgets/showToast.dart';
import 'package:http/http.dart';

void sendMessage(String title, String message, String fcmToken, String userType,String status, int orderId) async{
  Client client = Client();

  print("sendMessage : $fcmToken");

  Map<String, dynamic> data = {
      "notification" : {
        "title" : title,
        "body" : message,
        "sound" : "default",
      },
      "priority" : "high",
      "to" : fcmToken,
      "data" : {
        "userType" : userType,
        "status" : status,
        "orderId" : orderId
      }
  };

  Response response = await client.post("https://fcm.googleapis.com/fcm/send",
      body: json.encode(data),
      headers: {
        "Content-Type" : "application/json",
        "Authorization" : "key=AAAAqHmNgG8:APA91bEs03Xl32Or4iwMEvFaQJpbhMb1tX7OW008paCDnytyn0KTQs6gn-k_Mh_r7Wkltxm_uOl9XIzx11vTY3N79aaLTABGTFCR-9p4VJoxjd9hG3Al1bF661CouLiE3xcKgZ4AIkUm"
      }
  );

  if(response.statusCode == 200) {
    // showToast("fcm 성공!");
  }
}