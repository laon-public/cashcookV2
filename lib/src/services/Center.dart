import 'dart:convert';

import 'package:cashcook/src/utils/datastorage.dart';
import 'package:dio/dio.dart';

import 'API.dart';
import 'package:http/http.dart';

class CenterService{
 Client client = new Client();

 Future<String> getFaq(page) async {
   final response = await client.get(cookURL+"/faq?page=$page",);

   return utf8.decode(response.bodyBytes);
 }
 Future<String> getNotice(page) async {
   final response = await client.get(cookURL+"/notices?page=$page");

   return utf8.decode(response.bodyBytes);
 }

 Future<String> postInquiry(Map<String, String> data) async {
   final response = await client.post(cookURL+"/inquiries", body: json.encode(data), headers: {
     "Content-Type": "application/json",
     "Authorization": "BEARER ${dataStorage.token}"
   });
   return utf8.decode(response.bodyBytes);
 }

 Future<String> getInquiry(page) async {
   print("get");
   print(dataStorage.token);
 final response = await Dio().get(cookURL+"/inquiries/me?page=$page", options: Options(
   headers: {
     "Authorization": "BEARER ${dataStorage.token}"
   }
 ));
 return response.toString();
 }
}