import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class limitDL extends StatefulWidget {
  @override
  _limitDLState createState() => _limitDLState();
}

class _limitDLState extends State<limitDL> {
  AppBar appBarWidget = AppBar(
    centerTitle: true,
    title: Text("BZA 결제 한도 설정",
        style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 14,
            fontFamily: 'noto',
            fontWeight: FontWeight.w600
        )
    ),
  );

  bool limitState;
  TextEditingController limitQuantityCtrl = TextEditingController();
  StoreModel myStore;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      myStore = Provider.of<UserProvider>(context, listen: false).storeModel;
      if(myStore.store.limitDL == null) {
        limitState = false;
        limitQuantityCtrl.text = "";
      } else {
        limitState = true;
        limitQuantityCtrl.text = myStore.store.limitDL;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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
                  Text("BZA 결제 한도 설정",
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontFamily: 'noto',
                    ),
                  ),
                  Spacer(),
                  Switch(
                    activeColor: mainColor,
                    value: limitState,
                    onChanged: (val) {
                      setState(() {
                        limitState = val;
                      });
                    },
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 47.0),
                width: MediaQuery.of(context).size.width,
                height: 66,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("최대 결제 BZA",
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 12,
                        fontFamily: 'noto'
                      )
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Image.asset(
                          "assets/icon/bza.png",
                          width: 40,
                          height: 40,
                        ),
                        Flexible(
                          child: TextFormField(
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color:Color(0xFF333333),
                              fontFamily: 'noto',
                              fontSize: 16,
                            ),
                            cursorColor: Color(0xff000000),
                            controller: limitQuantityCtrl,
                            keyboardType: TextInputType.number,
                            readOnly: !limitState,
                            decoration: InputDecoration(
                              suffixText: "BZA",
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: mainColor, width: 1.0),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child:RaisedButton(
                      color: mainColor,
                      onPressed: () async {
                        if(limitState && limitQuantityCtrl.text == "") {
                          showToast("결제한도를 입력해주세요.");

                          return;
                        }
                        print(limitState);
                        await Provider.of<UserProvider>(context, listen: false).changeLimitDL(
                            limitState,
                            myStore.id.toString(),
                            limitQuantityCtrl.text
                        );

                        await Provider.of<UserProvider>(context, listen: false).fetchMyInfo(context);
                        await Provider.of<StoreProvider>(context, listen: false).clearMap();
                      },
                      child: Text("완료",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'noto',
                            color: white,
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