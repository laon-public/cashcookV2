class Place {
  final String description;
  String placeId;
  PlaceDetail pd;
  String type;

  Place({this.description, this.placeId});

  Place.fromStoreJson(Map<String, dynamic> json)
      : this.description = json['description'],
        this.pd = PlaceDetail.fromStoreJson(json),
        this.type = "store";

  Place.fromGoogleJson(Map<String, dynamic> json)
      : this.description = json['description'].toString().contains("대한민국") ? json['description'].toString().split("대한민국")[1] :  json['description'].toString() ,
        this.placeId = json['place_id'],
        this.type = "google";

  Map<String, dynamic> toMap() {
    return {
      'description': this.description,
      'placeId': this.placeId,
    };
  }
}

class PlaceDetail {
  String placeId;
  final double lat;
  final double lng;

  PlaceDetail({
    this.placeId,
    this.lat,
    this.lng,
  });

  PlaceDetail.fromGoogleJson(Map<String, dynamic> json)
      : this.placeId = json['place_id'],
        this.lat = json['geometry']['location']['lat'],
        this.lng = json['geometry']['location']['lng'];

  PlaceDetail.fromStoreJson(Map<String, dynamic> json)
      : this.lat = double.parse(json['latitude'].toString()),
        this.lng = double.parse(json['longitude'].toString());

  Map<String, dynamic> toMap() {
    return {
      'placeId': this.placeId,
      'lat': this.lat,
      'lng': this.lng,
    };
  }
}