class RefundLogModel {
  int id;
  int orderId;
  int storeId;
  String impUid;
  String reason;
  int pay;
  String status;

  DateTime createdAt;
  DateTime updatedAt;

  RefundLogModel.fromJson(Map<String, dynamic> json)
    :
      this.id = json['id'],
      this.orderId = json['orderId'],
      this.storeId = json['storeId'],
      this.impUid = json['impUid'],
      this.reason = json['reason'],
      this.pay = json['pay'],
      this.status = json['status'],
      this.createdAt = DateTime.parse(json['createdAt'].toString()),
      this.updatedAt = DateTime.parse(json['updatedAt'].toString());
}