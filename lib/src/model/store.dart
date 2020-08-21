import 'dart:convert';
import 'dart:typed_data';

class StoreModel {
  final int id;
  final String company_name;
  final String business_number;
  final String owner;
  final String tel;
  final String create_at;
  final String updated_at;
  final Store store;
  final Address address;
  final Bank bank;

  StoreModel(
      {this.id,
      this.company_name,
      this.business_number,
      this.owner,
      this.tel,
      this.create_at,
      this.updated_at,
      this.store,
      this.address,
      this.bank});

  StoreModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        company_name = json['company_name'],
        business_number = json['business_number'],
        owner = json['owner'],
        tel = json['tel'],
        create_at = json['create_at'],
        updated_at = json['updated_at'],
        store = Store(
            name: json['store']['name'],
            description: json['store']['description'],
            tel: json['store']['tel'],
            email: json['store']['email'],
            negotiable_time: json['store']['negotiable_time'],
            useDL: json['store']['useDL'],
            shop_img1: json['store']['shop_img1'],
            shop_img2: json['store']['shop_img2'],
            shop_img3: json['store']['shop_img3'],),
        address = Address(
            address: json['address']['address'],
            detail: json['address']['detail'],
            coords: json['address']['coords']),
        bank = Bank(bank: json['bank']['bank'], number: json['bank']['number']);
}

class Store {
  final String name;
  final String description;
  final String tel;
  final String email;
  final String negotiable_time;
  final bool useDL;
  final String shop_img1;
  final String shop_img2;
  final String shop_img3;

  Store(
      {this.name,
      this.description,
      this.tel,
      this.email,
      this.negotiable_time,
      this.useDL,
      this.shop_img1,
      this.shop_img2,
      this.shop_img3
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
