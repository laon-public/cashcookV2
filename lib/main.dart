import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/provider/QRProvider.dart';
import 'package:cashcook/src/provider/RecoProvider.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/splash.dart';
import 'package:cashcook/routes.dart';
import 'package:cashcook/src/screens/mypage/mypage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(CashCook());
}
class CashCook extends StatelessWidget {
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
}