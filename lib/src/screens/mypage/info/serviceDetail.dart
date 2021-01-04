import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/log/orderLog.dart';
import 'package:cashcook/src/model/store/reviewWrite.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/screens/bargain/bargaingame2.dart';
import 'package:cashcook/src/screens/buy/refund.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

class ServiceDetail extends StatefulWidget {
  ServiceDetail();

  @override
  _ServiceDetail createState() => _ServiceDetail();
}

class _ServiceDetail extends State<ServiceDetail> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> pointMap =  Provider.of<UserProvider>(context, listen: false).pointMap;
    // TODO: implement build
    return Consumer<UserProvider>(
      builder: (context,up,_){
        return Scaffold(
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
                Navigator.of(context).pop();
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
                              whiteSpaceH(12),
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
                                      onTap: () {
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
                              ),
                              Row(
                                children: [
                                  up.selLog.status == "CONFIRM" || up.selLog.status == "REFUND_REQUEST" || up.selLog.status == "REFUND_CONFIRM" ? Container() : Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Provider.of<UserProvider>(context, listen: false).confirmPurchase(up.selLog.id);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 12),
                                        height: 40,
                                        child: Center(
                                          child: Text("구매확정",
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
                              up.selLog.status == "CONFIRM" || up.selLog.status == "REFUND_REQUEST" || up.selLog.status == "REFUND_CONFIRM" ? Container() :
                              Text("* 구매확정을 하셔야 DL적립을 받으실 수 있습니다.",
                                style: Caption.apply(

                                ),
                                textAlign: TextAlign.end,
                              ),
                              Row(
                                children: [
                                  up.selLog.logType != "QR"  // QR 결제 거르기
                                      &&
                                      !(up.selLog.logType == "ORDER" && up.selLog.bankInfo.cardName == "") && // 무통장 입금 거르기
                                        up.selLog.status == "BEFORE_CONFIRM" || up.selLog.status == "REFUND_REJECT" ? Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => Refund()
                                          )
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 12),
                                        height: 40,
                                        child: Center(
                                          child: Text("환불 요청",
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
                                  :
                                  Container(),
                                ],
                              ),
                              up.selLog.logType != "QR"  // QR 결제 거르기
                                  &&
                                  !(up.selLog.logType == "ORDER" && up.selLog.bankInfo.cardName == "") && // 무통장 입금 거르기
                                  up.selLog.status == "BEFORE_CONFIRM" || up.selLog.status == "REFUND_REJECT" ?
                              Text("* 구매확정 전에는 환불요청을 하실 수 있습니다.",
                                style: Caption.apply(

                                ),
                                textAlign: TextAlign.end,
                              )
                              :
                              Container()
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
}