import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/buy/buy.dart';
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

  OrderMenu({this.name,this.store_id});
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
                  Text("BZA 결제",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'noto',
                          color: Colors.black,
                          fontWeight: FontWeight.w600
                      )),
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
                                            child:Text(
                                                "BZA 결제 수량",
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
                ]
              ),
              whiteSpaceH(50),
              // 결제 방식 위젯
              Row(
                  children: [
                    Expanded(
                        child: Text(
                          "결제 방식",
                          style: TextStyle(
                              fontFamily: 'noto',
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600
                          ),
                          textAlign: TextAlign.start,
                        )
                    ),
                  ]
              ),
              whiteSpaceH(20),
              Row(
                children: [
                  Expanded(
                    child: method("신용카드", 0),
                  ),
                  Expanded(
                    child: method("무통장입금", 1),
                  ),
                  Expanded(
                    child: method("BZA결제", 2),
                  ),
                ],
              ),
              whiteSpaceH(25),
              (currentMethod == 2) ?
                  Column(
                    children: [
                      accountDL(),
                      whiteSpaceH(50),
                    ]
                  )
                  :
                  whiteSpaceH(50),
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
                              if(currentMethod == 0){
                                await Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        Buy(
                                          name: widget.name,
                                          pay: ss.orderPay,
                                          id: widget.store_id,
                                          paymentType: paymentType[currentMethod],
                                        )));
                              } else if( currentMethod == 1){
                                await ss.orderMenu(int.parse(widget.store_id), ss.orderPay, paymentType[currentMethod]);
                              } else if( currentMethod == 2){
                                await ss.orderMenu(int.parse(widget.store_id), (ss.orderPay / 100).round(), paymentType[currentMethod]);
                              }

                              Navigator.of(context).pop();
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
                    "보유 BZA",
                    style: textstyle,
                  ),
                  whiteSpaceW(49),
                  Text(
                    "${demicalFormat.format(pointMap['DL'])} BZA",
                    style: textstyle,
                  )
                ],
              ),
              whiteSpaceH(16),
              Row(
                children: [
                  Text(
                    "차감 BZA",
                    style: textstyle,
                  ),
                  whiteSpaceW(49),
                  Text(
                    "${demicalFormat.format(ss.orderPay / 100)} BZA",
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
}