import 'dart:convert';

import 'package:cashcook/src/model/phone.dart';
import 'package:cashcook/src/provider/RecoProvider.dart';
import 'package:cashcook/src/services/Phone.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PhoneProvider with ChangeNotifier {
  List<Contact> result = [];
  var isChecked = false;
  bool isLoading = true;
  List<PhoneModel> phoneList = [];

  // Display Control Variable
  bool allCheck = false;
  int checkCnt = 0;

  // API
  PhoneService service = PhoneService();

  void setCheck(index, value) {
    phoneList[index].isCheck = value;

    if(value) {
      checkCnt++;
    } else {
      checkCnt--;
    }

    if(checkCnt == phoneList.length) {
      allCheck = true;
    } else {
      allCheck = false;
    }

    notifyListeners();
  }

  void setAllCheck(value){
    allCheck = value;
    checkCnt = phoneList.length;

    if(value) {
      checkCnt = phoneList.length;
    } else {
      checkCnt = 0;
    }

    phoneList.forEach((phone) {
      phone.isCheck = value;
    });

    notifyListeners();
  }

  void fetchPhoneList() async {
    print("fetchPhoneList");
    // 초기화
    List<Map<String,String>> phoneListTmp = [];
    phoneList = [];
    allCheck = true;
    isLoading = true;

    Map<PermissionGroup,
        PermissionStatus> permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.contacts]);
    List<Contact> contactList = (await ContactsService.getContacts()).toList();

    print(contactList.length);

    contactList.forEach((contact) {
      if(!contact.phones.isEmpty) {
        phoneListTmp.add({"name":contact.displayName, "phone": contact.phones.first.value});
        // phoneList.add(PhoneModel.fromContact(contact));
      }
    });
    print(phoneListTmp);

    final response = await service.rebuildPhoneList(phoneListTmp);
    Map<String,dynamic> phoneJson = jsonDecode(response);

    if(phoneJson['data'] != null){
      for(var phone in phoneJson['data']){
        phoneList.add(PhoneModel.fromJson(phone));
      }
    }


    print(response);
    checkCnt = phoneList.length;
    isLoading = false;
    notifyListeners();
  }

  void postReco(){
    RecoProvider().postReco(phoneList);
  }

  Future<bool> postDirectlyReco(String name, String phone) {
    return RecoProvider().postDirectlyReco(name, phone);
  }
}
