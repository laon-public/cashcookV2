class CatModel {
  String code;
  String code_name;

  CatModel.fromJson(Map<String, dynamic> json)
    : this.code = json['code'],
      this.code_name = json['code_name'];
}

class SubCatModel {
  String code;
  String code_name;

  SubCatModel({this.code, this.code_name});

  SubCatModel.fromJson(Map<String, dynamic> json)
    : this.code = json['sub_code'],
      this.code_name = json['sub_code_name'];
}