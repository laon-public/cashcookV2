import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/provider/GameProvider.dart';
import 'package:cashcook/src/screens/bargain/NewBargain.dart';
import 'package:cashcook/src/utils/StatusMap.dart';
import 'package:cashcook/src/model/log/orderLog.dart';
import 'package:cashcook/src/model/store/reviewWrite.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/screens/bargain/bargaingame2.dart';
import 'package:cashcook/src/screens/buy/refund.dart';
import 'package:cashcook/src/services/IMPort.dart';
import 'package:cashcook/src/utils/FcmController.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class ServiceDetail extends StatefulWidget {
  ServiceDetail();

  @override
  _ServiceDetail createState() => _ServiceDetail();
}

class _ServiceDetail extends State<ServiceDetail> {

  bool isUpdate = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseCloudMessaging_Listeners();
    isUpdate = false;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> pointMap =  Provider.of<UserProvider>(context, listen: false).pointMap;
    // TODO: implement build
    return Consumer<UserProvider>(
      builder: (context,up,_){
        return Stack(
          children: [
            Scaffold(
              backgroundColor: white,
              appBar: AppBar(
                elevation: 0.5,
                title: Text(
                  "상세 이용내역",
                  style: appBarDefaultText,
                ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    initFCM();
                    Navigator.of(context).pop(isUpdate);
                  },
                  icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24, color: black,),
                ),
              ),
              body:  Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 24.0, bottom: 4.0),
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                  DateFormat("yyyy.MM.dd").format(up.selLog.createdAt),
                                  style: Body2.apply(
                                      color: secondary
                                  )
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 48,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6)
                                              ),
                                              border: Border.all(
                                                  color: Color(0xFFDDDDDD),
                                                  width: 0.5
                                              ),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  up.selLog.storeImg,
                                                ),
                                              )
                                          ),
                                        ),
                                        whiteSpaceW(13.0),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(up.selLog.storeName,
                                                    style: Body1.apply(
                                                        color: black,
                                                        fontWeightDelta: 3
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  whiteSpaceW(12),
                                                  Text(DateFormat('kk:mm').format(up.selLog.createdAt),
                                                      style: Body2
                                                  ),
                                                ],
                                              ),
                                              whiteSpaceH(3),
                                              Text(up.selLog.content,
                                                style:Body2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        whiteSpaceW(13.0),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text("${numberFormat.format(up.selLog.pay)} 원",
                                                  style: Body1.apply(
                                                      color: secondary,
                                                      fontWeightDelta: 1
                                                  )
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  !(up.selLog.status == "BEFORE_CONFIRM" || up.selLog.status == "DELIVERY_REQUEST" || up.selLog.status == "REFUND_CONFIRM") ?
                                  whiteSpaceH(12) : Container(),
                                  !(up.selLog.status == "BEFORE_CONFIRM" || up.selLog.status == "DELIVERY_REQUEST" || up.selLog.status == "REFUND_CONFIRM") ?
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: (up.selLog.reviewId == 0 ) ? () async {
                                            await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) => ReviewWrite(
                                                      store_id: up.selLog.storeId,
                                                      order_id: up.selLog.id,
                                                    )));
                                          }
                                              :
                                              () {
                                            showToast("이미 리뷰를 작성 했습니다.");
                                          },
                                          child: Container(
                                            height: 40,
                                            child: Center(
                                              child: Text("리뷰작성",
                                                style: Body1.apply(
                                                  color: secondary,
                                                ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xFFDDDDDD),
                                                    width: 1
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                      whiteSpaceW(8.0),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            if(up.selLog.status == "REFUND_REQUEST") {
                                              showToast("환불 요청 중에는\n게임을 진행할 수 없습니다.");
                                              return;
                                            }

                                            if(up.selLog.status == "REFUND_CONFIRM") {
                                              showToast("환불된 주문에는\n게임을 진행할 수 없습니다.");
                                              return;
                                            }
                                            if(up.selLog.playGame){
                                              showToast("게임을 이미 진행하였습니다.");
                                            } else {
                                              print("CARAT : ${pointMap['CARAT']}");
                                              // await Provider.of<GameProvider>(context, listen: false).init();
                                              // Navigator.of(context).push(
                                              //         MaterialPageRoute(
                                              //             builder: (context) => NewBargain(
                                              //             )
                                              //         ));
                                              Navigator.of(context).pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) => BargainGame2(
                                                          orderId: up.selLog.id,
                                                          orderPayment: up.selLog.pay - (up.selLog.dl * 100),
                                                          totalCarat: pointMap['CARAT']
                                                      ))
                                                  , (route) => false);
                                            }

                                          },
                                          child: Container(
                                            height: 40,
                                            child: Center(
                                              child: Text("실시간 흥정",
                                                style: Body1.apply(
                                                  color: secondary,
                                                ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xFFDDDDDD),
                                                    width: 1
                                                )
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ) : Container(),
                                  up.selLog.logType == "QR"  // QR 결제 거르기
                                      ? Container() :
                                  whiteSpaceH(12),
                                  up.selLog.logType == "QR" || up.selLog.status == "CONFIRM"  // QR 결제 거르기
                                      ? Container() :
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            if(up.selLog.status == "BEFORE_CONFIRM" || up.selLog.status == "DELIVERY_REQUEST") {
                                              up.startRefunding();
                                              IMPortService importService = IMPortService();

                                              try{
                                                // 토큰 얻기
                                                if(up.selLog.bankInfo.cardName != ""){
                                                  String response = await importService.getIMPORTToken();
                                                  Map<String, dynamic> json = jsonDecode(response);
                                                  String token = json['response']['access_token'];

                                                  response = await importService.refundIMPort(up.selLog.impUid, "주문취소", token);

                                                  json = jsonDecode(response);
                                                  if(json['response'] == null) {
                                                    throw Exception(json['message']);
                                                  }

                                                  if(json['response']['status'].toString() != "cancelled"){
                                                    showToast("IMPORT 환불실패");
                                                    return;
                                                  }
                                                }

                                                Provider.of<StoreProvider>(context,listen: false).patchOrder(up.selLog.id,"REFUND_CONFIRM").then((value) {
                                                  if (value != "") {
                                                    sendMessage("주문취소", "고객이 주문을 취소했습니다.", value, "CONSUMER","REFUND_CONFIRM", up.selLog.id);
                                                    showToast("환불 했습니다.");

                                                    Provider.of<UserProvider>(context, listen: false).setSellogStatus("REFUND_CONFIRM");
                                                  } else {
                                                    showToast("환불에 실패했습니다.");
                                                  }
                                                });
                                              } catch(e) {
                                                showToast("환불 요청에 실패했습니다.");
                                                print(e);
                                              } finally {
                                                up.stopRefunding();
                                              }
                                            } else {
                                              showToast("접수된 주문은 환불이 불가합니다\n"
                                                  "매장에 문의 해주세요.");
                                            }
                                          },
                                          child: Container(
                                            height: 40,
                                            child: Center(
                                              child: Text(
                                                "주문 취소",
                                                style: Body1.apply(
                                                  color: secondary,
                                                ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: !(up.selLog.status == "BEFORE_CONFIRM" || up.selLog.status == "DELIVERY_REQUEST") ? deActivatedGrey : white,
                                                border: Border.all(
                                                    color: Color(0xFFDDDDDD),
                                                    width: 1
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                      whiteSpaceW(8.0),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            // if(up.selLog.status == "ORDER_CONFIRM" || up.selLog.status == "DELIVERY_READY" || up.selLog.status == "DELIVERY_START" || up.selLog.status == "DELIVERY_END"){
                                            //   Provider.of<UserProvider>(context, listen: false).confirmPurchase(up.selLog.id);
                                            // } else {
                                            //
                                            // }
                                          },
                                          child: Container(
                                            height: 40,
                                            child: Center(
                                              child: Text("${OrderStatusByConsumer[up.selLog.status]}",
                                                style: Body1.apply(
                                                  color: secondary,
                                                ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xFFDDDDDD),
                                                    width: 1
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  up.selLog.logType != "QR"  // QR 결제 거르기
                                      &&
                                      (up.selLog.status == "ORDER_CONFIRM" || up.selLog.status == "DELIVERY_READY" || up.selLog.status == "DELIVERY_START" || up.selLog.status == "DELIVERY_END")  ?
                                  Text("* 구매확정을 하셔야 DL적립을 받으실 수 있습니다.",
                                    style: Caption,
                                    textAlign: TextAlign.end,
                                  )
                                      :
                                  Container(),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 19),
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                "주문내역",
                                style: Subtitle2.apply(
                                    fontWeightDelta: 1
                                ),
                              ),
                            ),
                            Column(
                                children: up.selLog.mainCatList.map((e) =>
                                    mainCatItem(e)
                                ).toList()
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 24.0, bottom: 12.0),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Text("총 주문 금액",
                                      style: Body1.apply(
                                          color: black,
                                          fontWeightDelta: 1
                                      )
                                  ),
                                  Spacer(),
                                  Text("${numberFormat.format(up.selLog.pay)}원",
                                      style: Body1.apply(
                                          color: primary,
                                          fontWeightDelta: 1
                                      )
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 12.0),
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                color: Color(0xFFDDDDDD)
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Text("DL 결제 수량",
                                      style: Body1.apply(
                                          color: black,
                                          fontWeightDelta: 1
                                      )
                                  ),
                                  whiteSpaceW(16),
                                  Text("${numberFormat.format(up.selLog.dl)} DL",
                                      style: Body1.apply(
                                          color: primary,
                                          fontWeightDelta: 1
                                      )
                                  ),
                                  Spacer(),
                                  Text("- ${numberFormat.format(up.selLog.dl * 100)}원",
                                      style: Body1.apply(
                                          color: secondary,
                                          fontWeightDelta: 1
                                      )
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Text("최종 결제 금액",
                                      style: Subtitle2.apply(
                                          fontWeightDelta: 1
                                      )
                                  ),
                                  Spacer(),
                                  Text("${numberFormat.format(up.selLog.pay - (up.selLog.dl * 100))}원",
                                      style: Subtitle2.apply(
                                          color: primary,
                                          fontWeightDelta: 1
                                      )
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Text("* 실시간 흥정",
                                      style: Body1.apply(
                                          color: black,
                                          fontWeightDelta: 1
                                      )
                                  ),
                                  Spacer(),
                                  Text(up.selLog.playGame ?
                                  up.selLog.pay == up.selLog.dl * 100 ?
                                  "DL 결제는 실시간 흥정이 제공되지 않습니다."
                                      :
                                  "${numberFormat.format(up.selLog.gameQuantity)}DL 적립"
                                      :
                                  "아직 게임을 진행하지 않았습니다.",
                                      style: Body1.apply(
                                          color: primary,
                                          fontWeightDelta: 1
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 8,
                        color: Color(0xFFF2F2F2),
                      ),
                      whiteSpaceH(23),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                    "결제방식",
                                    style: Subtitle2.apply(
                                        fontWeightDelta: 1
                                    )
                                ),
                              ),
                              whiteSpaceH(22),
                              Container(
                                  width:MediaQuery.of(context).size.width,
                                  child: Text(up.selLog.logType == "ORDER" ?
                                  up.selLog.bankInfo.cardName == "" ?
                                  "무통장 입금"
                                      :
                                  "신용카드 / ${up.selLog.bankInfo.cardName} / ${up.selLog.bankInfo.cardNumber}"
                                      :
                                  "현장 QR결제 진행",
                                    style: Body1.apply(
                                        color: black
                                    ),
                                  )
                              )
                            ],
                          )
                      ),
                      whiteSpaceH(40)
                    ],
                  ),
                ),
              ),
            ),
            up.isRefunding ?
            Positioned.fill(
                child: Container(
                  child: Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
                      )
                  ),
                  decoration: BoxDecoration(
                    color: black.withOpacity(0.7)
                  ),
                )
            ) : Container(),
          ],
        );
      },
    );
  }

  Widget mainCatItem(OrderMainCat omc) {
    int idx = 0;
    return Container(
      width: MediaQuery.of(context).size.width,
      child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Padding(
                padding: EdgeInsets.only(top: 26),
                child:Text(omc.menuName,
                  style: Body2.apply(
                    fontWeightDelta: 1
                  ),
                  textAlign: TextAlign.start,
                )
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                  omc.subCatList.map((e) =>
                    subCatItem(e)
                  ).toList(),
            )
          ]
      )
    );
  }

  Widget subCatItem(OrderSubCat osc) {
    return
      Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 4,
                    child: Row(
                        children: [
                          Expanded(
                            child:Text(
                                "${osc.menuName}",
                                style: Body1.apply(
                                  color: black
                                )
                            ),
                          ),
                          Expanded(
                            child:Text(
                                "${numberFormat.format(osc.price)}원",
                                style: Body2.apply(
                                    color: third,
                                  fontWeightDelta: 1,
                                )
                            ),
                          ),
                        ]
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Row(
                        children: [
                          Expanded(
                              child: Container(
                                width: 24,
                                height: 24,
                                child: Center(
                                    child: Text(
                                        "X ${osc.amount}",
                                        style: Body1.apply(
                                            color: black
                                        )
                                    )
                                ),
                              )
                          ),
                        ]
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                        color: Colors.white,
                        child: Text(
                            "${numberFormat.format(osc.price *
                                osc.amount)}원",
                            textAlign: TextAlign.end,
                            style: Body1.apply(
                                color: secondary,
                              fontWeightDelta: 1
                            )
                        )
                    )
                )
              ]
          )
      );
  }

  void initFCM() async {
    await _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );

    _firebaseMessaging.configure(
      // 앱이 포그라운드 상태, 앱이 전면에 켜져있기 때문에 푸시 알림 UI가 표시되지 않음.
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        FlutterRingtonePlayer.playNotification(looping: false);

        Fluttertoast.showToast(msg: message['notification']['body']);
      },
      // 앱이 백그라운드 상태, 푸시 알림 UI를 누른 경우에 호출된다. 앱이 포그라운드로 전환됨.
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      // 앱이 꺼진 상태일 때, 푸시 알림 UI를 눌러 앱을 시작하는 경우에 호출된다.
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }
  void firebaseCloudMessaging_Listeners() async {
    await _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );

    _firebaseMessaging.configure(
      // 앱이 포그라운드 상태, 앱이 전면에 켜져있기 때문에 푸시 알림 UI가 표시되지 않음.
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        FlutterRingtonePlayer.playNotification(looping: false);

        if(message['data']['userType'].toString() == "PROVIDER" &&
            message['data']['orderId'] != null &&
            int.parse(message['data']['orderId'].toString()) == Provider.of<UserProvider>(context, listen: false).selLog.id) {
          await Provider.of<UserProvider>(context, listen: false).setSellogStatus(
              message['data']['status']
          );
        } else {
          setState(() {
            isUpdate = true;
          });
        }

        Fluttertoast.showToast(msg: message['notification']['body']);
      },
      // 앱이 백그라운드 상태, 푸시 알림 UI를 누른 경우에 호출된다. 앱이 포그라운드로 전환됨.
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      // 앱이 꺼진 상태일 때, 푸시 알림 UI를 눌러 앱을 시작하는 경우에 호출된다.
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }
}