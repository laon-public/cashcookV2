class ContentModel {
  int id;
  int storeId;
  String imgUrl;

  ContentModel.fromJson(Map<String, dynamic> json)
    :
      this.id = json['id'],
      this.storeId = json['storeId'],
      this.imgUrl = json['imgUrl'];
}