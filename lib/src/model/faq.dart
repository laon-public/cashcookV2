class FaqModel {
  int id;
  String question;
  String answer;
  String created_at;
  String updated_at;

  FaqModel(
      {this.id, this.question, this.answer, this.created_at, this.updated_at});

  FaqModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        question = json['question'],
        answer = json['answer'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];
}
