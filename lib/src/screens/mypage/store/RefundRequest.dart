import 'dart:convert';

import 'package:cashcook/src/model/log/refundLog.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/services/IMPort.dart';
import 'package:cashcook/src/utils/FcmController.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RefundRequest extends StatefulWidget {
  @override
  _RefundRequest createState() => _RefundRequest();
}

class _RefundRequest extends State<RefundRequest> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).fetchRefundRequest();
    });

  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    AppBar appBar = AppBar(
      elevation: 0.5,
      backgroundColor: white,
      title: Text(
        "환불 요청서",
        style: appBarDefaultText,
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24, color: black,),
      ),
    );

    return Scaffold(
      backgroundColor: white,
      appBar: appBar,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
          child: SingleChildScrollView(
            child:
                Consumer<UserProvider>(
                  builder: (context, up, _){
                    return Column(
                      children: up.refundList.map((e) =>
                        RefundRequestItem(e)
                      ).toList()
                    );
                  },
                )
          ),
      ),
    );
  }

  Widget RefundRequestItem(RefundLogModel refund) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: deActivatedGrey,
            width: 1
          )
        )
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text("주문번호 : ${refund.impUid.split("imp_")[1]}",
                    style: Body2
                ),
              ),
              Expanded(
                child: Text("요청일시 : ${DateFormat('yy.MM.dd kk:mm').format(refund.createdAt)}",
                    style: Body2
                ),
              )
            ],
          ),
          whiteSpaceH(8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${numberFormat.format(refund.pay)} 원",
                        style: Headline.apply(
                            color: primary,
                            fontWeightDelta: 2
                        )
                      ),
                    whiteSpaceH(6),
                    Text("사유 : ${refund.reason}",
                        style: Body2.apply(
                          color: black
                        ),
                        overflow: TextOverflow.clip,
                    ),
                    ],
                  )
              ),
              (refund.status == "REFUND_CONFIRM") ?
                  Text("환불완료",
                      style: Body1
                  )
              :
              (refund.status == "REFUND_REJECT") ?
                  Text("환불거절",
                      style: Body1
                  )
              :
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        IMPortService importService = IMPortService();

                        try{
                          // 토큰 얻기
                          String response = await importService.getIMPORTToken();
                          Map<String, dynamic> json = jsonDecode(response);
                          String token = json['response']['access_token'];

                          response = await importService.refundIMPort(refund.impUid, refund.reason, token);

                          json = jsonDecode(response);
                          if(json['response'] == null) {
                            throw Exception(json['message']);
                          }

                          if(json['response']['status'].toString() == "cancelled"){
                            Provider.of<UserProvider>(context,listen: false).patchRefundRequest(refund.id, refund.orderId, "REFUND_CONFIRM").then((value) {
                              if (value != "") {
                                sendMessage("환불완료", "환불이 완료 되었습니다.", value);
                                showToast("환불 했습니다.");

                                Provider.of<UserProvider>(context, listen: false).fetchRefundRequest();
                              } else {
                                showToast("환불에 실패했습니다.");
                              }
                            });
                          } else {
                            throw Exception("IMPORT 환불 실패");
                          }
                        } catch(e) {
                            showToast("환불 요청에 실패했습니다.");
                            print(e);
                        }
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        child: Center(
                          child: Text("수락",
                              style: Body2.apply(
                                  color: white,
                                  fontWeightDelta: 3
                              )
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: primary,
                                width: 1
                            )
                        ),
                      ),
                    ),
                    whiteSpaceW(8),
                    InkWell(
                      onTap: () async {
                        Provider.of<UserProvider>(context,listen: false).patchRefundRequest(refund.id, refund.orderId, "REFUND_REJECT").then((value) {
                          if (value != "") {
                            sendMessage("환불거절", "환불이 거절 되었습니다.", value);
                            showToast("환불을 거절했습니다.");

                            Provider.of<UserProvider>(context, listen: false).fetchRefundRequest();
                          } else {
                            showToast("환불거절에 실패했습니다.");
                          }
                        });
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        child: Center(
                          child: Text("거절",
                              style: Body2.apply(
                                  color: primary,
                                  fontWeightDelta: 3
                              )
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: white,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Color(0xFFDDDDDD),
                                width: 1
                            )
                        ),
                      ),
                    ),
                  ],
                )
              )
            ],
          )
        ],
      ),
    );
  }
}