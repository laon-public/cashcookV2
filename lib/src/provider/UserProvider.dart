import 'package:cashcook/src/model/account.dart';
import 'package:cashcook/src/model/page.dart';
import 'package:cashcook/src/model/reco.dart';
import 'package:cashcook/src/model/recomemberlist.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/provider.dart';
import 'package:cashcook/src/utils/responseCheck.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
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
  bool isLoading = true;
  bool isStop = false;
  List<AccountListModel> accountHistory = [];
  Map<String, int> pointMap = {};
  List<Map<String, dynamic>> result = [];
  List<Map<int, String>> recoList= [{0: "추천인 없음"}];
  List<dynamic> disList = [];
  List<dynamic> ageList = [];
  String disSelected = '총판';
  String ageSelected = '총판을 선택해주세요.';
  int nowPoint = 0;

  List<String> recomemberList = [];

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setDisSelected(value) {
    disSelected = value;
    notifyListeners();
  }

  void setAgeSelected(value) {
    ageSelected = value;
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
    pointMap.clear();

    startLoading();
    final response = await service.getUserAccounts();
    Map<String, dynamic> accountsJson = jsonDecode(response);
    print("fetchAccounts 들어옴");
    print(accountsJson);
    if(isResponse(accountsJson)){
      pointMap = {
        "DL" : accountsJson['data']['DL'],
        "RP" : accountsJson['data']['RP'],
        "ADP" : accountsJson['data']['ADP'],
      };
    }
    stopLoading();
  }

  Future<void> fetchMyInfo(context) async {
    startLoading();
    print("fetch");
    var response = await provider.authCheck(dataStorage.token);
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
          isFirstLogin: authCheck['isFirstLogin'],
          userGrade: authCheck['userGrade'],
          isFran: authCheck['isFran'],);
    } else {
      userCheck = UserCheck(
          username: authCheck['username'],
          name: authCheck['name'],
          phone: authCheck['phone'],
          birth: authCheck['birth'],
          token: authCheck['token'],
          gender: sex,
          isFirstLogin: authCheck['isFirstLogin'],
          userGrade: authCheck['userGrade'],
          isFran: authCheck['isFran'],);
    }

    print(authCheck['token']);

    print(userCheck.username);

    if (userCheck.username != "") {
      dynamic franchise = json.decode(response)['data']['franchise'];
      if (franchise != null) {
        print("프랜차이즈 넣기");
        if(franchise['status'] == 'DENY') {
          Fluttertoast.showToast(msg: "매장 권한이 상실되었습니다. ADP를 충전해주세요.");
        }
        await P.Provider.of<UserProvider>(context, listen: false)
            .setStoreModel(StoreModel.fromJson(franchise));
      } else {
        await P.Provider.of<UserProvider>(context, listen: false)
            .setStoreModel(null);
      }

      await P.Provider.of<UserProvider>(context, listen: false)
          .setLoginUser(userCheck);

      response = await service.getUserAccounts();
      Map<String, dynamic> accountsJson = jsonDecode(response);
      print("fetchAccounts 들어옴");
      print(accountsJson);
      if(isResponse(accountsJson)){
        pointMap = {
          "DL" : accountsJson['data']['DL'],
          "RP" : accountsJson['data']['RP'],
          "ADP" : accountsJson['data']['ADP'],
        };
      }
    }

    stopLoading();
  }

  Future<bool> postCharge(String id, int quantity, String payment) async {
    print('=============');
    print(quantity);
    print(payment);
    print('=============');
    print(123);
    final response = await service.postCharge(quantity, payment);
    print(response);
    if (isResponse(jsonDecode(response))) {
      return true;
    }
    return false;
  }

  Future<String> getAccountsHistory(type,page) async {
    if (page == 0) result.clear();

    final response = await service.getAccountsHistory(type,page);
    print(response);
    Map<String, dynamic> json = jsonDecode(response);
    if(isResponse(json)){
      pageing = Pageing.fromJson(json['data']['paging']);

      String date = "";
      Map<String, dynamic> obj = {};

      for (var history in json["data"]['list']) {
        try {
          AccountListModel accountListModel = AccountListModel.fromJson(history);
          print(accountListModel);
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
              "type": (double.parse(accountListModel.amount) < 0) ? "차감" : "충전",
              "time": accountListModel.created_at.split("T").last,
              "price": demicalFormat.format(double.parse(accountListModel.amount)),
            });
            print(obj);
          } else {
            print("여기겠지");
            obj["history"].add({
              "title": accountListModel.purpose,
              "type": accountListModel.amount.contains("-") ? "차감" : "충전",
              "time": accountListModel.created_at.split("T").last,
              "price": demicalFormat.format(double.parse(accountListModel.amount)),
            });
          }
        } catch (e) {
          print("ㅋㅋ 에러났네");
          print(e.toString());
        }
      }
      if (obj.isNotEmpty) result.add(obj);

      nowPoint = json['data']['nowPoint'];
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

  Future<void> withoutRecoDis() async {
    await service.withoutRecoDis();
  }

  Future<void> withoutRecoAge() async {
    await service.withoutRecoAge();
  }

  Future<void> exchangeRp(Map<String, String> data) async {
    final response = await service.exchangeRp(data);
    Map<String, dynamic> json = jsonDecode(response);
    print(json);
    if(isResponse(json)){
      Fluttertoast.showToast(msg: "환전하였습니다.");

    }
    return;
  }

  void insertDis() async {
    final response = await service.inserDis(disSelected);

    Map<String, dynamic> json = jsonDecode(response);
    print("json 실행");
    print(json);
  }

  void insertDisAge() async {
    var response = await service.inserDis(ageSelected);

    Map<String, dynamic> json = jsonDecode(response);
    print("json 실행");
    print(json);
  }

  void selectDis() async {
    startLoading();

    disList.clear();
    disList.add('총판');
    final response = await service.selectDis();

    Map<String, dynamic> json = jsonDecode(response);
    print("json 실행");
    print(json);

    disList.addAll(json['data']['list']);

    stopLoading();
}

  void selectDisAge() async {
    startLoading();

    disList.clear();
    disSelected = "총판";
    disList.add('총판');
    var response = await service.selectDis();

    Map<String, dynamic> json = jsonDecode(response);
    print("json 실행");
    print(json);

    disList.addAll(json['data']['list']);

    ageList.clear();
    ageSelected = "총판을 선택해주세요.";
    ageList.add('총판을 선택해주세요.');

    stopLoading();
  }

  void selectAge(value) async {
    showToast("해당 총판의 대리점 목록을 불러오는 중 입니다.");

    ageSelected = "대리점";
    var response = await service.selectAge(value);
    Map<String, dynamic> json = jsonDecode(response);
    print("json 실행");
    print(json);

    ageList.clear();
    ageList.add("대리점");
    ageList.addAll(json['data']['list']);

    setDisSelected(value);
  }

  void clearAge(value) async {
    disSelected = "총판";

    ageList.clear();
    ageSelected = "총판을 선택해주세요.";
    ageList.add('총판을 선택해주세요.');

    notifyListeners();
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

  Future<String> recomemberinsert(String selectedmember, String type) async {
    final response = await service.recomemberinsert(selectedmember, type);
    Map<String, dynamic> json = jsonDecode(response);
    if (isResponse(json)) {
      return "true";
    }
    return json['resultMsg'];
  }

  Future<int> recognitionSelect() async {
    print("UserProvider recognitionSelect");
    final response = await service.recognitionSelect();
    Map<String, dynamic> json = jsonDecode(response);
    print("json 실행");
    print(json);
    print(isResponse(json));

    return json['data']['cnt'];
  }
}
