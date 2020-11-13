import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/screens/main/home.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppConfirm extends StatefulWidget {
  @override
  _AppConfirm createState() => _AppConfirm();
}

class _AppConfirm extends State<AppConfirm> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      await Provider.of<CenterProvider>(context, listen: false).getAppInfo();
    });
    // TODO: implement build
    return Consumer<CenterProvider>(
      builder: (context, cp, _){
        return Scaffold(
            backgroundColor: cp.isLoading? white : (cp.phoneVersion == cp.appVersion) ? white : mainColor,
            body: cp.isLoading ?
              Container()
                :
              (cp.phoneVersion == cp.appVersion) ?
              pageMove()
              :
              updateForm()
        );
      },
    );
  }

  Widget pageMove() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
    });

    return Container();
  }

  Widget updateForm() {
    return Stack(
      children: [
        Positioned(
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.only(bottom: 45),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                    "Copyright ⓒ 2020 CashCook Inc. All Rights Reserved.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'noto',
                        fontSize: 11,
                        color: white,
                        fontWeight: FontWeight.w400
                    )
                ),
              ),
            )
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                width: MediaQuery.of(context).size.width * (3 / 4),
                height: MediaQuery.of(context).size.height * (2 / 4),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icon/cashcook_logo.png",
                        width: 180,
                        height: 53.33,
                      ),
                      whiteSpaceH(15.0),
                      Text("새로운 캐시쿡이\n"
                          "업데이트 되었습니다!\n"
                          "새로운 캐시쿡을 만나보세요!",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'noto',
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      whiteSpaceH(15.0),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                child: RaisedButton(
                                  elevation: 0.0,
                                  color: subColor,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
                                  },
                                  child: Text("나중에",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'noto',
                                      color: white,
                                    ),
                                  ),
                                ),
                              )
                          ),
                          whiteSpaceW(6.0),
                          Expanded(
                              child: Container(
                                child: RaisedButton(
                                  elevation: 0.0,
                                  color: mainColor,
                                  onPressed: () {
                                    launch(
                                        "https://play.google.com/store/apps/details?id=com.hozo.cashcook.cashcook"
                                    );
                                  },
                                  child: Text("업데이트",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'noto',
                                      color: white,
                                    ),),
                                ),
                              )
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(20.0)
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(3,3),
                      blurRadius: 3,
                      color: Color(0xff888888).withOpacity(0.15),
                    ),
                  ],
                ),
              ),
            )
        )
      ],
    );
  }
}