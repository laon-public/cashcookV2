import 'package:cashcook/src/model/Inquiry.dart';
import 'package:cashcook/src/model/faq.dart';
import 'package:cashcook/src/model/notice.dart';
import 'package:cashcook/src/model/page.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/utils/responseCheck.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:cashcook/src/services/Center.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:package_info/package_info.dart';

class CenterProvider with ChangeNotifier{
  CenterService service = CenterService();
  List<FaqModel> faq = [];
  List<NoticeModel> notice = [];
  List<InquiryModel> inquiry = [];
  String phoneVersion = "";
  String appVersion = "";
  String nextAppVersion = "";
  String hojoFunds = "";
  String gameUserQuantity = "";
  int limitGamePercentage = 0;
  Pageing pageing = null;

  bool isLoading = false;

  void startLoading(){
    isLoading = true;
    notifyListeners();
  }

  void stopLoading(){
    isLoading = false;
    notifyListeners();
  }

  void fetchFaqData(page) async {
    if(page == 0) faq.clear();
    print("fetchFaq");
    final response = await service.getFaq(page);
    print(response);
    Map<String, dynamic> faqJson = jsonDecode(response);
    if(isResponse(faqJson)){
      for(var faqList in faqJson['data']["list"]){
        var tmp = FaqModel.fromJson(faqList);
        faq.add(tmp);
      }
      pageing = Pageing.fromJson(faqJson['data']['paging']);
    }
    stopLoading();
    notifyListeners();
  }

  void fetchNoticeData(page) async {
    if(page == 0) notice.clear();
    print("fetchNotice");
    final response = await service.getNotice(page);
    print(response);
    Map<String, dynamic> noticeJson = jsonDecode(response);
    if(isResponse(noticeJson)){
      for(var noticeList in noticeJson['data']["list"]){
        var tmp = NoticeModel.fromJson(noticeList);
        notice.add(tmp);
      }
      pageing = Pageing.fromJson(noticeJson['data']['paging']);
    }
    stopLoading();
    notifyListeners();
  }
  void inputInquiry(String title, String content, context) async {
    final requestBody = {'title': title, 'contents': content};
    final response = await service.postInquiry(requestBody);

    if(isResponse(jsonDecode(response))){
      Fluttertoast.showToast(msg: "문의 완료되었습니다.",backgroundColor: mainColor);
    }
    Navigator.of(context).pop();
    notifyListeners();
  }

  void fetchInquiry(page)async {
    if(page == 0) inquiry.clear();
    final response = await service.getInquiry(page);
    Map<String, dynamic> InquiryJson = jsonDecode(response);
    if(isResponse(InquiryJson)){
      for(var inquiryList in InquiryJson['data']["list"]){
        var tmp = InquiryModel.fromJson(inquiryList);
        inquiry.add(tmp);
      }
      pageing = Pageing.fromJson(InquiryJson['data']['paging']);
    }
    stopLoading();
    notifyListeners();
  }

  void updateInquiry(inquiry_id) async {
    final response = await service.putInquiry(inquiry_id);

    if(isResponse(jsonDecode(response))){
      Fluttertoast.showToast(msg: "문의 완료되었습니다.",backgroundColor: mainColor);
    }
    notifyListeners();
  }

  void setOpen(int idx,bool open){
    inquiry[idx].isOpen = open;

    notifyListeners();
  }

  void getAppInfo() async {

    final response = await service.getAppInfo();
    print(response);

    appVersion="";
    nextAppVersion="";
    startLoading();

    appVersion = json.decode(response)['data']['ver']['value'];
    if(json.decode(response)['data']['nextVer'] != null) {
      nextAppVersion = json.decode(response)['data']['nextVer']['value'];
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    phoneVersion = "${packageInfo.version}+${packageInfo.buildNumber}";
    print(phoneVersion);

    stopLoading();
  }

  Future<void> getFunds(int orderPayment) async {
    final response = await service.getFunds();

    print(response);
    hojoFunds = json.decode(response)['data']['policy']['value'];

    print("HOJOFunds Is $hojoFunds");

    int per;
    for(per=10; per<=100;per += 10){
      int getDl = ((orderPayment * per / 100) / 100).round();
      int getDiscount = getDl * 100;

      print("Percentage 당 얻는 dl 수 ==> $getDl");
      print("Percentage 당 얻는 할인양 ==> $getDiscount");
      if(getDiscount > int.parse(hojoFunds)){
        limitGamePercentage = per-10;
        break;
      }
    }

    if(per == 110) {
      limitGamePercentage = per-10;
    }

    print("게임 Percentage 한도 ==> $limitGamePercentage");
    notifyListeners();
  }

  void enterGame() async {
    String res = await service.enterGame();

    gameUserQuantity = json.decode(res)['data']['policy']['value'];

    notifyListeners();
  }
}