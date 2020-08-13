import 'package:cashcook/src/model/account.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';

class DLSend extends StatefulWidget {

  @override
  _DLSendState createState() => _DLSendState();
}

class _DLSendState extends State<DLSend> {

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
        title: Text("DL 전송하기"),
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
            whiteSpaceH(40),
            sendView(),
            whiteSpaceH(130),
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
                "전송수량",
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
                  controller: ctrl,
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
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Align(
              child: Text(
                "= ${ctrl.text} 원",
                style: TextStyle(fontSize: 12, color: Color(0xff888888)),
              ),
              alignment: Alignment.centerRight,
            ),
          )
        ],
      ),
    );
  }

  List<String> wallet = ['캐시링크', '니즈클리어', '바자로'];
  String selectValue = "캐시링크";

  Widget sendView(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("전송월렛", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
          whiteSpaceH(25),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.zero,
              child: DropdownButton<String>(
                underline: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  color: Color(0xFFDDDDDD),
                ),
                elevation: 0,
                isExpanded: true,
                style: TextStyle(
                    color: black, fontSize: 16, fontFamily: 'noto'),
                items: wallet.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                          color: black,
                          fontSize: 16,
                          fontFamily: 'noto'),
                    ),
                  );
                }).toList(),
                value: selectValue,
                onChanged: (value) {
                  setState(() {
                    selectValue = value;
                  });
                },
              ),
            ),
          ),
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
        child: Text("전송하기"),
        elevation: 0.0,
        textColor: Colors.white,
        color: mainColor,
        onPressed: () async {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainMap()), (route) => false);
        },
      ),
    );
  }

}
