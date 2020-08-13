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

class CenterProvider with ChangeNotifier{
  CenterService service = CenterService();
  List<FaqModel> faq = [];
  List<NoticeModel> notice = [];
  List<InquiryModel> inquiry = [];
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


}