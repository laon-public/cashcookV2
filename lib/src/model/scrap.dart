class ScrapModel {
  int id;
  String img;
  String name;
  String description;
  String cat_name;
  String sub_cat_name;
  final double lat;
  final double lng;

  ScrapModel.fromJson(Map<String, dynamic> json)
    :
      this.img = json['shop_img'],
      this.id = json['store_id'],
      this.name = json['store_name'],
      this.description = json['store_short_description'],
      this.cat_name = json['category_name'],
      this.sub_cat_name = json['category_sub_name'],
      this.lat = double.parse(json['latitude']),
      this.lng = double.parse(json['longitude']);
}