import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/log/orderLog.dart';
import 'package:cashcook/src/model/store/reviewWrite.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/screens/bargain/bargaingame2.dart';
import 'package:cashcook/src/screens/buy/refund.dart';
import 'package:cashcook/src/utils/FcmController.dart';
import 'package:cashcook/src/utils/StatusMap.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class OrderDetail extends StatefulWidget {
    @override
  OrderDetailState createState() => OrderDetailState();
}

class OrderDetailState extends State<OrderDetail> {

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
    return Consumer<StoreProvider>(
      builder: (context,sp,_){
        return Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            elevation: 0.5,
            title: Text(
              "상세내역",
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
                              DateFormat("yyyy.MM.dd").format(sp.selLog.createdAt),
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
                                    sp.selLog.status.contains("DELIVERY") ?
                                    Image.asset(
                                        "assets/icon/delivery.png",
                                        width: 48,
                                        height: 48
                                    )
                                        :
                                    Image.asset(
                                        "assets/icon/packing.png",
                                        width: 48,
                                        height: 48
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
                                              Text(sp.selLog.storeName,
                                                style: Body1.apply(
                                                    color: black,
                                                    fontWeightDelta: 3
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              whiteSpaceW(12),
                                              Text(DateFormat('kk:mm').format(sp.selLog.createdAt),
                                                  style: Body2
                                              ),
                                            ],
                                          ),
                                          whiteSpaceH(3),
                                          Text(sp.selLog.content,
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
                                          Text("${numberFormat.format(sp.selLog.pay)} 원",
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
                              whiteSpaceH(12),

                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        if(sp.selLog.status == "BEFORE_CONFIRM") {
                                          await sp.patchOrder(sp.selLog.id,"ORDER_CONFIRM").then((value) {
                                            if(value != null && value != "") {
                                              sendMessage("주문접수", "성공스토어에서 주문이 접수되었습니다", value, "PROVIDER", "ORDER_CONFIRM", sp.selLog.id);
                                              showToast("주문을 접수 하셨습니다.");
                                            }
                                          });
                                        } else if(sp.selLog.status == "DELIVERY_REQUEST") {
                                          await sp.patchOrder(sp.selLog.id,"DELIVERY_READY").then((value) {
                                            if(value != null && value != "") {
                                              sendMessage("배달접수", "성공스토어에서 배달이 접수되었습니다", value, "PROVIDER", "DELIVERY_READY", sp.selLog.id);
                                              showToast("배달을 접수 하셨습니다.");
                                            }
                                          });
                                        } else if(sp.selLog.status == "DELIVERY_READY"){
                                          await sp.patchOrder(sp.selLog.id,"DELIVERY_START").then((value) {
                                            if(value != null && value != "") {
                                              sendMessage("배달출발", "배달이 시작되었습니다", value, "PROVIDER", "DELIVERY_START", sp.selLog.id);
                                              showToast("배달을 시작합니다.");
                                            } else {
                                              showToast("배달 시작 알림에 실패 하셨습니다.");
                                            }
                                          });
                                        } else {
                                          showToast("주문이 완료되었습니다.");
                                        }

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 12),
                                        height: 40,
                                        child: Center(
                                          child: Text(
                                            sp.selLog.status == "BEFORE_CONFIRM" ?
                                            "주문접수"
                                            :
                                            sp.selLog.status == "DELIVERY_REQUEST" ?
                                            "배달접수"
                                            :
                                            sp.selLog.status == "DELIVERY_READY" ?
                                            "배달출발"
                                            :
                                            OrderStatusByProvider[sp.selLog.status],
                                            style: Body1.apply(
                                              color: secondary,
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: sp.selLog.status == "BEFORE_CONFIRM" ||
                                              sp.selLog.status == "DELIVERY_REQUEST" ||
                                              sp.selLog.status == "DELIVERY_READY" ?
                                              white
                                              :
                                              deActivatedGrey,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  sp.selLog.status.contains("DELIVERY") ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: Color(0xFFF7F7F7)
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            whiteSpaceH(12),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 11),
                                child: Text("주문자 정보",
                                  style: Subtitle2.apply(
                                      fontWeightDelta: 3
                                  ),
                                )
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 13),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("이름",
                                      style: Body1.apply(
                                          fontWeightDelta: 5
                                      ),
                                    ),
                                    whiteSpaceH(4),
                                    Text("${sp.selLog.deliveryAddress.address}",
                                      style: Body1.apply(
                                        fontWeightDelta: -1,
                                        color: secondary
                                      ),
                                    ),
                                    whiteSpaceH(4),
                                    Text("${sp.selLog.deliveryAddress.detail}",
                                      style: Body2.apply(
                                          color: third
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 13),
                                child: Text("연락처 : ${sp.selLog.deliveryAddress.userPhone}",
                                  style: Body1.apply(
                                      color: black
                                  ),
                                ),
                            ),
                            whiteSpaceH(12)
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 8,
                        color: Color(0xFFF2F2F2)
                      )
                    ],
                  )
                  :
                  Container(),
                  Padding(
                    padding:EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
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
                            children: sp.selLog.mainCatList.map((e) =>
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
                              Text("${numberFormat.format(sp.selLog.pay)}원",
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
                              Text("${numberFormat.format(sp.selLog.dl)} DL",
                                  style: Body1.apply(
                                      color: primary,
                                      fontWeightDelta: 1
                                  )
                              ),
                              Spacer(),
                              Text("- ${numberFormat.format(sp.selLog.dl * 100)}원",
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
                              Text("${numberFormat.format(sp.selLog.pay - (sp.selLog.dl * 100))}원",
                                  style: Subtitle2.apply(
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
                              child: Text(sp.selLog.logType == "ORDER" ?
                              sp.selLog.bankInfo.cardName == "" ?
                              "무통장 입금"
                                  :
                              "신용카드 / ${sp.selLog.bankInfo.cardName} / ${sp.selLog.bankInfo.cardNumber}"
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

        if(message['data']['userType'].toString() == "CONSUMER" &&
            message['data']['orderId'] != null &&
          int.parse(message['data']['orderId'].toString()) == Provider.of<StoreProvider>(context, listen: false).selLog.id
        ) {
          await Provider.of<StoreProvider>(context, listen: false).setSellogStatus(
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