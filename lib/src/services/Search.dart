import 'dart:convert';

import 'package:cashcook/src/model/place.dart';
import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:http/http.dart' as http;
class SearchService{
  http.Client client = new http.Client();

  Future<String> getGoogleSearch(String query) async {
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = 'geocode';
    String url =
        '$baseUrl?input=$query&key=AIzaSyCRO8sSK3KhbmVE7XjcsmQdbQAvDy0Yyjo&type=$type&language=ko&components=country:kr';
    // 구글 지도 api 키 서버용은 따로 라온에서 발급받아서 key= 값에 넣을것

    final http.Response response = await http.get(url);
    return response.body;
  }

  Future<String> getStoreSearch(String query, String start, String end) async {
    final response = await client.get(cookURL+"/franchises/store?query=$query&start=$start&end=$end", headers: {
      "Authorization": "BEARER ${dataStorage.token}"
    });
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getPlaceDetail(String placeId) async {
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/details/json';
    String url =
        '$baseUrl?key=AIzaSyCRO8sSK3KhbmVE7XjcsmQdbQAvDy0Yyjo&place_id=$placeId&language=ko';

    final http.Response response = await http.get(url);

    return response.body;
  }
}