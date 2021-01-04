import 'package:cashcook/src/model/log/refundLog.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
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
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).fetchRefundRequest();
    });
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
      padding: EdgeInsets.symmetric(vertical: 12),
      margin: EdgeInsets.symmetric(horizontal: 16),
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
                child: Text("${numberFormat.format(refund.pay)} 원",
                  style: Headline.apply(
                    color: primary,
                    fontWeightDelta: 2
                  )
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
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