class QRModel {
  final String expired_at;
  final String uuid;

  QRModel(this.expired_at, this.uuid);

  QRModel.fromJson(Map<String, dynamic> json)
      : expired_at = json['expired_at'],
        uuid = json['uuid'];
}
