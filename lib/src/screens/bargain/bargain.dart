
import 'package:cashcook/src/provider/QRProvider.dart';
import 'package:cashcook/src/screens/bargain/bargainresult.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/slot/roll_slot.dart';
import 'package:cashcook/src/utils/slot/roll_slot_controller.dart';

class Bargain extends StatefulWidget {
  @override
  _Bargain createState() => _Bargain();
}

class _Bargain extends State<Bargain> {
  List<int> values = List.generate(10, (index) => index);
  int i=0;
  bool isShow = true;
  var _rollSlotController100 = RollSlotController();
  var _rollSlotController10 = RollSlotController();
  var _rollSlotController1 = RollSlotController();

  var rp;

  @override
  void initState() {
    super.initState();
    _rollSlotController1.addListener(() {
      if(isShow) {
        print(_rollSlotController1.state);
        if(_rollSlotController1.state == RollSlotControllerState.stopped){
          if (!Provider
              .of<QRProvider>(context, listen: false)
              .isStop) {
            Provider.of<QRProvider>(context, listen: false).changeStop();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Consumer<QRProvider>(
            builder: (context, qrProvider, _) {
                String discount = qrProvider.paymentModel.discount;
                int count = discount.length;
                int n_discount = int.parse(discount);

                double percentage = n_discount.toDouble() * 0.01;

                String one = count == 1
                    ? "0"
                    : count == 2 ? "0" : count == 3 ? discount[0] : "0";

                String two = count == 1
                    ? "0"
                    : count == 2 ? discount[0] : count == 3 ? discount[1] : "0";

                String three = count == 1
                    ? discount[0]
                    : count == 2 ? discount[1] : count == 3 ? discount[2] : "0";

                if(isShow && !qrProvider.isStop) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _rollSlotController100.idx = int.parse(one);
                    _rollSlotController10.idx = int.parse(two);
                    _rollSlotController1.idx = int.parse(three);

                    _rollSlotController100.animateRandomly();
                    _rollSlotController10.animateRandomly();
                    _rollSlotController1.animateRandomly();
                  });
                }

              return Container(
                width: MediaQuery.of(context).size.width,
                color: white,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "결제 후 추가할인",
                      style: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'noto',
                          fontSize: 32),
                      textAlign: TextAlign.center,
                    ),
                    whiteSpaceH(44),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6)),
                          color: mainColor),
                      child: Center(
                        child: Text(
                          "${numberFormat.format(qrProvider.paymentModel.price)}원 결제",
                          style: TextStyle(
                              color: white,
                              fontSize: 16,
                              fontFamily: 'noto',
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 160,
                      decoration: BoxDecoration(
                          color: white,
                          border: Border.all(color: mainColor, width: 3),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.10),
                                blurRadius: 16)
                          ],
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6))),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 56,
                              height: 80,
                              decoration: BoxDecoration(
                                color: black,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Slot(
                                  _rollSlotController100,
                                  isShow ? one : "0",
                                  Duration(milliseconds: 1000)),
                            ),
                            whiteSpaceW(8),
                            Container(
                              width: 56,
                              height: 80,
                              decoration: BoxDecoration(
                                color: black,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Slot(
                                    _rollSlotController10,
                                    isShow ? two : "0",
                                    Duration(milliseconds: 1300)),
                              ),
                            ),
                            whiteSpaceW(8),
                            Container(
                              width: 56,
                              height: 80,
                              decoration: BoxDecoration(
                                color: black,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Slot(
                                    _rollSlotController1,
                                    isShow ? three : "0",
                                    Duration(milliseconds: 1500)),
                              ),
                            ),
                            whiteSpaceW(8),
                            Text(
                              "%",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'noto',
                                  fontWeight: FontWeight.w600,
                                  color: black),
                            )
                          ],
                        ),
                      ),
                    ),
                    whiteSpaceH(16),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      child: RaisedButton(
                        onPressed: () async {
                          if(qrProvider.isStop) {
                            await qrProvider
                                .discountPayment(qrProvider.paymentModel.uuid);
                          } else {
                            showToast("게임이 진행 중 입니다.");
                          }
                        },
                        color: mainColor,
                        elevation: 0.1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              qrProvider.isStop ? "${demicalFormat.format(qrProvider.paymentModel.price * percentage / 100)} DL 적립" : "게임 진행 중 입니다.",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'noto',
                                  color: white,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              (qrProvider.isStop) ? "재도전 하시겠습니까?" : "",
                              style: TextStyle(
                                  color: white,
                                  fontFamily: 'noto',
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    whiteSpaceH(8),
                    Text("재도전 시 ${((qrProvider.paymentModel.price / 100000).ceil()*1000) } RP가 차감됩니다."),
                    whiteSpaceH(84),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: RaisedButton(
                        onPressed: () async {
                          // await qrProvider
                          //     .confirmPayment(qrProvider.paymentModel.uuid);

                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => BargainResult()));
                        },
                        elevation: 0.1,
                        color: mainColor,
                        child: Center(
                          child: Text(
                            "할인받기",
                            style: TextStyle(
                                color: white, fontFamily: 'noto', fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    whiteSpaceH(16)
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget Slot(controller, idx, duration) {
    int _idx = int.parse(idx);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: RollSlot(
              duration: duration,
              itemExtend: 300,
              shuffleList: false,
              idx: _idx,
              rollSlotController: controller,
              children: values
                  .map(
                    (e) => BuildItem(
                      index: e,
                    ),
                  )
                  .toList()),
        ),
      ],
    );
  }
}

class BuildItem extends StatelessWidget {
  const BuildItem({
    Key key,
    this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        index.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 36,
        ),
      ),
    );
  }
}
