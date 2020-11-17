import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/screens/main/home.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cashcook/src/provider/UserProvider.dart';

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

    UserProvider up = Provider.of<UserProvider>(context, listen: false);

    // TODO: implement build
    return Consumer<CenterProvider>(
      builder: (context, cp, _){
        return Scaffold(
            backgroundColor: cp.isLoading? white : (cp.phoneVersion == cp.appVersion) ? white : mainColor,
            body: cp.isLoading ?
              Container()
                :
              (cp.phoneVersion == cp.appVersion) ?
              (up.loginUser.isFran && up.pointMap['ADP'] < 30000 ) ?
              adpCheckForm()
                  :
              pageMove()
              :
              updateForm()
        );
      },
    );
  }

  Widget adpCheckForm() {
    return Stack(
      children: [
        Container(
            color: mainColor,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
        ),
        Positioned.fill(
            child: Opacity(
              opacity: 0.7,
              child: Container(
                  color: black,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
              ),
            )
        ),
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
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            width: MediaQuery.of(context).size.width * (3 / 4),
            height: 250,
            child: Center(
              child: Column(
                children: [
                  Text("ADP 경고",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'noto',
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333)
                    ),
                    textAlign: TextAlign.center,
                  ),
                  whiteSpaceH(40.0),
                  Text("소유 ADP가 30,000 ADP 이하입니다.\n"
                      "10,000 ADP 이하일시 결제 후\n"
                      "추가할인 서비스가 제한됩니다.",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'noto',
                        color: Color(0xFF333333)
                    ),
                    textAlign: TextAlign.center,
                  ),
                  whiteSpaceH(27.0),
                  Container(
                    width: 64,
                    height: 64,
                    child: RaisedButton(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(100)
                        )
                      ),
                      color: subColor,
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: Text("확인",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'noto',
                          color: white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                  Radius.circular(20.0)
              ),
            ),
          ),
        )
      ],
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
        Positioned.fill(
            child: Opacity(
              opacity: 0.7,
              child: Container(
                color: black,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            )
        ),
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
                          fontSize: 12,
                          fontFamily: 'noto',
                          color: Color(0xFF333333),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      whiteSpaceH(40.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 84,
                            height: 84,
                                child: RaisedButton(
                                  elevation: 0.0,
                                  color: subColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)
                                      )
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
                                  },
                                  child: Text("나중에",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'noto',
                                      color: white,
                                    ),
                                  ),
                                ),
                              ),
                          whiteSpaceW(6.0),
                          Container(
                            width: 84,
                                height: 84,
                                child: RaisedButton(
                                  elevation: 0.0,
                                  color: mainColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)
                                      )
                                  ),
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
                ),
              ),
            )
        )
      ],
    );
  }
}