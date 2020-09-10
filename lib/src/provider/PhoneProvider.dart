import 'package:cashcook/src/model/phone.dart';
import 'package:cashcook/src/provider/RecoProvider.dart';
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

  void setCheck(index, value) {
    phoneList[index].isCheck = value;

    if(value) {
      checkCnt++;
    } else {
      checkCnt--;
    }

    if(checkCnt == phoneList.length) {
      allCheck = true;
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
    phoneList = [];
    checkCnt = 0;
    allCheck = false;
    isLoading = false;

    Map<PermissionGroup,
        PermissionStatus> permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.contacts]);
    List<Contact> contactList = (await ContactsService.getContacts()).toList();

    print(contactList.length);

    contactList.forEach((contact) {
      if(!contact.phones.isEmpty) {
        phoneList.add(PhoneModel.fromContact(contact));
      }
    });

    isLoading = false;
    notifyListeners();
  }

  void postReco(){
    phoneList.forEach((phone) {
      if(phone.isCheck){
        RecoProvider().postReco(phone.name, phone.phone);
      }
    });

  }
}
