import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
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
      backgroundColor: white,
      resizeToAvoidBottomInset: false,
      body:
      WillPopScope(
        onWillPop: () async {
          showToast("결과를 확인 후 버튼을 통해 이동해주세요!");

          return Future.value(false);
        },
        child: Container(
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
        ),
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
                    valueColor: new AlwaysStoppedAnimation<Color>(primary)
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
                            style: Subtitle1.apply(
                                color: primary,
                                fontWeightDelta: -1
                              )
                        ),
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
                    valueColor: new AlwaysStoppedAnimation<Color>(primary)
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
                            style: Subtitle1.apply(
                                color: primary,
                                fontWeightDelta: -1
                            )
                        ),
                        Text("조금만 더 기다려주세요!",
                            style: Subtitle1.apply(
                                color: primary,
                                fontWeightDelta: -1
                            )
                        ),
                        Image.asset(
                          "assets/icon/cookie.png",
                          width: 80,
                          height: 80,
                          fit: BoxFit.fill,
                        ),
                        Text("메뉴 등록을 진행 중 입니다.",
                            style: Subtitle1.apply(
                                color: primary,
                                fontWeightDelta: -1
                            )
                        ),
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
                        Image.asset(
                          // "assets/icon/splash2.png",
                          // "assets/icon/cashcook_logo.png",
                          "assets/icon/excellent.png",
                          width: 150,
                          height: 150,
                          fit: BoxFit.fill,
                        ),
                        whiteSpaceH(10.0),
                        Text("축하합니다.\n매장신청이 완료되었습니다.",
                            textAlign: TextAlign.center,
                            style: Subtitle1.apply(
                                color: black,
                                fontWeightDelta: -1
                            )
                        ),
                        whiteSpaceH(10),
                        Text("매장적용은 사업자 정보 확인 후 완료되며,\n완료까지 약 일주일 정도 소요됩니다.",
                            style: Body1
                        ),
                        whiteSpaceH(10),
                        RaisedButton(
                          onPressed: () async {
                            await Provider.of<StoreProvider>(context, listen: false).clearMap();
                            await Provider.of<StoreProvider>(context, listen: false).hideDetailView();
                            await Provider.of<UserProvider>(context, listen: false).fetchMyInfo();

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => MainMap()),
                                    (route) => false);
                          },
                          color: primary,
                          child: Text(
                            "메인으로 돌아가기",
                            style: Body2.apply(
                              color: white
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

