import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/screens/mypage/mypage.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/dialog.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCheck extends StatefulWidget {
  final String uuid;
  final String storeName;
  final int pay;

  QrCheck({this.uuid, this.storeName, this.pay});

  @override
  _QrCheck createState() => _QrCheck();
}

class _QrCheck extends State<QrCheck> {
  firstView() async {
    await Provider.of<StoreProvider>(context, listen: false).clearMap();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyPage(isHome: true,)), (route) => false);
  }

  qrDialog() {
    return dialog(
        title: "안내",
        context: context,
        content: "이 페이지를 닫게 되면\n다시는 돌아올 수 없습니다.",
        sub: "",
        selectOneText: "취소",
        selectOneVoid: () => dialogPop(context),
        selectTwoText: "확인",
        selectTwoVoid: () => firstView());
  }

  AppBar appBar;

  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        qrDialog();
        return null;
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: appBar = AppBar(
          backgroundColor: white,
          elevation: 0,
          title: Text(
            "QR 확인",
            style: appBarDefaultText,
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              qrDialog();
            },
            icon: Image.asset("assets/resource/public/close.png", width: 24, height: 24,),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - appBar.preferredSize.height,
          color: white,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 1 / 6),
                child: Column(
                  children: [
                    QrImage(
                        data: widget.uuid,
                        version: QrVersions.auto,
                        size: 160
                    ),
                    whiteSpaceH(12),
                    Text(widget.storeName,
                      style: Body1.apply(
                        color: black,
                        fontWeightDelta: 3
                      )
                    ),
                    Text("${numberFormat.format(widget.pay)}원",
                      style: Subtitle1.apply(
                        color: primary,
                        fontWeightDelta: 1
                      )
                    )
                  ],
                )

              ),
              // Container(
              //     width: 315,
              //     height: 315,
              //     child:
              //       Stack(
              //         children: [
              //           Positioned.fill(
              //               child: Container(
              //                 padding: EdgeInsets.all(60),
              //                 child: QrImage(
              //                   data: widget.uuid,
              //                   version: QrVersions.auto,
              //                   size: 160.0,
              //                 ),
              //                 decoration: BoxDecoration(
              //                     color: white,
              //                     border: Border.all(color: mainColor, width: 10),
              //                     shape: BoxShape.circle
              //                 ),
              //               )
              //           ),
              //           Positioned(
              //               bottom: 0,
              //               right: 30,
              //               child: CachedNetworkImage(
              //                 imageUrl: user.storeModel.store.shop_img1,
              //                 imageBuilder: (context, img) => Container(
              //                   width: 64,
              //                   height: 64,
              //                   decoration: BoxDecoration(
              //                     shape: BoxShape.circle,
              //                     image: DecorationImage(
              //                       image: img, fit: BoxFit.fill
              //                     )
              //                   )
              //                 ),
              //               )
              //           )
              //         ]
              //       )
              // ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: RaisedButton(
                  color: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.0)
                    )
                  ),
                  onPressed: () {
                    qrDialog();
                  },
                  elevation: 0.0,
                  child: Center(
                    child: Text('완료', style: Subtitle2.apply(
                      color: white,
                      fontWeightDelta: 1
                    )
                      ,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
