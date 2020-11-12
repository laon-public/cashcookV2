import 'package:cashcook/src/provider/QRProvider.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/screens/bargain/bargain.dart';
import 'package:cashcook/src/screens/bargain/bargaingame.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/screens/mypage/info/serviceList.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/dialog.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Qr extends StatefulWidget {
  final int id;
  final String name;
  final int pay;

  Qr({this.id,this.name, this.pay});

  @override
  _Qr createState() => _Qr();
}

class _Qr extends State<Qr> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  String qrText = "";
  bool qrSet = false;

//  QRViewController qrViewController;

//  buyMove(name, pay) {
//    print("결제");
//    Navigator.of(context).push(MaterialPageRoute(
//      builder: (context) => Buy(
//        name: name,
//        pay: pay,
//      )
//    ));
//  }

  dialogPop() async {
    await Provider.of<QRProvider>(context,listen: false).confirmPayment(
        Provider.of<QRProvider>(context,listen: false).paymentModel.uuid
    );

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ServiceList(
      isHome: true,
      afterGame : true,
    )), (route) => false);
    qrSet = false;
  }

  bargainMove() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => BargainGame()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    final int detailId = args['store_id'];
    final String storeName = args['store_name'];

    return Scaffold(
      body:
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).padding.top,
              bottom: MediaQuery.of(context).padding.bottom,
              left: 0,
              right: 0,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child:
                  QRBarScannerCamera(
                    onError: (context, error) {
                      print(error.toString());
                      return Container();
                    },
                    qrCodeCallback: (data) {
                      if (qrSet) return;
                      print("QrData : $data");
                      print(qrSet);
                      if (!qrSet) {
                        qrSet = true;
                        CheckQRData(detailId,data);
                      }
                    },
                  )
              ),
            ),
            Positioned(
              top: 144,
              left: 40,
              right: 40,
              child: Image.asset(
                "assets/resource/qr/qrdomain.png",
                fit: BoxFit.fill,
                width: 280,
                height: 280,
              ),
            ),
            Positioned(
              bottom: 143,
              left: 0,
              right: 0,
              child: Text(
                "위 영역 안에 제공된\nQR코드를 스캔해주세요.",
                textAlign: TextAlign.center,
                style:
                TextStyle(color: white, fontFamily: 'noto', fontSize: 14),
              ),
            ),
            Positioned(
              top: 52,
              left: 16,
              child:
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                    child: Image.asset(
                      "assets/resource/public/prev.png",
                      width: 24,
                      height: 24,
                      color: white,
                    )),
              ),
            ),
            Positioned(
                top: 52,
                left: 0,
                child:
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(storeName,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'noto',
                        fontWeight: FontWeight.w700,
                        color: white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  CheckQRData(int id,String data) async {
    QRProvider qrProvider = Provider.of<QRProvider>(context, listen: false);
    String type = await qrProvider.checkQR(id,data);
    print("QRCHECKDATA");
    print(type);
    if (type == "NORMAL") {
      dialog(
          title: "결제안내",
          context: context,
          content: "${qrProvider.store.store.name}에서\n"
              "${numberFormat.format(qrProvider.paymentModel.price)}원을 결제하셨습니다.",
          sub: "실시간 흥정하기로 가시겠습니까?",
          selectOneText: "나중에",
          selectOneVoid: () => dialogPop(),
          selectTwoText: "확인",
          selectTwoVoid: () => payment(type, qrProvider.paymentModel.uuid));
    } else if (type == "DILLING") {
      dialog(
          title: "결제안내",
          context: context,
          content: "${qrProvider.store.store.name}에서"
              "\n결제금액 ${numberFormat.format(qrProvider.paymentModel.price)}원을\n"
              "${numberFormat.format(double.parse(qrProvider.paymentModel.dilling))} DL로 결제합니다.",
          sub: "DL로 결제 하시겠습니까?",
          selectOneText: "나중에",
          selectOneVoid: () => dialogPop(),
          selectTwoText: "결제",
          selectTwoVoid: () => payment(type, qrProvider.paymentModel.uuid));
    } else {
      Fluttertoast.showToast(msg: type);
    }
  }

  payment(type, uuid) async {
    QRProvider qrProvider = Provider.of<QRProvider>(context, listen: false);
    String t = await qrProvider.applyPayment(uuid);
    if(t == "1"){
      print(type);
      if (type == "NORMAL") {
        bargainMove();
      } else if (type == "DILLING") {
        await Provider.of<StoreProvider>(context, listen:false).clearMap();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainMap()), (route) => false);
      }
    }
  }
}
