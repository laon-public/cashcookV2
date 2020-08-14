import 'dart:convert';

import 'package:cashcook/src/model/place.dart';
import 'package:cashcook/src/services/API.dart';
import 'package:http/http.dart' as http;
class SearchService{
  http.Client client = new http.Client();

  Future<List> getSearchList(String query) async {
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = 'establishment';
    String url =
        '$baseUrl?input=$query&key=AIzaSyCRO8sSK3KhbmVE7XjcsmQdbQAvDy0Yyjo&type=$type&language=ko&components=country:kr';
    // 구글 지도 api 키 서버용은 따로 라온에서 발급받아서 key= 값에 넣을것

    final http.Response response = await http.get(url);
    final responseData = json.decode(response.body);
    final predictions = responseData['predictions'];

    List<Place> suggestions = [];

    for (int i = 0; i < predictions.length; i++) {
      final place = Place.fromJson(predictions[i]);
      suggestions.add(place);
    }

    return suggestions;
  }

  Future<PlaceDetail> getPlaceDetail(String placeId) async {
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/details/json';
    String url =
        '$baseUrl?key=AIzaSyCRO8sSK3KhbmVE7XjcsmQdbQAvDy0Yyjo&place_id=$placeId&language=ko';

    final http.Response response = await http.get(url);
    final responseData = json.decode(response.body);
    final result = responseData['result'];

    final PlaceDetail placeDetail = PlaceDetail.fromJson(result);
    print(placeDetail.toMap());

    return placeDetail;
  }
}