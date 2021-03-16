class NoticeModel {
  int id;
  String title;
  String contents;
  String created_at;
  String updated_at;

  NoticeModel(
      {this.id, this.title, this.contents, this.created_at, this.updated_at});

  NoticeModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        contents = json['contents'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];
}
