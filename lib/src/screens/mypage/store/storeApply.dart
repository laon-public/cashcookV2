import 'dart:io';

import 'package:cashcook/src/model/store/menuedit.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/screens/referrermanagement/franBizSelect.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/utils/geocoder.dart';
import 'package:cashcook/src/widgets/TextFieldWidget.dart';
import 'package:cashcook/src/widgets/TextFieldssWidget.dart';
import 'package:cashcook/src/widgets/TextFieldsWidget.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class StoreApplyState extends StatefulWidget {
  @override
  _StoreApplyState  createState() => _StoreApplyState ();
}

class _StoreApplyState extends State<StoreApplyState>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<StoreProvider>(context, listen:false).postStoreService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      resizeToAvoidBottomInset: false,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 50.0, bottom: 20.0, left: 20.0, right: 20.0),
          child:
              Consumer<StoreProvider>(
                builder: (context, sp, _){
                  return (!sp.isStoreSuccess)?
                      storeLoading()
                      :
                  (!sp.isMenuSuccess) ?
                      menuLoading()
                      :
                      successBtn();
                }
              )
      )
    );
  }

  Widget storeLoading() {
    return Stack(
        children: [
          Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width / 0.5,
                height: MediaQuery.of(context).size.height / 1.5,
                child:CircularProgressIndicator(
                  backgroundColor: subBlue,
                  valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                )
            ),
          ),
          Center(
              child:
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  child: Column(
                      children: [
                        Image.asset(
                          "assets/resource/public/payment.png",
                          width: 80,
                          height: 80,
                          fit: BoxFit.fill,
                        ),
                        Text("매장 등록을 진행 중 입니다.",
                            style: TextStyle(
                              color: white,
                              fontSize: 20,
                              fontFamily: 'noto',
                            )),
                      ]
                  )
              )
          ),
        ]
    );
  }

  Widget menuLoading() {
    return Stack(
        children: [
          Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width / 0.5,
                height: MediaQuery.of(context).size.height / 1.5,
                child:CircularProgressIndicator(
                  backgroundColor: subBlue,
                  valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                )
            ),
          ),
          Center(
              child:
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Column(
                      children: [
                        Text("거의 완료 되었습니다!",
                            style: TextStyle(
                              color: subBlue,
                              fontSize: 20,
                              fontFamily: 'noto',
                            )),
                        Text("조금만 더 기다려주세요!",
                            style: TextStyle(
                              color: subBlue,
                              fontSize: 20,
                              fontFamily: 'noto',
                            )),
                        Image.asset(
                          "assets/icon/cookie.png",
                          width: 80,
                          height: 80,
                          fit: BoxFit.fill,
                        ),
                        Text("메뉴 등록을 진행 중 입니다.",
                            style: TextStyle(
                              color: white,
                              fontSize: 20,
                              fontFamily: 'noto',
                            )),
                      ]
                  )
              )
          ),
        ]
    );
  }

  Widget successBtn() {
    return Stack(
        children: [
          Center(
              child:
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: Column(
                      children: [
                        Text("매장 등록에 성공 했습니다!",
                            style: TextStyle(
                              color: white,
                              fontSize: 20,
                              fontFamily: 'noto',
                            )),
                        whiteSpaceH(10),
                        Image.asset(
                          "assets/icon/splash2.png",
                          width: 150,
                          height: 150,
                          fit: BoxFit.fill,
                        ),
                        RaisedButton(
                          onPressed: () async {
                            await Provider.of<StoreProvider>(context, listen: false).clearMap();
                            await Provider.of<StoreProvider>(context, listen: false).hideDetailView();
                            await Provider.of<UserProvider>(context, listen: false).fetchMyInfo(context);

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => MainMap()),
                                    (route) => false);
                          },
                          color: subBlue,
                          child: Text(
                            "메인으로 돌아가기",
                            style: TextStyle(
                              color: white,
                              fontSize: 16,
                              fontFamily: 'noto'
                            )
                          )
                        )
                      ]
                  )
              )
          ),
        ]
    );
  }

}

