import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/log/orderLog.dart';
import 'package:cashcook/src/model/store/reviewWrite.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/screens/bargain/bargaingame2.dart';
import 'package:cashcook/src/screens/buy/refund.dart';
import 'package:cashcook/src/utils/FcmController.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

class OrderDetail extends StatefulWidget {
    @override
  OrderDetailState createState() => OrderDetailState();
}

class OrderDetailState extends State<OrderDetail> {
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
                                              sp.selLog.storeImg,
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
                                  sp.selLog.status != "BEFORE_CONFIRM" ?  Container() : Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        await sp.patchOrder(sp.selLog.id,"ORDER_CONFIRM").then((value) {
                                          if(value != null && value != "") {
                                            sendMessage("주문접수", "매장에서 주문이 접수되었습니다", value);
                                            showToast("주문을 접수 하셨습니다.");
                                          } else {
                                            showToast("주문접수에 실패 했습니다.");
                                          }
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 12),
                                        height: 40,
                                        child: Center(
                                          child: Text("접수완료",
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
                              Row(
                                children: [
                                  sp.selLog.logType != "QR"  // QR 결제 거르기
                                      &&
                                      !(sp.selLog.logType == "ORDER" && sp.selLog.bankInfo.cardName == "") && // 무통장 입금 거르기
                                      sp.selLog.status == "BEFORE_CONFIRM" || sp.selLog.status == "REFUND_REJECT" ? Expanded(
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
                              sp.selLog.logType != "QR"  // QR 결제 거르기
                                  &&
                                  !(sp.selLog.logType == "ORDER" && sp.selLog.bankInfo.cardName == "") && // 무통장 입금 거르기
                                  sp.selLog.status == "BEFORE_CONFIRM" || sp.selLog.status == "REFUND_REJECT" ?
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
}