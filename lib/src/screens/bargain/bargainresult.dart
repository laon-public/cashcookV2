import 'package:cashcook/src/provider/QRProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BargainResult extends StatefulWidget {
  @override
  _BargainResult createState() => _BargainResult();
}

class _BargainResult extends State<BargainResult> {
  @override
  Widget build(BuildContext context) {
    QRProvider qrProvider = Provider.of<QRProvider>(context, listen: false);
    String discount = qrProvider.paymentModel.discount;
    int n_discount = int.parse(discount);

    double percentage = n_discount.toDouble() * 0.01;

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainMap()),
            (route) => false);
        return null;
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MainMap()),
                  (route) => false);
            },
            icon: Image.asset(
              "assets/resource/public/close.png",
              width: 24,
              height: 24,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: white,
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "결제 후 추가할인\n결과보기",
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'noto',
                      color: black,
                      fontWeight: FontWeight.w600),
                ),
                whiteSpaceH(210),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${numberFormat.format(qrProvider.paymentModel.price)} 원",
                          style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'noto',
                              fontSize: 24),
                        ),
                        whiteSpaceH(4),
                        Text(
                          "결제 금액",
                          style: TextStyle(
                              fontSize: 14, fontFamily: 'noto', color: white),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  decoration: BoxDecoration(
                      color: white,
                      border: Border.all(color: mainColor, width: 3),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${qrProvider.paymentModel.discount} %", style: TextStyle(
                                color: black, fontFamily: 'noto', fontSize: 24, fontWeight: FontWeight.w600
                              ),),
                              whiteSpaceH(4),
                              Text("할인율", style: TextStyle(
                                fontSize: 14, fontFamily: 'noto', color: black
                              ),)
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 3,
                        height: 80,
                        color: mainColor,
                      ),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(16))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${demicalFormat.format(qrProvider.paymentModel.price * percentage / 100)} DL", style: TextStyle(
                                  color: black, fontFamily: 'noto', fontSize: 24, fontWeight: FontWeight.w600
                              ),),
                              whiteSpaceH(4),
                              Text("적립 DL", style: TextStyle(
                                  fontSize: 14, fontFamily: 'noto', color: black
                              ),)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                whiteSpaceH(40),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => MainMap()),
                              (route) => false);
                    },
                    color: mainColor,
                    child: Center(
                      child: Text("완료", style: TextStyle(
                        color: white, fontFamily: 'noto', fontSize: 14
                      ),),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
