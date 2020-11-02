class ReviewModel {
  int id;
  String username;
  String scope;
  String contents;
  int like;
  int hate;
  String date;
  int isLike;
  int isHate;

  ReviewModel.fromJson(Map<String, dynamic> json)
    :
      this.id = json['id'],
      this.username = json['username'],
      this.scope = json['scope'],
      this.contents = json['contents'],
      this.like = json['like'],
      this.hate = json['hate'],
      this.date = json['date'],
      this.isLike = int.parse(json['isLike']),
      this.isHate = int.parse(json['isHate']);

  ReviewModel.fromJsonScope(Map<String, dynamic> json)
      :
        this.scope = json['scope'];

}