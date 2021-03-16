import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/usercheck.dart';
import 'package:flutter/cupertino.dart';

class PaymentModel{
  final String uuid;
  final int user_id;
  final int target_id;
  final int price;
  final String dilling;
   String discount;
  final String type;
  final String status;
  final String expired_at;
  final String created_at;
  final String updated_at;

  PaymentModel(
      {this.uuid,
      this.user_id,
      this.target_id,
      this.price,
      this.dilling,
      this.discount,
      this.type,
      this.status,
      this.expired_at,
      this.created_at,
      this.updated_at});

  PaymentModel.fromJson(Map<String, dynamic> json):
      uuid = json['uuid'],
        user_id = json['user_id'],
        target_id = json['target_id'],
        price = json['price'],
        dilling = json['dilling'],
        discount = json['discount'],
        type = json['type'],
        status = json['status'],
        expired_at = json['expired_at'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];
}

class PaymentEditModel {
  TextEditingController dlCtrl;
  TextEditingController priceCtrl;

  PaymentEditModel.fromJson(Map<String, dynamic> json)
    :
      this.dlCtrl = TextEditingController(text: "0"),
      this.priceCtrl = TextEditingController(text: json['price'].toString());
}
