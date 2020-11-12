import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/model/usercheck.dart';
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
    return Scaffold(
        appBar: AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text("주문서",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'noto',
                  color: Color(0xFF444444),
                  fontWeight: FontWeight.w600,
                )
            )
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  whiteSpaceH(8),
                  Text("주문내역",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'noto',
                          color: Colors.black,
                          fontWeight: FontWeight.w600
                      )),
                  whiteSpaceH(16),
                  Consumer<StoreServiceProvider>(
                      builder: (context, ss, _) {
                        return orderList(ss.orderList);
                      }
                  ),
                  whiteSpaceH(16),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1,
                    color: Color(0xFFDDDDDD),
                  ),
                  whiteSpaceH(8),
                  Consumer<StoreServiceProvider>(
                      builder: (context, ss, _){
                        return Row(
                            children: [
                              Expanded(
                                  child: Text(
                                    "총 주문 금액",
                                    style: TextStyle(
                                        fontFamily: 'noto',
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600
                                    ),
                                    textAlign: TextAlign.start,
                                  )
                              ),
                              Expanded(
                                  child: Text(
                                    "${numberFormat.format(ss.orderPay)}원",
                                    style: TextStyle(
                                        fontFamily: 'noto',
                                        fontSize: 18,
                                        color: mainColor,
                                        fontWeight: FontWeight.w600
                                    ),
                                    textAlign: TextAlign.end,
                                  )
                              )
                            ]
                        );
                      }
                  ),
                  whiteSpaceH(50),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        whiteSpaceH(8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("DL 결제",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'noto',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600
                                )),
                            whiteSpaceW(10),
                            Text("${demicalFormat.format(pointMap['DL'])} DL 보유",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'noto',
                                    color: mainColor,
                                    fontWeight: FontWeight.w600
                                )),
                            whiteSpaceW(5),
                            Text(
                                store.store.limitDL == null ?
                                "* 결제한도가 없는 매장 입니다."
                                    :
                                "* 해당매장의 결제한도는 ${store.store.limitDL}% DL 입니다.",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'noto',
                                    color: mainColor,
                                    fontWeight: FontWeight.w600
                                )),
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
                                                  child:Text(
                                                      "총 주문 금액",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: 'noto',
                                                          color: Color(0xFF444444)
                                                      )
                                                  ),
                                                ),
                                                Expanded(
                                                  child:Text(
                                                    "${numberFormat.format(ssp.orderPay)}원",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: 'noto',
                                                        color: Color(0xFF444444)
                                                    ),
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                              ]
                                          )
                                      ),
                                    ]
                                ),
                              );
                          },
                        ),
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
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontFamily: 'noto',
                                                                color: Color(0xFF444444)
                                                            )
                                                        ),
                                                        whiteSpaceW(5.0),
                                                        RaisedButton(
                                                          color: white,
                                                          onPressed: () {
                                                            showDLDialog();
                                                          },
                                                          child: Text(
                                                            "DL 사용",
                                                            style: TextStyle(
                                                              color: Color(0xFF444444),
                                                              fontSize: 12,
                                                              fontFamily: 'noto',
                                                            ),
                                                          ),
                                                          elevation: 0.0,
                                                          shape: Border.all(
                                                              color: Color(0xFFDDDDDD)
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
                                                            "${numberFormat.format(int.parse(ssp.dlCtrl.text))}DL",
                                                            style: TextStyle(
                                                                color: mainColor,
                                                                fontSize: 12,
                                                                fontFamily: 'noto',
                                                                fontWeight: FontWeight.w600
                                                            ),

                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            "-${numberFormat.format(int.parse(ssp.dlCtrl.text) * 100)}원",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontFamily: 'noto',
                                                                color: Color(0xFF444444)
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
                        whiteSpaceH(16),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: Color(0xFFDDDDDD),
                        ),
                        whiteSpaceH(8),
                        Consumer<StoreServiceProvider>(
                            builder: (context, ss, _){
                              return Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                          "남은 결제 금액",
                                          style: TextStyle(
                                              fontFamily: 'noto',
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600
                                          ),
                                          textAlign: TextAlign.start,
                                        )
                                    ),
                                    Expanded(
                                        child: Text(
                                          "${numberFormat.format(ss.orderPay - (int.parse(ss.dlCtrl.text) * 100))}원",
                                          style: TextStyle(
                                              fontFamily: 'noto',
                                              fontSize: 18,
                                              color: mainColor,
                                              fontWeight: FontWeight.w600
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
                  whiteSpaceH(50),
                  // 결제 방식 위젯
                  Consumer<StoreServiceProvider>(
                    builder: (context, ssp, _) {
                      return Row(
                          children: [
                            Expanded(
                                child: Text(
                                  (ssp.orderPay > (int.parse(ssp.dlCtrl.text) * 100)) ? "결제 방식"
                                      :
                                  "DL 결제가 진행됩니다.",
                                  style: TextStyle(
                                      fontFamily: 'noto',
                                      fontSize: (ssp.orderPay > (int.parse(ssp.dlCtrl.text) * 100)) ? 14 : 16,
                                      color: (ssp.orderPay > (int.parse(ssp.dlCtrl.text) * 100)) ? Colors.black : mainColor,
                                      fontWeight: FontWeight.w600
                                  ),
                                  textAlign: (ssp.orderPay > (int.parse(ssp.dlCtrl.text) * 100)) ? TextAlign.start : TextAlign.center,
                                )
                            ),
                          ]
                      );
                    },
                  ),
                  whiteSpaceH(20),
                  Consumer<StoreServiceProvider>(
                    builder: (context, ssp, _){
                      return (ssp.orderPay > (int.parse(ssp.dlCtrl.text) * 100)) ?
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
                  currentMethod == 1 ?
                  Column(
                    children: [
                      whiteSpaceH(15),
                      DropdownButton(
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: mainColor,),
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
                    ],
                  ) : Container(),
                  whiteSpaceH(75),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: Checkbox(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: mainColor,
                          value: isAgreeCheck,
                          onChanged: (value){
                            setState(() {
                              isAgreeCheck = value;
                            });
                          },
                        ),
                      ),
                      whiteSpaceW(12),
                      Text("개인정보 제 3자 제공 및 위탁동의",style: TextStyle(fontSize: 12, color: Color(0xff888888)),)
                    ],
                  ),
                  whiteSpaceH(10),
                  Consumer<StoreServiceProvider>(
                      builder: (context, ss, _){
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            child:
                            RaisedButton(
                                color: mainColor,
                                onPressed: () async {
                                  if(isAgreeCheck){
                                    print("ss.dlCtrl.text : ${ss.dlCtrl.text}");
                                    print("currentMethod : $currentMethod");
                                    print("orderPay : ${ss.orderPay}");
                                    print("store_id : ${widget.store_id}");

                                    if((int.parse(ss.dlCtrl.text == "" ? "0" : ss.dlCtrl.text) * 100) == ss.orderPay){
                                      ss.setOrderMap(widget.store_id, "ORDER");
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ServiceList(
                                        isHome: true, afterGame: true,
                                      )), (route) => false);
                                    } else {
                                      var orderPayment = ss.orderPay - (int.parse(ss.dlCtrl.text) * 100);

                                      if(currentMethod == 1){ // 무통장입금 결제
                                        ss.setOrderMap(widget.store_id, "ORDER");
                                        ss.orderComplete();
                                        showGameDialog(orderPayment);


                                      } else {  // 신용카드 결제
                                        await Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) =>
                                                Buy(
                                                    name: widget.name,
                                                    pay: ss.orderPay - (int.parse(ss.dlCtrl.text == "" ? "0":ss.dlCtrl.text) * 100),
                                                    id: widget.store_id,
                                                    paymentType: paymentType[currentMethod],
                                                    dl: (int.parse(ss.dlCtrl.text == "" ? "0":ss.dlCtrl.text))
                                                )));
                                        ss.orderComplete();
                                        showGameDialog(orderPayment);
                                      }
                                    }

                                  } else {
                                    showToast("개인정보 이용동의를 해주셔야 합니다.");
                                  }
                                },
                                child: Text(
                                    "결제하기",
                                    style: TextStyle(
                                        color: Colors.white
                                    )
                                )
                            )
                        );
                      }
                  ),
                ],
              ),
            )
        )
    );
  }

  showGameDialog(orderPayment) {
    showDialog( 
      context: context,
      builder: (context) => AlertDialog( content: Container(
          child: Text("실시간 흥정 게임을 진행하시겠습니까?",
            style: TextStyle(
                fontFamily: 'noto',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333)
            ),
            textAlign: TextAlign.center,
          )
      ),
        actions: <Widget>[
          FlatButton(
            child: Text("지금하기",
              style: TextStyle(
                  fontFamily: 'noto',
                  fontSize: 14,
                  color: mainColor
              ),
            ),
            onPressed: () async {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => BargainGame2(
              orderPayment: orderPayment,)), (route) => false);
            }),
          FlatButton(
            child: Text("나중에하기",
              style: TextStyle(
                  fontFamily: 'noto',
                  fontSize: 14,
                  color: subColor
              ),
            ),
            onPressed: () async {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ServiceList(
                isHome : true, afterGame : true,
              )), (routes) => false);
            }),
        ],
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
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child:Text(bmm.name,
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
              bmm.menuList.map((e) =>
                  menuItem(bigIdx,idx++,e)
              ).toList()
          )
        ]
    );
  }

  Widget menuItem(int bigIdx,int idx,MenuModel mm) {
    StoreServiceProvider ssp = Provider.of<StoreServiceProvider>(context, listen: false);
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
                                "${mm.name}",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'noto',
                                    color: Color(0xFF444444)
                                )
                            ),
                          ),
                          Expanded(
                            child:Text(
                                "${numberFormat.format(mm.price)}원",
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
                              child: RaisedButton(
                                  onPressed: () {
                                    ssp.decreaseCount(bigIdx,idx);
                                  },
                                  elevation: 0.0,
                                  color: Color(0xFFEEEEEE),
                                  padding: EdgeInsets.zero,
                                  shape:Border.all(
                                      color: Color(0xFFDDDDDD)
                                  ),
                                  child: Center(
                                      child: Text(
                                        "-",
                                        style: TextStyle(
                                            fontFamily: 'noto',
                                            color: Colors.black,
                                            fontSize: 14
                                        ),
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
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Color(0xFFDDDDDD)
                                    )
                                ),
                                child: Center(
                                    child: Text(
                                        "${mm.count}",
                                        style: TextStyle(
                                            fontFamily: 'noto',
                                            color: Colors.black,
                                            fontSize: 14
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
                                  color: Color(0xFFEEEEEE),
                                  padding: EdgeInsets.zero,
                                  shape:Border.all(
                                      color: Color(0xFFDDDDDD)
                                  ),
                                  child: Center(
                                      child: Text(
                                        "+",
                                        style: TextStyle(
                                            fontFamily: 'noto',
                                            color: Colors.black,
                                            fontSize: 14
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                  )
                              ),
                            ),
                          ),
                        ]
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

  Widget accountDL() {
    final textstyle = TextStyle(fontSize: 14, color: Color(0xff444444));
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
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: BoxDecoration(
            border: Border.all(
                color: idx == currentMethod
                    ? mainColor
                    : Color(0xff888888))),
        child: Center(
          child: Text(
            type,
            style: TextStyle(
                color: idx == currentMethod
                    ? mainColor
                    : Color(0xff888888)),
          ),
        ),
      ),
    );
  }

  showDLDialog() {
    Map<String, dynamic> pointMap =  Provider.of<UserProvider>(context, listen: false).pointMap;
    StoreModel store = widget.store == null ? Provider.of<StoreProvider>(context, listen: false).selStore : widget.store;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Text("DL 사용",
              style: TextStyle(
                color: Color(0xFF444444),
                fontSize: 14,
                fontFamily: 'noto',
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            content:
            Container(
              width: 240,
              height: 190,
              child: Column(
                children: [
                  Consumer<StoreServiceProvider>(
                    builder: (context, ssp, _){
                      return Text(
                        "${store.store.name} 주문 금액 ${numberFormat.format(ssp.orderPay)}원 중\n"
                            + "DL로 결제할 수량을 입력하세요.",
                        style: TextStyle(
                            color: Color(0xFF444444),
                            fontSize: 12,
                            fontFamily: 'noto'
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  Consumer<StoreServiceProvider>(
                    builder: (context, ssp, _) {
                      return Container(
                        margin: EdgeInsets.only(top: 25.0, bottom: 20.0),
                        width: 192,
                        height: 32,
                        child:
                        TextFormField(
                          cursorColor: Color(0xff000000),
                          controller: ssp.dlCtrl,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFF444444),
                              fontSize: 14,
                              fontFamily: 'noto'
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color(0xFFDDDDDD)
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: mainColor
                                )
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
                                    color:Color(0xFF888888),
                                    shape: BoxShape.circle,
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
                                              style:TextStyle(
                                                  color: Color(0xFFFFFFFF),
                                                  fontSize: 12,
                                                  fontFamily: 'noto'
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
                                  ),
                                  child: Center(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            if(store.store.limitDL != null &&
                                                (ssp.orderPay / 100) * (int.parse(store.store.limitDL) /100)
                                                    <
                                                    int.parse(ssp.dlCtrl.text)){
                                              showToast("해당 매장의 결제한도보다 많습니다.");
                                            } else if(pointMap['DL'] < int.parse(ssp.dlCtrl.text)){
                                              showToast("보유 DL보다 많습니다.");
                                            } else if((int.parse(ssp.dlCtrl.text) * 100) > ssp.orderPay) {
                                              showToast("결제금액 보다 많습니다.");
                                            } else {
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Text("확인",
                                              style:TextStyle(
                                                  color: Color(0xFFFFFFFF),
                                                  fontSize: 12,
                                                  fontFamily: 'noto'
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
