import 'dart:convert';
import 'dart:typed_data';

class StoreModel {
  final int id;
  final String company_name;
  final String business_number;
  final String owner;
  final String tel;
  final String user_id;
  final String create_at;
  final String updated_at;
  final Store store;
  final Address address;
  final Bank bank;
  final Scrap scrap;
  final String status;

  StoreModel(
      {this.id,
      this.company_name,
      this.business_number,
      this.owner,
      this.tel,
      this.user_id,
      this.create_at,
      this.updated_at,
      this.store,
      this.address,
      this.bank,
      this.scrap,
      this.status});

  StoreModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        company_name = json['company_name'],
        business_number = json['business_number'],
        owner = json['owner'],
        tel = json['tel'],
        user_id = json['user_id'],
        create_at = json['create_at'],
        updated_at = json['updated_at'],
        status = json['status'],
        store = Store(
            name: json['store']['name'],
            short_description: json['store']['short_description'],
            description: json['store']['description'],
            tel: json['store']['tel'],
            email: json['store']['email'],
            store_time: json['store']['store_time'],
            useDL: json['store']['useDL'],
            limitDL: json['store']['limitDL'],
            category_code: json['store']['category_code'],
            category_name: json['store']['category_name'],
            category_sub_code: json['store']['category_sub_code'],
            category_sub_name: json['store']['category_sub_name'],
            shop_img1: json['store']['shop_img1'],
            shop_img2: json['store']['shop_img2'],
            shop_img3: json['store']['shop_img3'],
            comment: json['store']['comment'],
            deliveryStatus: json['store']['deliveryStatus'],
            deliveryTime: json['store']['deliveryTime'],
            minOrderAmount: json['store']['minOrderAmount'],
            scope: json['store']['scope']
        ),


        address = Address(
            address: json['address']['address'].split("대한민국 ")[1],
            detail: json['address']['detail'],
            coords: json['address']['coords']),
        bank = Bank(bank: json['bank']['bank'], number: json['bank']['number']),
        scrap = Scrap(scrap: json['scrap']['scrap']);
}

class Store {
  final String name;
  final String short_description;
  final String description;
  final String tel;
  final String email;
  final String store_time;
  final bool useDL;
  final String limitDL;
  final String category_code;
  final String category_name;
  final String category_sub_code;
  final String category_sub_name;
  final String shop_img1;
  final String shop_img2;
  final String shop_img3;
  final String comment;
  final String deliveryStatus;
  final String deliveryTime;
  final String minOrderAmount;
  final double scope;

  Store(
      {this.name,
      this.short_description,
      this.description,
      this.tel,
      this.email,
      this.store_time,
      this.useDL,
      this.limitDL,
      this.category_code,
      this.category_name,
      this.category_sub_code,
      this.category_sub_name,
      this.shop_img1,
      this.shop_img2,
      this.shop_img3,
      this.comment,
      this.deliveryStatus,
      this.deliveryTime,
      this.minOrderAmount,
        this.scope
      });
}

class Address {
  final String address;
  final String detail;
  final String coords;

  Address({this.address, this.detail, this.coords});
}

class Bank {
  final String bank;
  final String number;

  Bank({this.bank, this.number});
}

class Scrap {
  String scrap;

  Scrap({this.scrap});
}

class StoreMinify {
  final int id;
  final String store_name;
  final String store_description;
  final String store_img;
  final int store_dl;
  final double store_scope;
  final String store_cat;
  final String store_sub_cat;
  final String deliveryTime;
  final bool deliveryStatus;
  final String minOrderAmount;
  String scrap;

  StoreMinify.fromJson(Map<String, dynamic> json)
    :
      this.id = json['id'],
      this.store_name = json['store_name'],
      this.store_description = json['store_description'],
      this.store_img = json['store_img'],
      this.store_dl = int.parse(json['store_dl'].toString()),
      this.store_scope = json['store_scope'],
      this.store_cat = json['store_cat'],
      this.store_sub_cat = json['store_sub_cat'],
      this.deliveryTime = json['deliveryTime'],
      this.deliveryStatus = json['deliveryStatus'] != "0",
      this.minOrderAmount = json['minOrderAmount'],
      this.scrap = json['scrap'];
}

