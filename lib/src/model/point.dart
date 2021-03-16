class PointFranModel {
  final String type;
  final String amount;
  final String created_at;
  final String point_img;

  PointFranModel(
      {this.type, this.amount, this.created_at, this.point_img});

  PointFranModel.fromJson(Map<String, dynamic> json)
      : type = json['point_type'],
        amount = json['amount'],
        created_at = json['created_at'],
        point_img = (json['point_type'] == "DILLING") ? "assets/icon/DL 2.png"
              : "assets/resource/public/krw-coin.png";
}

class PointUserModel {
  final String type;
  final String amount;
  final String created_at;
  final String point_img;
  final String description;

  PointUserModel(
      {this.type, this.amount, this.created_at, this.point_img, this.description});

  PointUserModel.fromJson(Map<String, dynamic> json)
      : type = json['point_type'],
        amount = json['amount'],
        created_at = json['created_at'],
        point_img = (json['point_type'] == "DILLING") ?
        "assets/icon/DL 2.png"
            : (json['point_type'] == "R_POINT") ?
        "assets/icon/c_point.png"
            : (json['point_type'] == "AD_POINT") ?
        "assets/icon/adp.png"
            :
        "assets/resource/public/krw-coin.png",
        description = json['description'];
}

class PointReportModel {
  final int base_mday;
  final String base_amount;
  final int sub_mday;
  final String sub_amount;

  PointReportModel({this.base_mday, this.base_amount, this.sub_mday, this.sub_amount});

  PointReportModel.fromJsonMonth(Map<String, dynamic> json)
    : base_mday = json['base_mday'],
      base_amount = json['base_amount'],
      sub_mday = json['sub_mday'],
      sub_amount = json['sub_amount'];

  PointReportModel.fromJsonYear(Map<String, dynamic> json)
      : base_mday = json['base_yday'],
        base_amount = json['base_amount'],
        sub_mday = json['sub_yday'],
        sub_amount = json['sub_amount'];

}