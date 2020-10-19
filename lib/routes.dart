import 'package:cashcook/src/screens/center/appinfomation.dart';
import 'package:cashcook/src/screens/center/faq.dart';
import 'package:cashcook/src/screens/center/notice.dart';
import 'package:cashcook/src/screens/center/serviceInquiry.dart';
import 'package:cashcook/src/screens/center/serviceInquiryWrite.dart';
import 'package:cashcook/src/screens/mypage/points/DL/dlSend.dart';
import 'package:cashcook/src/screens/mypage/points/RP/rpExchange.dart';
import 'package:cashcook/src/screens/mypage/points/chargePoint.dart';
import 'package:cashcook/src/screens/mypage/points/pointHistory.dart';
import 'package:cashcook/src/screens/mypage/store/address.dart';
import 'package:cashcook/src/screens/mypage/store/store_3.dart';
import 'package:cashcook/src/screens/mypage/store/store_4.dart';
import 'package:cashcook/src/screens/splash.dart';
import 'package:cashcook/src/screens/mypage/store/store.dart';
import 'package:cashcook/src/screens/mypage/store/store_2.dart';
import 'package:cashcook/src/screens/storemanagement/modifyBusiness.dart';
import 'package:cashcook/src/screens/storemanagement/modifyStore.dart';
import 'package:cashcook/src/screens/mypage/info/userState.dart';
import 'package:cashcook/src/screens/mypage/myUpdate.dart';
import 'package:cashcook/src/screens/mypage/logout.dart';
final routes = {
  '/Splash': (context) => Splash(),
  "/store/apply1":(context) => StoreApplyFirstStep(),
  "/store/apply2":(context) => StoreApplySecondStep(),
  "/store/apply3":(context) => StoreApplyThirdStep(),
  "/store/apply4":(context) => StoreApplyLastStep(),
  "/point/history": (context) => History(),
  "/point/charge": (context) => ChargePoint(),
  "/point/dl":(context) => DLSend(),
  "/point/rp":(context) => RPExchange(),
  "/store/findAddress":(context) => FindAddress(),
  "/notice" : (context) => Notice(),
  "/faq": (context) => Faq(),
  "/inquiry": (context) => Inquiry(),
  "/inquiry/write": (context) => InquiryWrite(),
  "/store/modify/business":(context) => ModifyBusiness(),
  "/store/modify/store": (context) => ModifyStore(),
  "/userState" : (context) => UserState(),
  "/myUpdate" : (context) => MyUpdate(),
  "/logout" : (context) => Logout(),
  "/appinfomation" : (context) => AppInfomation(),
};