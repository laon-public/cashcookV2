import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/log/orderLog.dart';
import 'package:cashcook/src/model/store/reviewWrite.dart';
import 'package:cashcook/src/screens/bargain/bargaingame2.dart';
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
  OrderLog ol;

  ServiceDetail({this.ol});

  @override
  _ServiceDetail createState() => _ServiceDetail();
}

class _ServiceDetail extends State<ServiceDetail> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> pointMap =  Provider.of<UserProvider>(context, listen: false).pointMap;
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          "${widget.ol.storeName} 이용내역",
          style: appBarDefaultText,
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  DateFormat("yyyy.MM.dd").format(widget.ol.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                    fontFamily: 'noto'
                  )
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  width: MediaQuery.of(context).size.width,
                  height: 64,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.ol.storeImg,
                        imageBuilder: (context, img) => Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(6.0)
                                ),
                                image: DecorationImage(
                                    image: img, fit: BoxFit.fill
                                )
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(widget.ol.storeName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'noto',
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF333333),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                whiteSpaceW(12),
                                Text(DateFormat('kk:mm').format(widget.ol.createdAt),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'noto',
                                        color: Color(0xFF999999)
                                    )
                                ),
                              ],
                            ),
                            Expanded(
                              child: Text(widget.ol.content,
                                style:TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'noto',
                                    color: Color(0xFF999999)
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),
                      whiteSpaceW(13.0),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("-${numberFormat.format(widget.ol.pay)} 원",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'noto',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF999999)
                                )
                            ),
                          ],
                        ),
                      )
                    ],
                  )
              ),
              Container(
                padding: EdgeInsets.only(bottom: 8.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ReviewWrite(
                                    store_id: widget.ol.storeId,
                                  )));
                        },
                        child: Container(
                          height: 40,
                          child: Center(
                            child: Text("리뷰작성",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'noto',
                                  color: Color(0xFF333333),
                                  fontWeight: FontWeight.w600
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
                          if(widget.ol.playGame){
                            showToast("게임을 이미 진행하였습니다.");
                          } else {
                            print("CARAT : ${pointMap['CARAT']}");
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => BargainGame2(
                                      orderId: widget.ol.id,
                                      orderPayment: widget.ol.pay - (widget.ol.dl * 100),
                                      totalCarat: pointMap['CARAT']
                                    ))
                                , (route) => false);
                          }

                        },
                        child: Container(
                            height: 40,
                            child: Center(
                              child: Text("실시간 흥정",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'noto',
                                    color: Color(0xFF333333),
                                    fontWeight: FontWeight.w600
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
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "결제내역",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'noto',
                    color: Color(0xFF333333)
                  ),
                ),
              ),
              Column(
                children: widget.ol.mainCatList.map((e) =>
                  mainCatItem(e)
                ).toList()
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 12.0),
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Color(0xFFDDDDDD)
              ),
              Container(
                padding: EdgeInsets.only(bottom: 12.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text("결제 총 금액",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'noto',
                        color: Color(0xFF333333)
                      )
                    ),
                    Spacer(),
                    Text("${numberFormat.format(widget.ol.pay)}원",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'noto',
                        color: primary
                      )
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 12.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text("DL 사용",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'noto',
                            color: Color(0xFF333333)
                        )
                    ),
                    Spacer(),
                    Text("${numberFormat.format(widget.ol.dl)} DL",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'noto',
                            color: Color(0xFF333333)
                        )
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 12.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text("실시간 흥정",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'noto',
                            color: Color(0xFF333333)
                        )
                    ),
                    Spacer(),
                    Text(widget.ol.playGame ?
                        widget.ol.pay == widget.ol.dl * 100 ?
                            "DL 결제는 실시간 흥정이 제공되지 않습니다."
                            :
                        "${numberFormat.format(widget.ol.gameQuantity)}DL 적립"
                        :
                        "아직 게임을 진행하지 않았습니다.",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'noto',
                            color: Color(0xFF333333)
                        )
                    ),
                  ],
                ),
              ),
              whiteSpaceH(54),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "결제방식",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'noto',
                      color: Color(0xFF333333)
                  ),
                ),
              ),
              whiteSpaceH(22),
              Container(
                width:MediaQuery.of(context).size.width,
                child: Text(widget.ol.logType == "ORDER" ?
                    widget.ol.bankInfo.cardName == "" ?
                    "무통장 입금"
                        :
                    "신용카드 / ${widget.ol.bankInfo.cardName} / ${widget.ol.bankInfo.cardNumber}"
                    :
                    "현장 QR결제 진행",
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'noto',
                      color: Color(0xFF333333)
                  ),
                )
              )
            ],
          ),
        ),
      ),
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
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child:Text(omc.menuName,
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                      fontFamily: 'noto'
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
          padding: EdgeInsets.only(bottom: 10.0),
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
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'noto',
                                    color: Color(0xFF444444)
                                )
                            ),
                          ),
                          Expanded(
                            child:Text(
                                "${numberFormat.format(osc.price)}원",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'noto',
                                    color: Color(0xFF444444)
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
                                        "${osc.amount}",
                                        style: TextStyle(
                                            fontFamily: 'noto',
                                            color: Colors.black,
                                            fontSize: 14
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
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'noto'
                            )
                        )
                    )
                )
              ]
          )
      );
  }
}