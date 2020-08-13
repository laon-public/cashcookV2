import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/dialog.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
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
          elevation: 0.5,
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
              whiteSpaceH(80),
              QrImage(
                data: widget.uuid,
                version: QrVersions.auto,
                size: 240.0,
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
