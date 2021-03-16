import 'dart:convert';
import 'dart:typed_data';

class RecoMemberList {
  final int idx;
  final String name;
  final String username;
  final String phone;
  final String recophon;

  RecoMemberList({this.idx, this.name, this.username ,this.phone, this.recophon});


  RecoMemberList.fromJson(Map<String, dynamic> json)
      : idx = json['idx'],
        name = json['name'],
        username = json['username'],
        phone = json['phone'],
        recophon = json['recophon'];

}