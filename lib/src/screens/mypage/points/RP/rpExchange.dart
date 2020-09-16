import 'package:cashcook/src/model/account.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
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
  String id;
  AccountModel accountModel;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    point = args['point'];
    pointImg = args['pointImg'];
    id = args['id'];
    accountModel = args['account'];
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("RP 환전하기"),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: body(),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            top(),
            chargeCount(),
            whiteSpaceH(268),
            agreePolicy(),
            whiteSpaceH(24),
            sendBtn(),
          ],
        ),
      ),
    );
  }

  Widget top() {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("보유 ${point}",style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color: Color(0xff444444)),),
              whiteSpaceH(4),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Image.asset(
                      pointImg,
                      fit: BoxFit.contain,
                      width: 24,
                    ),
                  ),
                  Text("${demicalFormat.format(double.parse(accountModel.quantity))} ${point}")
                ],
              ),
            ],
          ),
          Container(
            width: 64,
            height: 64,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget chargeCount() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Align(
              child: Text(
                "환전수량",
                style: TextStyle(fontSize: 12, color: Color(0xff888888)),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          Row(
            children: [
              Image.asset(
                pointImg,
                fit: BoxFit.contain,
                width: 40,
              ),
              Flexible(
                child: TextFormField(
                  textDirection: TextDirection.rtl,
                  cursorColor: Color(0xff000000),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    suffixText: "${point}",
                    suffixStyle: TextStyle(fontSize: 16, color: Color(0xff444444)),
                    border: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(0xffdddddd), width: 2.0),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: mainColor, width: 2.0),
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
                "${ctrl.text.length < 4 ? "1000RP = 1DL" : "= ${(int.parse(ctrl.text) / 1000).toInt()} DL"}",
                style: TextStyle(fontSize: 12, color: Color(0xff888888)),
              ),
              alignment: Alignment.centerRight,
            ),
          )
        ],
      ),
    );
  }

  Widget agreePolicy(){
    return InkWell(
      onTap: (){
        setState(() {
          isAgreeCheck = !isAgreeCheck;
        });
      },
      child: Row(
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
    );
  }
  Widget sendBtn(){
    return Container(
      width: double.infinity,
      child: RaisedButton(
        child: Text("환전하기"),
        elevation: 0.0,
        textColor: Colors.white,
        color: mainColor,
        onPressed: () async {
          if(!isAgreeCheck) {
            showToast("개인정보이용 동의를 해주셔야 합니다.");
            return;
          }

          if(int.parse(ctrl.text) < 1000){
            showToast("1000RP 이상 환전 가능합니다.");
            return;
          }
          Map<String, String> data = {
            "quantity":ctrl.text.toString()
          };
          await Provider.of<UserProvider>(context, listen: false).exchangeRp(id, data);

          //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainMap()), (route) => false);
          Map<String, dynamic> args = {
            'account': accountModel,
            'id' : id,
            'point': "RP",
            "pointImg":"assets/icon/rp-coin.png"
          };
          Navigator.of(context).pop(); // pop으로 하면 리턴 값을 받을 수 있다.
        },
      ),
    );
  }

}
