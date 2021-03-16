import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeliveryModify extends StatefulWidget {
  @override
  DeliveryModifyState createState() => DeliveryModifyState();
}

class DeliveryModifyState extends State<DeliveryModify> {

  bool deliveryState;
  TextEditingController deliveryTime;
  TextEditingController deliveryAmount;
  TextEditingController minOrderAmount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StoreModel myStore = Provider.of<UserProvider>(context, listen: false).storeModel;

    deliveryState = myStore.store.deliveryStatus == "1" ? true : false;
    deliveryTime = TextEditingController(text: myStore.store.deliveryTime == null ? "" : myStore.store.deliveryTime);
    deliveryAmount = TextEditingController(text: myStore.store.deliveryAmount == null || myStore.store.deliveryAmount == "null" ? "" : myStore.store.deliveryAmount);
    minOrderAmount = TextEditingController(text: myStore.store.minOrderAmount == null ? "" : myStore.store.minOrderAmount);

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AppBar appBar = AppBar(
      title: Text("배달 설정",
          style: appBarDefaultText
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
      ),
      centerTitle: true,
      elevation: 1.0,
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 12, bottom: 20),
                padding: EdgeInsets.symmetric(vertical: 13),
                child: Row(
                  children: [
                    Text("배달 설정",
                      style: Subtitle2,
                    ),
                    Spacer(),
                    Switch(
                      activeColor: primary,
                      value: deliveryState,
                      onChanged: (val) {
                        setState(() {
                          deliveryState = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("평균배달 소요시간",
                      style: Body2.apply(
                          color: third
                      )
                  ),
                  TextField(
                    style: Subtitle2,
                    controller: deliveryTime,
                    decoration: InputDecoration(
                      hintText: "예) 30~50분, 결제 1일 후 출고",
                      hintStyle: Subtitle2.apply(
                        color: third,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: black, width: 2.0),
                      ),
                    ),
                  )
                ],
              ),
              whiteSpaceH(20),
              Text("최소주문 금액",
                  style: Body2.apply(
                      color: third
                  )
              ),
              whiteSpaceH(8),
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/resource/public/krw-coin.png",
                        width: 40,
                        height: 40,
                      ),
                      whiteSpaceW(12),
                      Expanded(
                          child: TextField(
                            style: Subtitle2,
                            maxLines: 1,
                            controller: minOrderAmount,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.end,
                            decoration: InputDecoration(
                              suffixText: "원",
                              suffixStyle: Subtitle2,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: black, width: 2.0),
                              ),
                            ),
                          )
                      )
                    ],
                  )
              ),
              whiteSpaceH(20),
              Text("배달비",
                  style: Body2.apply(
                      color: third
                  )
              ),
              whiteSpaceH(8),
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/resource/public/krw-coin.png",
                        width: 40,
                        height: 40,
                      ),
                      whiteSpaceW(12),
                      Expanded(
                          child: TextField(
                            style: Subtitle2,
                            maxLines: 1,
                            controller: deliveryAmount,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.end,
                            decoration: InputDecoration(
                              suffixText: "원",
                              suffixStyle: Subtitle2,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: black, width: 2.0),
                              ),
                            ),
                          )
                      )
                    ],
                  )
              ),
              Spacer(),
              Consumer<StoreServiceProvider>(
                builder: (context, ssp, _){
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: RaisedButton(
                      child: ssp.isDeliveryLoading ?
                        Center(
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
                          )
                        )
                          :
                        Text("확인",
                          style: Subtitle2.apply(
                              color: white,
                              fontWeightDelta: 1
                          ),
                        ),
                      onPressed: ssp.isDeliveryLoading ? null : () async {
                        await ssp.patchDelivery(
                            Provider.of<UserProvider>(context, listen: false).storeModel.id
                            , deliveryTime.text, deliveryAmount.text, deliveryState, minOrderAmount.text);

                        await Provider.of<UserProvider>(context, listen: false).fetchMyInfo();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(6.0)
                          )
                      ),
                      elevation: 0.0,
                      color: primary,
                    ),
                  );
                },
              )
            ],
          ),
        )
      )
    );
  }
}