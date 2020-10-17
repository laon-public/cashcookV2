import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/dialog.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCheck extends StatefulWidget {
  final String uuid;

  QrCheck(this.uuid);

  @override
  _QrCheck createState() => _QrCheck();
}

class _QrCheck extends State<QrCheck> {
  firstView() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainMap()), (route) => false);
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
            style: TextStyle(
                fontFamily: 'noto',
                fontSize: 14,
                color: black,
                fontWeight: FontWeight.w600),
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
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - appBar.preferredSize.height,
          color: white,
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.5,
                child:
                  Stack(
                    children: [
                      Positioned(
                        top: 50,
                        child: Container(
                          padding: EdgeInsets.all(70),
                          child: QrImage(
                            data: widget.uuid,
                            version: QrVersions.auto,
                            size: 160.0,
                          ),
                          decoration: BoxDecoration(
                              color: white,
                              border: Border.all(color: mainColor, width: 10),
                              shape: BoxShape.circle
                          ),
                        )
                      ),
                      Positioned(
                          bottom: 80,
                          right: 20,
                          child: CachedNetworkImage(
                            imageUrl: user.storeModel.store.shop_img1,
                            imageBuilder: (context, img) => Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: img, fit: BoxFit.fill
                                )
                              )
                            ),
                          )
                      )
                    ]
                  )

              ),
              Expanded(
                child: Container(),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: RaisedButton(
                  color: mainColor,
                  onPressed: () {
                    qrDialog();
                  },
                  elevation: 0.0,
                  child: Center(
                    child: Text('완료', style: TextStyle(
                      color: white, fontSize: 14, fontFamily: 'noto'
                    ),),
                  ),
                ),
              ),
              whiteSpaceH(56)
            ],
          ),
        ),
      ),
    );
  }
}
