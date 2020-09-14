import 'package:contacts_service/contacts_service.dart';

class PhoneModel {
  final String name;
  final String phone;
  bool isCheck;

  PhoneModel.fromContact(Contact contact)
      : name = contact.displayName,
        phone = contact.phones.first.value,
        isCheck = false;

  PhoneModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        phone = json['phone'],
        isCheck = true;
}