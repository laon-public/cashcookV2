class ReviewModel {
  final int id;
  final String username;
  final String scope;
  final String contents;
  final int like;
  final int hate;
  final String date;
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
}