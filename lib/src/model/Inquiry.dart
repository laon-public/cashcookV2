class InquiryModel {
  final int id;
  final int user_id;
  final String title;
  final String contents;
  final String answer;
  final String status;
  final String created_at;
  final String updated_at;

  InquiryModel(
      {this.id,
      this.user_id,
      this.title,
      this.contents,
      this.answer,
      this.status,
      this.created_at,
      this.updated_at});

  InquiryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        user_id = json['user_id'],
        title = json['title'],
        contents = json['contents'],
        answer = json['answer'],
        status = json['status'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];
}
