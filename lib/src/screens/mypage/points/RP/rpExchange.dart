import 'package:cashcook/src/model/account.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/screens/mypage/mypage.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RPExchange extends StatefulWidget {

  @override
  _RPExchangeState createState() => _RPExchangeState();
}

class _RPExchangeState extends State<RPExchange> {

  TextEditingController ctrl = TextEditingController();
  bool isAgreeCheck = false;
  String point;
  String pointImg;
  int quantity;

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text("CP 구매하기",
          style: appBarDefaultText
      ),
      centerTitle: true,
      elevation: 0.5,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
      ),
    );

    final args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    point = args['point'];
    pointImg = args['pointImg'];
    quantity = args['quantity'];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child:
          Column(
            children: [
              whiteSpaceH(20),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text("보유 CP",style: Subtitle1),
                        whiteSpaceH(8),
                        Row(
                          children: [
                            Image.asset(
                              pointImg,
                              fit: BoxFit.contain,
                              width: 24,
                            ),
                            whiteSpaceW(8),
                            Text("${demicalFormat.format(quantity)} CP",
                              style: Body2.apply(
                                color: black,
                                fontWeightDelta: 1
                              )
                            )
                          ],
                        ),
                    ]
                ),
              ),
              whiteSpaceH(40),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "구매수량",
                      style: Body2.apply(
                        color: third
                      )
                    ),
                    whiteSpaceH(4.0),
                    Row(
                      children: [
                        Image.asset(
                          "assets/icon/DL 2.png",
                          fit: BoxFit.contain,
                          width: 40,
                        ),
                        whiteSpaceW(4),
                        Flexible(
                          child: TextFormField(
                            textDirection: TextDirection.rtl,
                            cursorColor: Color(0xff000000),
                            style: Subtitle2.apply(
                                fontWeightDelta: -2
                            ),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              suffixText: " DL",
                              suffixStyle: Subtitle2.apply(
                                  fontWeightDelta: -2
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: black, width: 2.0),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                ctrl.text = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Align(
                        child: Text(
                          "${(ctrl.text == "") ? 0 : numberFormat.format(int.parse(ctrl.text) * 1000)} CP",
                          style: TextStyle(fontSize: 12, color: Color(0xff888888)),
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
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
              whiteSpaceH(8),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                padding: EdgeInsets.symmetric(vertical: 7),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6)
                    )
                  ),
                  child: Text("구매하기",
                    style: Subtitle2.apply(
                      color: white,
                      fontWeightDelta: 1
                    ),
                  ),
                  elevation: 0.0,
                  color: primary,
                  onPressed: () async {
                    if(!isAgreeCheck) {
                      showToast("개인정보이용 동의를 해주셔야 합니다.");
                      return;
                    }

                    if(ctrl.text == "" || ctrl.text == "0"){
                      showToast("수량을 입력해주세요.");
                      return;
                    }

                    Map<String, String> data = {
                      "quantity": (int.parse(ctrl.text) * 1000).toString()
                    };
                    await Provider.of<UserProvider>(context, listen: false).exchangeRp(data);

                    //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainMap()), (route) => false);
                    Map<String, dynamic> args = {
                      "quantity": quantity,
                      'point': "CP",
                      "pointImg":"assets/icon/c_point.png"
                    };

                    await Provider.of<UserProvider>(context, listen:false).getAccountsHistory("CP", 0);
                    await Provider.of<StoreProvider>(context, listen: false).clearMap();
                    await Provider.of<UserProvider>(context, listen: false).fetchAccounts();
                    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyPage(isHome: true), (route) => false);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=> MyPage(isHome: true,)),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      )
    );
  }

}
