class CatModel {
  final String code;
  final String code_name;

  CatModel({this.code, this.code_name});

  CatModel.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        code_name = json['code_name'];

  CatModel.fromJsonBySub(Map<String, dynamic> json)
      : code = json['sub_code'],
        code_name = json['sub_code_name'];
}
