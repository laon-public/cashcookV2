import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/bargain/bargaingame2.dart';
import 'package:cashcook/src/screens/buy/buy.dart';
import 'package:cashcook/src/screens/mypage/info/serviceList.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

class OrderMenu extends StatefulWidget {
  final String name;
  final String store_id;
  final StoreModel store;

  OrderMenu({this.name,this.store_id, this.store});

  @override
  _OrderMenu createState() => _OrderMenu();
}

class _OrderMenu extends State<OrderMenu> {
  int currentMethod = 0;
  bool isAgreeCheck = false;


  Map<int, String> paymentType = {
    0: "ORDER_CREDIT_CARD",
    1: "ORDER_WITHOUT_BANK",
    2: "ORDER_DILLING"
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> pointMap =  Provider.of<UserProvider>(context, listen: false).pointMap;
    StoreModel store = widget.store == null ? Provider.of<StoreProvider>(context, listen: false).selStore : widget.store;
    // TODO: implement build
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
                elevation: 1,
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Text("주문서 작성",
                    style: appBarDefaultText
                ),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
              ),
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            whiteSpaceH(23),
                            Text("주문내역",
                                style: Subtitle2.apply(
                                    fontWeightDelta: 1
                                )),
                            whiteSpaceH(26),
                            Consumer<StoreServiceProvider>(
                                builder: (context, ss, _) {
                                  return orderList(ss.orderList);
                                }
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 1,
                              color: Color(0xFFF7F7F7),
                            ),
                            whiteSpaceH(22),
                            Consumer<StoreServiceProvider>(
                                builder: (context, ss, _){
                                  return Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                              "총 주문 금액",
                                              style: Body1.apply(
                                                  color: black,
                                                  fontWeightDelta: 1
                                              ),
                                              textAlign: TextAlign.start,
                                            )
                                        ),
                                        Expanded(
                                            child: Text(
                                              "${numberFormat.format(ss.orderPay)}원",
                                              style: Body1.apply(
                                                  color: primary,
                                                  fontWeightDelta: 1
                                              ),
                                              textAlign: TextAlign.end,
                                            )
                                        )
                                      ]
                                  );
                                }
                            ),
                            whiteSpaceH(22),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 1,
                              color: Color(0xFFDDDDDD),
                            ),
                            whiteSpaceH(24),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  whiteSpaceH(8),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("DL 결제",
                                          style: Body1.apply(
                                              fontWeightDelta: 1
                                          )
                                      ),
                                      whiteSpaceW(10),
                                      Text("${demicalFormat.format(pointMap['DL'])} DL 보유",
                                          style: Body2.apply(
                                              fontWeightDelta: 1,
                                              color: primary
                                          )
                                      ),
                                      whiteSpaceW(5),
                                      Text(
                                          store.store.limitDL == null ?
                                          "* 결제한도가 없는 매장 입니다."
                                              :
                                          "* 해당매장의 결제한도는 ${(store.store.limitType == "PERCENTAGE") ? "${store.store.limitDL}%" : "${numberFormat.format(int.parse(store.store.limitDL))}"} DL 입니다.",
                                          style: TabsTagsStyle.apply(
                                              color: primary,
                                              fontWeightDelta: 1
                                          )
                                      ),
                                    ],
                                  ),
                                  whiteSpaceH(16),
                                  Consumer<StoreServiceProvider>(
                                    builder: (context, ssp, _){
                                      return
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                    flex: 4,
                                                    child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 3,
                                                            child:
                                                            Row(
                                                                children: [
                                                                  Text(
                                                                      "DL 결제 수량",
                                                                      style: Body1.apply(
                                                                          color: black,
                                                                          fontWeightDelta: 1
                                                                      )
                                                                  ),
                                                                  whiteSpaceW(12.0),
                                                                  RaisedButton(
                                                                    color: ssp.dlCtrl.text == "" || ssp.dlCtrl.text == "0" ? white : primary,
                                                                    onPressed: () {
                                                                      showDLDialog();
                                                                    },
                                                                    child: Text(
                                                                        "${ssp.dlCtrl.text == "" || ssp.dlCtrl.text == "0" ? "DL 사용" : "${numberFormat.format(int.parse(ssp.dlCtrl.text))}DL"}",
                                                                        style: Body1.apply(
                                                                          color : ssp.dlCtrl.text == "" || ssp.dlCtrl.text == "0" ? secondary : white,
                                                                        )
                                                                    ),
                                                                    elevation: 0.0,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(2),
                                                                        side: BorderSide(
                                                                            color: ssp.dlCtrl.text == "" || ssp.dlCtrl.text == "0" ? Color(0xFFDDDDDD) : primary
                                                                        )
                                                                    ),
                                                                  )
                                                                ]
                                                            ),
                                                          ),
                                                          Expanded(
                                                              flex: 2,
                                                              child:
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      "- ${numberFormat.format(int.parse(ssp.dlCtrl.text == "" ? "0" : ssp.dlCtrl.text) * 100)}원",
                                                                      style: Body1.apply(
                                                                          color: secondary,
                                                                          fontWeightDelta: 1
                                                                      ),
                                                                      textAlign: TextAlign.end,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                          ),
                                                        ]
                                                    )
                                                ),
                                              ]
                                          ),
                                        );
                                    },
                                  ),
                                  whiteSpaceH(24),
                                  Consumer<StoreServiceProvider>(
                                      builder: (context, ss, _){
                                        return Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                    "최종 결제 금액",
                                                    style: Body1.apply(
                                                        color: black,
                                                        fontWeightDelta: 1
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  )
                                              ),
                                              Expanded(
                                                  child: Text(
                                                    "${numberFormat.format(ss.orderPay - (int.parse(ss.dlCtrl.text == "" ? "0" : ss.dlCtrl.text) * 100))}원",
                                                    style: Subtitle2.apply(
                                                        color: primary,
                                                        fontWeightDelta: 1
                                                    ),
                                                    textAlign: TextAlign.end,
                                                  )
                                              )
                                            ]
                                        );
                                      }
                                  ),
                                ]
                            ),
                            whiteSpaceH(24),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 8,
                        color: Color(0xFFF2F2F2),
                      ),
                      whiteSpaceH(24),
                      // 결제 방식 위젯
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Consumer<StoreServiceProvider>(
                              builder: (context, ssp, _) {
                                return Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                            (ssp.orderPay > (int.parse(ssp.dlCtrl.text == "" ? "0" : ssp.dlCtrl.text) * 100)) ? "결제 방식"
                                                :
                                            "DL 결제가 진행됩니다.\n"
                                                "DL 결제는 실시간 흥정 혜택이 없습니다.",
                                            style: (ssp.orderPay > (int.parse(ssp.dlCtrl.text == "" ? "0" : ssp.dlCtrl.text) * 100)) ?
                                            Subtitle2.apply(
                                                fontWeightDelta: 1
                                            )
                                                :
                                            Subtitle2.apply(
                                                color: primary
                                            ),
                                            textAlign: (ssp.orderPay > (int.parse(ssp.dlCtrl.text == "" ? "0" : ssp.dlCtrl.text) * 100)) ? TextAlign.start : TextAlign.center,
                                          )
                                      ),
                                    ]
                                );
                              },
                            ),
                            whiteSpaceH(22),
                            Consumer<StoreServiceProvider>(
                              builder: (context, ssp, _){
                                return (ssp.orderPay > (int.parse(ssp.dlCtrl.text == "" ? "0" : ssp.dlCtrl.text) * 100)) ?
                                Row(
                                  children: [
                                    Expanded(
                                      child: method("신용카드", 0),
                                    ),
                                    Expanded(
                                      child: method("무통장입금", 1),
                                    ),
                                  ],
                                )
                                    :
                                Container();
                              },
                            ),
                            whiteSpaceH(25),
                            currentMethod == 1 ?
                            Column(
                              children: [
                                whiteSpaceH(15),
                                DropdownButton(
                                  isExpanded: true,
                                  icon: Icon(Icons.arrow_drop_down, color: primary,),
                                  iconSize: 24,
                                  elevation: 16,
                                  underline: Container(
                                    height: 2,
                                    color: Color(0xFFDDDDDD),
                                  ),
                                  value: "${store.bank.bank} / "
                                      + "${store.store.name} / "
                                      + "${store.bank.number}" ,
                                  items: ["${store.bank.bank} / "
                                      + "${store.store.name} / "
                                      + "${store.bank.number}"].map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }
                                  ).toList(),
                                  onChanged: (value){
                                  },
                                ),
                                whiteSpaceH(12)
                              ],
                            ) : Container(),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isAgreeCheck = !isAgreeCheck;
                                });
                              },
                              child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xFFDDDDDD),
                                                  width: 1
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2.0)
                                              )
                                          ),
                                          child: Theme(
                                            data: ThemeData(unselectedWidgetColor: Colors.transparent,),
                                            child: Checkbox(
                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              activeColor: primary,
                                              checkColor: primary,
                                              value: isAgreeCheck,
                                              onChanged: (value){
                                                setState(() {
                                                  isAgreeCheck = value;
                                                });
                                              },
                                            ),
                                          )
                                      ),
                                      whiteSpaceW(12),
                                      Text("개인정보 제 3자 제공 및 위탁동의",style: Body2,)
                                    ],
                                  )
                              ),
                            ),
                            whiteSpaceH(53),
                          ],
                        ),
                      ),
                      Consumer<StoreServiceProvider>(
                          builder: (context, ss, _){
                            return Container(
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                child:
                                RaisedButton(
                                  padding: EdgeInsets.symmetric(vertical: 11),
                                  color: primary,
                                  elevation: 0.0,
                                  onPressed: (!ss.orderLoading) ? () async {
                                    if(isAgreeCheck){

                                      if((int.parse(ss.dlCtrl.text == "" ? "0" : ss.dlCtrl.text) * 100) == ss.orderPay){
                                        await ss.setOrderMap(widget.store_id, "ORDER");
                                        await ss.orderComplete();
                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ServiceList(
                                          isHome: true, afterGame: true,
                                        )), (route) => false);
                                      } else {
                                        showGameDialog();
                                      }
                                    } else {
                                      showToast("개인정보 이용동의를 해주셔야 합니다.");
                                    }
                                  }
                                  :
                                  null,
                                  child: Text(
                                      (!ss.orderLoading) ? "결제하기" : "주문 처리 중 입니다.",
                                      style: Subtitle2.apply(
                                          color: white,
                                          fontWeightDelta: 1
                                      )
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(6.0),
                                      )
                                  ),
                                )
                            );
                          }
                      ),
                    ],
                  ),
                )
            )
        ),
      ],
    );
  }

  showGameDialog() {
    Map<String, dynamic> pointMap =  Provider.of<UserProvider>(context, listen: false).pointMap;
    showDialog( 
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0)
              )
            ),
            title: Consumer<StoreServiceProvider>(
              builder: (context, ssp, _){
                return Text("결제안내",
                  style: Body1.apply(
                    color: black,
                    fontWeightDelta: 3,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
            content: Consumer<StoreServiceProvider>(
              builder: (context, ssp, _){
                return Container(
                    width: 240,
                    height: 230,
                    child: (!ssp.orderLoading) ?
                    Column(
                      children: [
                        Text("${widget.store.store.name}에서 ${numberFormat.format(ssp.orderPay)}원을\n"
                            "${numberFormat.format(ssp.orderPay - (int.parse(ssp.dlCtrl.text == "" ? "0":ssp.dlCtrl.text) * 100))}원과 ${numberFormat.format(int.parse(ssp.dlCtrl.text))}DL로 각 각 결제합니다.",
                          style: Body1,
                          textAlign: TextAlign.center,
                        ),
                        whiteSpaceH(22),
                        Text("실시간 흥정 게임으로 이동하시겠습니까?",
                            style: Body2
                        ),
                        whiteSpaceH(22),
                        Container(
                          width: 240,
                          height: 76,
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    child: Center(
                                      child: Text("취소",
                                          style: Body1.apply(
                                            color: secondary,
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
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    if(!ssp.orderLoading) {
                                      if(currentMethod == 1){ // 무통장입금 결제
                                        await ssp.setOrderMap(widget.store_id, "ORDER");
                                        ssp.orderComplete();

                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ServiceList(
                                          isHome : true, afterGame : true,
                                        )), (routes) => false);
                                      } else {  // 신용카드 결제
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) =>
                                                Buy(
                                                  name: widget.name,
                                                  pay: ssp.orderPay - (int.parse(ssp.dlCtrl.text == "" ? "0":ssp.dlCtrl.text) * 100),
                                                  id: widget.store_id,
                                                  paymentType: paymentType[currentMethod],
                                                  dl: (int.parse(ssp.dlCtrl.text == "" ? "0":ssp.dlCtrl.text)),
                                                  isPlayGame: false,
                                                )));
                                      }
                                    } else {
                                      showToast("주문이 처리되는 중 입니다.");
                                    }
                                  },
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    child: Center(
                                      child: Text("나중에",
                                          style: Body1.apply(
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
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    if(!ssp.orderLoading) {
                                      if(currentMethod == 1){ // 무통장입금 결제
                                        await ssp.setOrderMap(widget.store_id, "ORDER");
                                        ssp.orderComplete();

                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => BargainGame2(
                                            orderPayment: ssp.orderPay - (int.parse(ssp.dlCtrl.text == "" ? "0":ssp.dlCtrl.text) * 100),
                                            totalCarat: pointMap['CARAT'])), (route) => false);
                                      } else {  // 신용카드 결제
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) =>
                                                Buy(
                                                  name: widget.name,
                                                  pay: ssp.orderPay - (int.parse(ssp.dlCtrl.text == "" ? "0":ssp.dlCtrl.text) * 100),
                                                  id: widget.store_id,
                                                  paymentType: paymentType[currentMethod],
                                                  dl: (int.parse(ssp.dlCtrl.text == "" ? "0":ssp.dlCtrl.text)),
                                                  isPlayGame: true,
                                                )));
                                      }
                                    } else {
                                      showToast("주문이 처리되는 중 입니다.");
                                    }
                                  },
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    child: Center(
                                      child: Text("예",
                                          style: Body1.apply(
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
                              ),
                            ],
                          ),
                        )
                      ],
                    ) :
                    Center(
                        child: Material(
                          type: MaterialType.transparency,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 3 / 4,
                            height: MediaQuery.of(context).size.height * 2 / 4,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                      valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
                                  ),
                                  whiteSpaceH(20),
                                  Text(
                                      "주문이 처리되는 중 입니다.",
                                      style: Body1.apply(
                                          color: black
                                      )
                                  )
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0)
                                )
                            ),
                          ),
                        )
                    ),
                );
              }
            ),
      ),
    );
  }

  Widget orderList(List<BigMenuModel> bml){
    int bigIdx = 0;
    return Container(
        child:
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            bml.map((e) =>
                bigMenuItem(bigIdx++,e)
            ).toList()
        )
    );
  }

  Widget bigMenuItem(int bigIdx,BigMenuModel bmm) {
    int idx = 0;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [
          Container(
              child:Text(bmm.name,
                style: Body2.apply(
                  fontWeightDelta: 1
                ),
                textAlign: TextAlign.start,
              )
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              bmm.menuList.map((e) =>
                  menuItem(bigIdx,idx++,e)
              ).toList()
          ),
          whiteSpaceH(16)
        ]
    );
  }

  Widget menuItem(int bigIdx,int idx,MenuModel mm) {
    StoreServiceProvider ssp = Provider.of<StoreServiceProvider>(context, listen: false);
    return
      Container(
          height: 72,
          child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 4,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${mm.name}",
                                    style: Body1.apply(
                                      color: black,
                                    )
                                ),
                                Text(
                                    "${numberFormat.format(mm.price)}원",
                                    style: Body2.apply(
                                        fontWeightDelta: 1
                                    )
                                ),
                              ],
                            )
                          ),
                        ]
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFDDDDDD), width: 1)
                        )
                      ),
                      child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: 24,
                                height: 24,
                                child: RaisedButton(
                                    onPressed: () {
                                      ssp.decreaseCount(bigIdx,idx);
                                    },
                                    elevation: 0.0,
                                    color: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    child: Center(
                                        child: Text(
                                          "-",
                                          style: Body1,
                                          textAlign: TextAlign.center,
                                        )
                                    )
                                ),
                              ),
                            ),
                            whiteSpaceW(4),
                            Expanded(
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  color: Colors.transparent,
                                  child: Center(
                                      child: Text(
                                          "${mm.count}",
                                          style: Body1.apply(
                                            color: black
                                          )
                                      )
                                  ),
                                )
                            ),
                            whiteSpaceW(4),
                            Expanded(
                              child: Container(
                                width: 24,
                                height: 24,
                                child: RaisedButton(
                                    onPressed: () {
                                      ssp.increaseCount(bigIdx,idx);
                                    },
                                    elevation: 0.0,
                                    color: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    child: Center(
                                        child: Text(
                                          "+",
                                          style: Body1,
                                          textAlign: TextAlign.center,
                                        )
                                    )
                                ),
                              ),
                            ),
                          ]
                      ),
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                        color: Colors.white,
                        child: Text(
                            "${numberFormat.format(mm.price *
                                mm.count)}원",
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

  Widget accountDL() {
    final textstyle = Body1;
    Map<String, dynamic> pointMap =  Provider.of<UserProvider>(context, listen: false).pointMap;
    return
      Consumer<StoreServiceProvider>(
          builder: (context, ss, _){
            return Column(
              children: [
                Row(
                  children: [
                    Text(
                      "보유 DL",
                      style: textstyle,
                    ),
                    whiteSpaceW(49),
                    Text(
                      "${demicalFormat.format(pointMap['DL'])} DL",
                      style: textstyle,
                    )
                  ],
                ),
                whiteSpaceH(16),
                Row(
                  children: [
                    Text(
                      "차감 DL",
                      style: textstyle,
                    ),
                    whiteSpaceW(49),
                    Text(
                      "${demicalFormat.format(ss.orderPay / 100)} DL",
                      style: textstyle,
                    )
                  ],
                ),
              ],
            );
          }
      );
  }

  Widget method(String type, int idx) {
    return InkWell(
      onTap: () {
        setState(() {
          currentMethod = idx;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: idx == currentMethod
                    ? mainColor
                    : Color(0xff888888))),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.transparent,
                ),
                child:
                Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeColor: Colors.transparent,
                  checkColor: primary,
                  value: idx == currentMethod,
                  onChanged: (value) {},
                ),
              ),
              Text(
                type,
                style:
                  Body1.apply(
                    color: idx == currentMethod
                      ? black
                      : Color(0xff888888)
                  )
              ),
            ],
          )
        ),
      ),
    );
  }

  showDLDialog() {
    Map<String, dynamic> pointMap =  Provider.of<UserProvider>(context, listen: false).pointMap;
    StoreModel store = widget.store == null ? Provider.of<StoreProvider>(context, listen: false).selStore : widget.store;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Text("DL 사용",
              style: Body1.apply(
                fontWeightDelta: 3
              ),
              textAlign: TextAlign.center,
            ),
            content:
            Container(
              width: 240,
              height: 220,
              child: Column(
                children: [
                  Consumer<StoreServiceProvider>(
                    builder: (context, ssp, _){
                      return Text(
                        "총 주문 금액 ${numberFormat.format(ssp.orderPay)}원 중\n"
                            + "DL로 결제할 수량을 입력하세요.",
                        style: Body1,
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  Consumer<StoreServiceProvider>(
                    builder: (context, ssp, _) {
                      return Container(
                        margin: EdgeInsets.only(top: 25.0, bottom: 20.0),
                        width: 192,
                        height: 44,
                        child:
                        TextFormField(
                          cursorColor: Color(0xff000000),
                          controller: ssp.dlCtrl,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: Subtitle2.apply(
                            fontWeightDelta: -2
                          ),
                          decoration: InputDecoration(
                            suffixText: "개",
                            suffixStyle: Body1.apply(
                              color: secondary
                            ),
                            contentPadding: EdgeInsets.all(12.0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFDDDDDD)
                              )
                          ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: primary
                                )
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  whiteSpaceH(20),
                  Consumer<StoreServiceProvider>(
                    builder: (context, ssp, _) {
                      return Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                                child:Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xFFDDDDDD),
                                      width: 1
                                    )
                                  ),
                                  child: Center(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            ssp.clearDlCtrl();
                                            Navigator.pop(context);
                                          },
                                          child: Text("취소",
                                              style:Body1.apply(
                                                color: secondary,
                                                fontWeightDelta: 3
                                              )
                                          ),
                                        ),
                                      )
                                  ),
                                )
                            ),
                            whiteSpaceW(20.0),

                            ClipOval(
                                child:Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color:mainColor,
                                    shape: BoxShape.circle,
                                      border: Border.all(
                                          color: primary,
                                          width: 1
                                      )
                                  ),
                                  child: Center(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            if(store.store.limitDL != null){
                                              if(widget.store.store.limitType == "PERCENTAGE") {
                                                if((ssp.orderPay / 100) * (int.parse(store.store.limitDL) /100)
                                                    <
                                                    int.parse(ssp.dlCtrl.text)) {
                                                  showToast("해당 매장의 결제한도보다 많습니다.");
                                                  return;
                                                }
                                              } else {
                                                if(int.parse(widget.store.store.limitDL) < int.parse(ssp.dlCtrl.text)) {
                                                  showToast("해당 매장의 결제한도보다 많습니다.");
                                                  return;
                                                }
                                              }

                                            } else if(pointMap['DL'] < int.parse(ssp.dlCtrl.text)){
                                              showToast("보유 DL보다 많습니다.");
                                              return;
                                            } else if((int.parse(ssp.dlCtrl.text) * 100) > ssp.orderPay) {
                                              showToast("결제금액 보다 많습니다.");
                                              return;
                                            }

                                            Navigator.pop(context);
                                          },
                                          child: Text("확인",
                                              style:Body1.apply(
                                                  color: white,
                                                  fontWeightDelta: 3
                                              )
                                          ),
                                        ),
                                      )
                                  ),
                                )
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}
