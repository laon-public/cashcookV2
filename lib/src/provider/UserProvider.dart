import 'package:cashcook/src/model/account.dart';
import 'package:cashcook/src/model/page.dart';
import 'package:cashcook/src/model/reco.dart';
import 'package:cashcook/src/model/recomemberlist.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/provider.dart';
import 'package:cashcook/src/utils/responseCheck.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart' as P;
import 'package:cashcook/src/services/User.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  UserService service = UserService();
  List<AccountModel> account = [];
  StoreModel storeModel = null;
  UserCheck loginUser = null;
  Pageing pageing = null;
  bool isLoading = false;
  bool isStop = false;
  List<AccountListModel> accountHistory = [];
  List<Map<String, dynamic>> result = [];
  List<Map<int, String>> recoList= [{0: "추천인 없음"}];

  List<String> recomemberList = [];

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  setStoreModel(StoreModel storeModel) {
    this.storeModel = storeModel;
  }

  setLoginUser(UserCheck userCheck) {
    this.loginUser = userCheck;
  }

  void clearStore() {
    storeModel = null;
  }

  Future<void> userSync() async {
    await service.userSync();
    return;
  }

  void fetchAccounts() async {
    print("fetchAccount");
    account.clear();
    final response = await service.getUserAccounts();
    Map<String, dynamic> accountsJson = jsonDecode(response);
    print("fetchAccounts 들어옴");
    print(accountsJson);
    if(isResponse(accountsJson)){
      for (var accountsList in accountsJson['data']["list"]) {
        var tmp = AccountModel.fromJson(accountsList);
        print(tmp);
        account.add(tmp);
      }
    }
    notifyListeners();
  }

  Future<void> fetchMyInfo(context) async {
    print("fetch");
    final response = await provider.authCheck(dataStorage.token);
    dynamic authCheck = json.decode(response)['data']['user'];
    int sex = 0;

    if ("MAN" == authCheck['sex']) {
      sex = 0;
    } else {
      sex = 1;
    }

    List<String> phoneSplit = List();
    phoneSplit = authCheck['phone'].toString().split("-");

    UserCheck userCheck;
    if (authCheck['phone'].toString().contains("-")) {
      userCheck = UserCheck(
          username: authCheck['username'],
          name: authCheck['name'],
          phone: phoneSplit[0] + phoneSplit[1] + phoneSplit[2],
          birth: authCheck['birth'],
          token: authCheck['token'],
          gender: sex,
          isFirstLogin: authCheck['isFirstLogin']);
    } else {
      userCheck = UserCheck(
          username: authCheck['username'],
          name: authCheck['name'],
          phone: authCheck['phone'],
          birth: authCheck['birth'],
          token: authCheck['token'],
          gender: sex,
          isFirstLogin: authCheck['isFirstLogin']);
    }

    print(authCheck['token']);

    print(userCheck.username);

    if (userCheck.username != "") {
      dynamic franchise = json.decode(response)['data']['franchise'];
      if (franchise != null) {
        print("프랜차이즈 넣기");
        await P.Provider.of<UserProvider>(context, listen: false)
            .setStoreModel(StoreModel.fromJson(franchise));
      } else {
        await P.Provider.of<UserProvider>(context, listen: false)
            .setStoreModel(null);
      }

      await P.Provider.of<UserProvider>(context, listen: false)
          .setLoginUser(userCheck);
    }

    notifyListeners();
    return;
  }

  Future<bool> postCharge(String id, int quantity, String payment) async {
    print('=============');
    print(quantity);
    print(payment);
    print('=============');
    print(123);
    final response = await service.postCharge(id, quantity, payment);
    print(response);
    if (isResponse(jsonDecode(response))) {
      return true;
    }
    return false;
  }

  Future<String> getAccountsHistory(String id, page) async {
    if (page == 0) result.clear();

    final response = await service.getAccountsHistory(id, page);
    print(response);
    Map<String, dynamic> json = jsonDecode(response);
    if(isResponse(json)){
      pageing = Pageing.fromJson(json['data']['paging']);

      String date = "";
      Map<String, dynamic> obj = {};

      for (var history in json["data"]['list']) {
        try {
          AccountListModel accountListModel = AccountListModel.fromJson(history);
          accountHistory.add(accountListModel);
          String time = accountListModel.created_at.split("T").first;
          if (date != time) {
            if (date != "") {
              result.add(obj);
              obj = {};
            }
            date = accountListModel.created_at.split("T").first;
            obj["date"] = date;
            obj["history"] = [];
            obj["history"].add({
              "title": accountListModel.purpose,
              "type": accountListModel.amount.contains("-") ? "차감" : "충전",
              "time": accountListModel.created_at.split("T").last,
              "price": demicalFormat.format(double.parse(accountListModel.amount)),
            });
          } else {
            obj["history"].add({
              "title": accountListModel.purpose,
              "type": accountListModel.amount.contains("-") ? "차감" : "충전",
              "time": accountListModel.created_at.split("T").last,
              "price": demicalFormat.format(double.parse(accountListModel.amount)),
            });
          }
        } catch (e) {
          print(e.toString());
        }
      }
      if (obj.isNotEmpty) result.add(obj);

      print(result);
    }
    stopLoading();
    notifyListeners();
  }

  Future<void> postReco() async {
    await service.postReco();
  }

  Future<void> getReco() async {
    final response = await service.getReco();
    print(response);
    Map<String, dynamic> json = jsonDecode(response);
    print(json);
    recoList.clear();
    for(var reco in json['data']['list']){
      Parent recoModel = Parent.fromJson(reco);
      recoList.add({recoModel.id: recoModel.name});
    }
    recoList.add({0: "추천인 없음"});

    isStop = true;
    notifyListeners();
  }

  Future<void> postManualReco(idx) async {
    await service.postManualReco(idx);
  }

  Future<void> withoutReco() async {
    await service.withoutReco();
  }

  Future<void> exchangeRp(String id, Map<String, String> data) async {
    final response = await service.exchangeRp(id, data);
    Map<String, dynamic> json = jsonDecode(response);
    print(json);
    if(isResponse(json)){
      Fluttertoast.showToast(msg: "환전하였습니다.");

    }
    return;
  }

  Future<String> recoemberlist() async {
    final response = await service.recoemberlist();
    Map<String, dynamic> json = jsonDecode(response);

    recomemberList.clear();
    if (json['data']['resultMsg'] == {} || json['data']['resultMsg'] == null ||
        json['data']['resultMsg'].isEmpty) {

      recomemberList.add("HOJO Group.");
    } else {
      recomemberList.add("선택해주세요.");
      recomemberList.add("랜덤선택");
    }
    for (var reco in json['data']['resultMsg']) {
      RecoMemberList recoModel = RecoMemberList.fromJson(reco);
      recomemberList.add("${recoModel.username}");
    }

    print(recomemberList);
    isStop = true;
    notifyListeners();
  }

  Future<String> recomemberinsert(String selectedmember) async {
    final response = await service.recomemberinsert(selectedmember);
    Map<String, dynamic> json = jsonDecode(response);
    if (isResponse(json)) {
      return "true";
    }
    return json['resultMsg'];
  }
}
