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
        point_img = (json['point_type'] == "DILLING") ? "assets/icon/bza.png"
              : "assets/icon/QR.png";
}