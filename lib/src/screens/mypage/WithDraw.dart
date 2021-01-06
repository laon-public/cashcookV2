import 'package:cashcook/src/provider/provider.dart';
import 'package:cashcook/src/screens/main/home.dart';
import 'package:cashcook/src/screens/splash.dart';
import 'package:cashcook/src/services/User.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:provider/provider.dart' as provider;


class Withdraw extends StatefulWidget {
  final int authCheck;

  Withdraw({this.authCheck});

  @override
  _Withdraw createState() => _Withdraw();
}

class _Withdraw extends State<Withdraw>{


  UserProvider userProvider = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("WithDraw.dart");

  }

  @override
  Widget build(BuildContext context) {

    userProvider = provider.Provider.of<UserProvider>(context,listen: false);

    // TODO: implement build
    return

      Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: true,
      appBar:
      AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
        ),
        title: Text("회원 탈퇴",
            style: appBarDefaultText
        ),
        centerTitle: true,
        elevation: 0.0,
      ),



      body:
      SingleChildScrollView(
        child:
        Container(
          padding: EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
          child:
          SingleChildScrollView(
              child:
                  Column(
                    children: [
                  Card(
                  child:
                  Text("\n ▶ 회원을 탈퇴하시겠습니까?\n\n - 회원을 탈퇴하시면, 보유하고 계신 포인트가 모두 사라집니다. \n"),
                  ),

                    Container(
                      margin: EdgeInsets.only(left: 12.0, top: 12.0),
                      child:
                      Row(children: [
                        RaisedButton(
                            color: primary,
                            elevation: 0.0,
                            child: Text("탈퇴",
                                style: Body2.apply(
                                    color: white
                                )
                            ),
                            shape:
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(6.0)
                                )
                            ),
                            onPressed:() async {
                              await userProvider.DeleteUser();
                              Navigator.of(context).pushNamedAndRemoveUntil("/logout", (route) => false);
                              showToast("탈퇴가 완료되었습니다.");

                            }
                        ),

                        SizedBox( width : 10 ),

                        RaisedButton(
                          color: primary,
                          elevation: 0.0,
                          child: Text("취소",
                              style: Body2.apply(color: white)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(6.0))),
                          onPressed: () => Navigator.pop(context, false),),],),
                    ),


                    SizedBox(height: 50,),

                  ],)

          ),
        )
      ),
    );
  }

}