import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

class limitDL extends StatefulWidget {
  @override
  _limitDLState createState() => _limitDLState();
}

class _limitDLState extends State<limitDL> {

  bool limitState;
  TextEditingController limitQuantityCtrl = TextEditingController();
  int cashView;
  String limitType;
  StoreModel myStore;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myStore = Provider.of<UserProvider>(context, listen: false).storeModel;
      if(myStore.store.limitDL == null) {
        limitState = false;
        limitQuantityCtrl.text = "";
      } else {
        limitType = myStore.store.limitType.toLowerCase();
        limitState = true;
        limitQuantityCtrl.text = myStore.store.limitDL;
      }

      if(limitType != "percentage"){
        cashView = limitQuantityCtrl.text == "" ? 0 :
            int.parse(limitQuantityCtrl.text);
      }
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBarWidget = AppBar(
      centerTitle: true,
      elevation: 0.5,
      title: Text("DL 결제 한도 설정",
          style: appBarDefaultText
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
      ),
    );

    return Scaffold(
      backgroundColor: white,
      appBar: appBarWidget,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top:24, left: 16, right: 16, bottom: 16),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - appBarWidget.preferredSize.height - MediaQuery.of(context).padding.top,
          child: Column(
            children: [
              Row(
                children: [
                  Text("DL 결제 한도 설정",
                    style: Subtitle2,
                  ),
                  Spacer(),
                  Switch(
                    activeColor: primary,
                    value: limitState,
                    onChanged: (val) {
                      setState(() {
                        limitState = val;
                        limitQuantityCtrl.text = "";
                      });
                    },
                  )
                ],
              ),
              whiteSpaceH(8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("한도 종류",
                      style: Body2
                  ),
                  whiteSpaceH(8.0),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if(limitType != "percentage") {
                              setState(() {
                                limitType = "percentage";
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: limitType == "percentage" ?
                                    primary
                                    :
                                    third,
                                  width: 1,
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  width: limitType == "percentage" ? 20 : 0,
                                  height: limitType == "percentage" ? 16 : 0,
                                  child: Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.transparent,
                                    ),
                                    child:
                                    Checkbox(
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      activeColor: Colors.transparent,
                                      checkColor: primary,
                                      value: limitType == "percentage",
                                      onChanged: (value) {
                                        if(limitType != "percentage") {
                                          setState(() {
                                            limitType = "percentage";
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 300),
                                ),
                                Text("%",
                                    style: Body1.apply(
                                        color: black
                                    ),
                                    textAlign: TextAlign.center
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if(limitType != "cash") {
                              setState(() {
                                limitType = "cash";
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: limitType == "cash" ?
                                    primary
                                        :
                                    third,
                                  width: 1,
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  width: limitType == "cash" ? 20 : 0,
                                  height: limitType == "cash" ? 16 : 0,
                                  child: Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.transparent,
                                    ),
                                    child:
                                    Checkbox(
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      activeColor: Colors.transparent,
                                      checkColor: primary,
                                      value: limitType == "cash",
                                      onChanged: (value) {
                                        if(limitType != "cash") {
                                          setState(() {
                                            limitType = "cash";
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 300),
                                ),
                                Text("원",
                                    style: Body1.apply(
                                        color: black
                                    ),
                                    textAlign: TextAlign.center
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              whiteSpaceH(32),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("최대 결제 DL",
                      style: Body2
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Image.asset(
                          "assets/icon/DL 2.png",
                          width: 40,
                          height: 40,
                        ),
                        Flexible(
                          child: limitState == false?
                          TextFormField(enabled: false) :
                          TextFormField(
                            textAlign: TextAlign.end,
                            style: Subtitle2,
                            cursorColor: Color(0xff000000),
                            controller: limitQuantityCtrl,
                            keyboardType: TextInputType.number,
                            readOnly: !limitState,
                            onChanged: (value) {
                              setState(() {
                                cashView = int.parse(value) * 100;
                              });

                            },
                            decoration: InputDecoration(
                              suffixText: "DL ${limitType == "percentage" ? "%" : "개"}",
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primary, width: 1.0),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    (limitType == "percentage" ) ?
                    Container()
                    :
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "= ${numberFormat.format(limitQuantityCtrl.text == "" ? 0 : int.parse(limitQuantityCtrl.text) * 100)}원",
                        style: TabsTagsStyle,
                        textAlign: TextAlign.end,
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child:RaisedButton(
                      color: primary,
                      elevation: 0.0,
                      onPressed: () async {
                        print("limitState : $limitState");
                        print("limitQuantityCtrl.text : ${limitQuantityCtrl.text}");
                        if(limitState && limitQuantityCtrl.text == "") {
                          showToast("결제한도를 입력해주세요.");
                          return;
                        }

                        if(limitType == "percentage") {
                          if (limitState &&
                              (int.parse(limitQuantityCtrl.text) < 10 ||
                                  int.parse(limitQuantityCtrl.text) > 50)) {
                            showToast("결제한도는 10% ~ 50% 내로 설정 가능합니다.");
                            return;
                          }
                        }
                        // } else {
                        //   if(limitState && (int.parse(limitQuantityCtrl.text) < 10000 || int.parse(limitQuantityCtrl.text) > 100000)){
                        //     showToast("결제한도는 100DL ~ 100000원 내로 설정 가능합니다.");
                        //     return;
                        //   }
                        // }


                        await Provider.of<UserProvider>(context, listen: false).changeLimitDL(
                            limitState,
                            myStore.id.toString(),
                            limitQuantityCtrl.text,
                          limitType
                        );

                        await Provider.of<UserProvider>(context, listen: false).fetchMyInfo();
                        await Provider.of<StoreProvider>(context, listen: false).clearMap();

                        Navigator.of(context).pop();
                      },
                      child: Text("완료",
                          style: Body1.apply(
                            color: white
                          ))
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}