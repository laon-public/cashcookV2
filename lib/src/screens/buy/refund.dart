import 'package:cashcook/src/provider/UserProvider.dart';
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

class Refund extends StatefulWidget {
  @override
  _Refund createState() => _Refund();
}

class _Refund extends State<Refund> {

  TextEditingController reasonCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
    // TODO: implement build
    return Consumer<UserProvider>(
      builder: (context, up, _){
        return Scaffold(
          appBar: appBar,
          body:  Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
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
                                  ]
                              ),
                            )
                          ]
                      )
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1,
                    decoration: BoxDecoration(
                        color: deActivatedGrey
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("주문번호 : ${up.selLog.impUid.split("imp_")[1]}",
                            style: Body2.apply(
                                color: third
                            ),
                          ),
                          TextField(
                            controller: reasonCtrl,
                            cursorColor: Color(0xff000000),
                            style: Subtitle2.apply(
                                fontWeightDelta: 1
                            ),
                            autofocus: false,
                            decoration: InputDecoration(
                              hintStyle: Subtitle2.apply(
                                color: deActivatedGrey,
                              ),
                              hintText: "환불 사유를 입력해주세요.",
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: black, width: 2.0),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  Spacer(),
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child:RaisedButton(
                        color: mainColor,
                        onPressed: () async {
                          up.requestRefund(reasonCtrl.text).then((value) {
                            if(value != "") {
                              sendMessage("환불요청", "환불요청이 들어왔습니다.", value);
                              showToast("환불 요청 되었습니다.");
                              Navigator.of(context).pop();
                            } else {
                              showToast("환불 요청에 실패했습니다.");
                            }
                          });
                        },
                        elevation: 0.0,
                        child: Text("환불 요청",
                            style: Subtitle2.apply(
                                color: white,
                                fontWeightDelta: 1
                            )
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(6)
                            )
                        ),
                      )
                  )
                ],
              ),
            ),
          );
      },
    );
  }
}