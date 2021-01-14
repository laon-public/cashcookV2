import 'package:cashcook/src/provider/AuthProvider.dart';
import 'package:cashcook/src/provider/CarouselProvider.dart';
import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/provider/GameProvider.dart';
import 'package:cashcook/src/provider/PhoneProvider.dart';
import 'package:cashcook/src/provider/PlaceProvider.dart';
import 'package:cashcook/src/provider/PointMgmtProvider.dart';
import 'package:cashcook/src/provider/QRProvider.dart';
import 'package:cashcook/src/provider/RecoProvider.dart';
import 'package:cashcook/src/provider/StoreApplyProvider.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/splash.dart';
import 'package:cashcook/routes.dart';
import 'package:cashcook/src/screens/mypage/mypage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

void main() {
  runApp(CashCook());
}

class CashCook extends StatefulWidget {
  @override
  _CashCook createState() => _CashCook();
}

class _CashCook extends State<CashCook> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseCloudMessaging_Listeners();
  }

  @override
  Widget build(BuildContext context) {


    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CenterProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoreProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => QRProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RecoProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PhoneProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PointMgmtProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoreServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PlaceProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CarouselProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoreApplyProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => GameProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Cash Cook',
        theme: ThemeData(
         primaryColor: Colors.white,
          primarySwatch: Colors.blue,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: Splash(),
        routes: routes,
      ),
    );
  }

  void firebaseCloudMessaging_Listeners() async {
    await _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );

    _firebaseMessaging.configure(
      // 앱이 포그라운드 상태, 앱이 전면에 켜져있기 때문에 푸시 알림 UI가 표시되지 않음.
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        FlutterRingtonePlayer.playNotification(looping: false);

        Fluttertoast.showToast(msg: message['notification']['body']);
        // print(msgs.toString());
        // if(user == "PROVIDER") {
        //   if(Provider.of<UserProvider>(context, listen: false).selLog != null) {
        //     await Provider.of<UserProvider>(context, listen: false).setSellogStatus(status);
        //   }
        // } else if(user == "CONSUMER") {
        //   if(Provider.of<StoreProvider>(context, listen: false).selLog != null) {
        //     await Provider.of<StoreProvider>(context, listen: false).setSellogStatus(status);
        //   }
        // }
      },
      // 앱이 백그라운드 상태, 푸시 알림 UI를 누른 경우에 호출된다. 앱이 포그라운드로 전환됨.
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      // 앱이 꺼진 상태일 때, 푸시 알림 UI를 눌러 앱을 시작하는 경우에 호출된다.
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }
}