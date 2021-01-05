import 'package:cashcook/src/model/account.dart';
import 'package:cashcook/src/model/log/orderLog.dart';
import 'package:cashcook/src/model/log/refundLog.dart';
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
import 'package:intl/intl.dart';
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

  // Charge ADP Variable
  TextEditingController chargeQuantityCtrl = TextEditingController();
  TextEditingController dlQuantityCtrl = TextEditingController();
  int dlPay = 0;
  int chargePay = 0;

  List<String> recomemberList = [];

  // Service List
  List<ServiceLogListItem> serviceLogList = [];
  OrderLog selLog;
  bool isLastList = false;

  // Refund List
  List<RefundLogModel> refundList = [];

  // Authentication Variable
  String jsession;

  void setSelOrderLog(OrderLog orderLog) {
      selLog = orderLog;

      notifyListeners();
  }

  void fetchServiceList(int page) async {
    if(page == 1){
      serviceLogList.clear();
    }
    startLoading();

    final response = await service.fetchServiceList(page);
    print(response);

    Map<String, dynamic> data = jsonDecode(response)['data'];

    String date = "";
    int idx = -1;
    isLastList = ((data['serviceList'] as List).length == 0);
    for(var json in data['serviceList']) {
      String dateChk = DateFormat("yyyy.MM.dd").format(
          DateTime.parse(json['created_at'].toString()));
      int existIdx = serviceLogList.indexWhere((log) => log.date == dateChk);
      if(existIdx != -1) {
        serviceLogList[existIdx].addfromJson(json);
      } else {
        serviceLogList.add(
            ServiceLogListItem.initFromJson(json)
        );
      }
    }

    stopLoading();
  }

  void clearQuantity() {
    chargeQuantityCtrl.text = "";
    dlQuantityCtrl.text = "";
    dlPay = 0;
    chargePay = 0;

    notifyListeners();
  }

  void setChargePay(int rate){
    if(chargeQuantityCtrl.text == "") {
      chargePay = 0;
    } else {
      chargePay = (int.parse(chargeQuantityCtrl.text) * rate).round();
    }

    notifyListeners();
  }

  void setDlPay(){
    if(dlQuantityCtrl.text == "") {
      dlPay = 0;
    } else {
      dlPay = int.parse(dlQuantityCtrl.text);
    }

    notifyListeners();
  }

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

  void updateServiceLogList(int reviewId, int orderId) {
    bool isOkay = false;

    serviceLogList.forEach((serviceLog) {
      serviceLog.orderLogList.forEach((orderLog) {
        if(orderLog.id == orderId) {
          orderLog.reviewId = reviewId;
          isOkay = true;

          return;
        }
      });

      if(isOkay){
        return;
      }
    });

    notifyListeners();
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
        "CARAT" : accountsJson['data']['CARAT']
      };
    }
    stopLoading();
  }

  Future<void> fetchMyInfo() async {
    startLoading();
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
          id: authCheck['id'],
          username: authCheck['username'],
          name: authCheck['name'],
          phone: phoneSplit[0] + phoneSplit[1] + phoneSplit[2],
          birth: authCheck['birth'],
          token: authCheck['token'],
          gender: sex,
          isFirstLogin: authCheck['isFirstLogin'],
          userGrade: authCheck['userGrade'],
          isFran: authCheck['isFran'],
          fcmToken: authCheck['fcm_token']);
    } else {
      userCheck = UserCheck(
          id: authCheck['id'],
          username: authCheck['username'],
          name: authCheck['name'],
          phone: authCheck['phone'],
          birth: authCheck['birth'],
          token: authCheck['token'],
          gender: sex,
          isFirstLogin: authCheck['isFirstLogin'],
          userGrade: authCheck['userGrade'],
          isFran: authCheck['isFran'],
          fcmToken: authCheck['fcm_token']);
    }

    print(authCheck['token']);

    print(userCheck.username);
    print("FCM TOKEN!!! ---> ${userCheck.fcmToken}");

    if (userCheck.username != "") {
      dynamic franchise = json.decode(response)['data']['franchise'];
      if (franchise != null) {
        print("프랜차이즈 넣기");
        if(franchise['status'] == 'DENY') {
          Fluttertoast.showToast(msg: "매장 권한이 상실되었습니다. ADP를 충전해주세요.");
        }
        await setStoreModel(StoreModel.fromJson(franchise));
      } else {
        await setStoreModel(null);
      }

      await setLoginUser(userCheck);

      response = await service.getUserAccounts();
      Map<String, dynamic> accountsJson = jsonDecode(response);
      print("fetchAccounts 들어옴");
      print(accountsJson);
      if(isResponse(accountsJson)){
        pointMap = {
          "DL" : accountsJson['data']['DL'],
          "RP" : accountsJson['data']['RP'],
          "ADP" : accountsJson['data']['ADP'],
          "CARAT" : accountsJson['data']['CARAT']
        };
      }
    }

    stopLoading();
  }

  Future<bool> postCharge(String id, String point ,int quantity, String payment, int dlQuantity) async {
    print('=============');
    print(quantity);
    print(payment);
    print('=============');
    print(123);
    final response = await service.postCharge(quantity, point, payment,dlQuantity);
    print(response);
    if (isResponse(jsonDecode(response))) {
      return true;
    }
    return false;
  }

  Future<String> getAccountsHistory(type,page) async {
    if (page == 0) result.clear();

    final response = await service.getAccountsHistory(type,page);
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
              "type": (double.parse(accountListModel.amount) < 0) ? "차감" : "충전",
              "time": accountListModel.created_at.split("T").last.split(":").first + ":"
                + accountListModel.created_at.split("T").last.split(":")[1],
              "price": demicalFormat.format(double.parse(accountListModel.amount)),
            });
          } else {
            obj["history"].add({
              "title": accountListModel.purpose,
              "type": accountListModel.amount.contains("-") ? "차감" : "충전",
              "time": accountListModel.created_at.split("T").last.split(":").first + ":"
                  + accountListModel.created_at.split("T").last.split(":")[1],
              "price": demicalFormat.format(double.parse(accountListModel.amount)),
            });
          }
        } catch (e) {
          print(e.toString());
        }
      }
      if (obj.isNotEmpty) result.add(obj);

      nowPoint = json['data']['nowPoint'];
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

  void changeLimitDL(bool switchType, String store_id, String limitDL, String limitType) async {
    print("SwitchType : $switchType");
    final response = await service.changeLimitDL({
      "switch" : switchType ? 'on' : 'off',
      "store_id" : store_id,
      "limitDL" : limitDL,
      "limitType" : limitType,
    });

    Map<String, dynamic> json = jsonDecode(response);

    showToast(json['resultMsg']);
  }

  Future<int> selectMyAgency() async {
    print("UserProvider selectMyAgency");
    final response = await service.selectMyAgency();
    Map<String, dynamic> json = jsonDecode(response);
    print("json 실행");
    print(json);
    print(isResponse(json));

    return json['resultMsg']['cnt'];
  }

  void confirmPurchase(int orderId) async {
    String response = await service.confirmPurchase(orderId);
    if(isResponse(jsonDecode(response))) {
      showToast("구매가 확정되었습니다.");

      selLog.confirm = true;
      selLog.status = "CONFIRM";
      notifyListeners();

      return;
    }
    showToast("구매 확정에 실패했습니다.");
    return;
  }

  Future<String> requestRefund(String reason) async {
    Map<String, dynamic> data = {
      "orderId" : selLog.id,
      "storeId" : selLog.storeId,
      "impUid" : selLog.impUid,
      "pay" : selLog.pay,
      "reason" : reason,
    };

    String response = await service.requestRefund(data);

    Map<String, dynamic> json = jsonDecode(response);
    if(isResponse(json)){
      selLog.status = "REFUND_REQUEST";
      return json['data']['fcmToken'];
    }

    return "";
  }

  Future fetchRefundRequest() async {
    refundList.clear();
    notifyListeners();
    String response = await service.fetchRefundRequest(storeModel.id);

    Map<String, dynamic> json = jsonDecode(response);

    print(json);
    for(var refund in json['data']['refundList']){
      refundList.add(RefundLogModel.fromJson(refund));
    }

    notifyListeners();
  }

  Future<String> patchRefundRequest(int refundId, int orderId, String status) async {
    Map<String, dynamic> data = {
      "refundId" : refundId,
      "orderId" : orderId,
      "status" : status
    };

    String response = await service.patchRefundRequest(data);

    Map<String,dynamic> json = jsonDecode(response);
    if(isResponse(json)) {
      return json['data']['fcmToken'];
    }

    return "";
  }

  patchFcmToken(String fcmToken) async {
    String response = await service.patchFcmToken(fcmToken);

    print(response);
  }

}
