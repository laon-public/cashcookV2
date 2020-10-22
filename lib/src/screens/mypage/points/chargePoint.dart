import 'package:cashcook/src/model/account.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/buy/buy.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';

class ChargePoint extends StatefulWidget {
  @override
  _ChargePointState createState() => _ChargePointState();
}

class _ChargePointState extends State<ChargePoint> {
  String point;

  String pointImg;

  String id;

  bool _isButtonDisabled;

  int accountModel = 0;
  int dlAccountModel = 0;

  TextEditingController dlCtrl = new TextEditingController(text: "");

  int pay = 0;
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    point = args['point'];
    pointImg = args['pointImg'];
    id = args['id'];
    accountModel = args['account'];
    dlAccountModel = args['dlAccount'];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("포인트 충전",
          style: TextStyle(
            color: Color(0xFF444444),
            fontSize: 14,
            fontFamily: 'noto',
            fontWeight: FontWeight.w600
          )
        ),
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
            whiteSpaceH(49),
            PaymentMethod(
                id, pay , quantity, point, dlAccountModel, dlCtrl),
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
              Text(
                "보유 $point",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff444444)),
              ),
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
                  Text("${demicalFormat.format(accountModel)} $point")
                ],
              ),
            ],
          ),
          Container(
            width: 64,
            height: 64,
            color: Colors.white,
              child :Image.asset(
                "assets/icon/study_payment.png",
                fit: BoxFit.contain,
                width: 24,
              )
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
                "충전수량",
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
                    suffixText: "$point",
                    suffixStyle:
                        TextStyle(fontSize: 16, color: Color(0xff444444)),
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
                        pay = int.parse(value);
                        quantity = int.parse(value);
                        dlCtrl.text = (pay / 100).toInt().toString();
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
                "= $pay 원",
                style: TextStyle(fontSize: 12, color: Color(0xff888888)),
              ),
              alignment: Alignment.centerRight,
            ),
          )
        ],
      ),
    );
  }
}

class PaymentMethod extends StatefulWidget {
  final String id;
  final int pay;
  final int quantity;
  final String type;
  final int dlAccountModel;
  final TextEditingController dlCtrl;

  PaymentMethod(this.id, this.pay,this.quantity, this.type, this.dlAccountModel, this.dlCtrl);

  @override
  _PaymentMethodState createState() => _PaymentMethodState(dlCtrl,dlAccountModel);
}

class _PaymentMethodState extends State<PaymentMethod> {
  final TextEditingController dlCtrl;
  int dlAccount;

  int currentMethod = 0;
  bool isAgreeCheck = false;

  _PaymentMethodState(this.dlCtrl,this.dlAccount);

  Map<int, String> paymentType = {
    0: "CREDIT_CARD",
    1: "WITHOUT_BANK",
    2: "DILLING"
  };

  @override
  Widget build(BuildContext
  context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            "결제 방식",
            style: TextStyle(
                fontSize: 16,
                color: Color(0xff444444),
                fontWeight: FontWeight.w600),
          ),
        ),
        payment_method(),
        whiteSpaceH(20),
        methodView(dlCtrl,dlAccount),
        whiteSpaceH(20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("* 최소 충전금액은 500,000원 입니다.",
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 14,
                fontFamily: 'noto'
              ),
              textAlign: TextAlign.start,
            ),
            currentMethod == 2 ?
                Container() :
            Text("* 현금/카드 결제 시 20%ADP가 추가지급됩니다.",
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 14,
                fontFamily: 'noto'
              ),
              textAlign: TextAlign.start,
            )
            ],
        ),
        whiteSpaceH(60),
        agreePolicy(),
        whiteSpaceH(24),
        paymentBtn(),
      ],
    );
  }

  Widget methodView(TextEditingController dlCtrl,int dlAccount) {
    if (currentMethod == 0)
      return Container();
    else if (currentMethod == 1)
      return noPassBook();
    else if (currentMethod == 2) return accountDL(dlCtrl,dlAccount);
  }

  Widget payment_method() {
    return Row(
      children: [
        Expanded(
          child: method("신용카드", 0),
        ),
        Expanded(
          child: method("무통장입금", 1),
        ),
        Expanded(
          child: method("BZA 결제", 2),
        ),
      ],
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

  List<String> account = ['우리은행 / (주)트라이아트 / 00-000000-000'];
  String selectValue = "우리은행 / (주)트라이아트 / 00-000000-000";

  //무통장 입금
  Widget noPassBook() {
    return Container(
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
          style: TextStyle(color: black, fontSize: 16, fontFamily: 'noto'),
          items: account.map((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style:
                    TextStyle(color: black, fontSize: 16, fontFamily: 'noto'),
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
    );
  }

  //DL결제
  Widget accountDL(TextEditingController dlCtrl,int dlAccount) {
    final textstyle = TextStyle(fontSize: 14, color: Color(0xff444444));
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
              "${demicalFormat.format(dlAccount)} BZA",
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
              "-${dlCtrl.text} BZA",
              style: textstyle,
            )
          ],
        ),
      ],
    );
  }

  Widget agreePolicy() {
    return InkWell(
      onTap: () {
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
              onChanged: (value) {
                setState(() {
                  isAgreeCheck = value;
                });
              },
            ),
          ),
          whiteSpaceW(12),
          Text(
            "개인정보 제 3자 제공 및 위탁동의",
            style: TextStyle(fontSize: 12, color: Color(0xff888888)),
          )
        ],
      ),
    );
  }

  Widget paymentBtn() {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        child: Text("결제하기"),
        elevation: 0.0,
        textColor: Colors.white,
        color: mainColor,
        onPressed: isAgreeCheck == false? null : () async {
          if(!isAgreeCheck){
            showToast("개인정보이용 동의를 해주셔야 합니다.");
            return;
          }
          if (paymentType[currentMethod] == "CREDIT_CARD") {
            String name = Provider.of<UserProvider>(context, listen: false)
                .loginUser
                .name;
            buyMove(name, widget.pay, widget.id, widget.quantity,
                paymentType[currentMethod]);
          }
          else {
            if (widget.pay < 500000) {
              showToast("500000ADP 이상 충전 가능합니다.");
            } else if (paymentType[currentMethod] == "DILLING" && dlAccount < widget.pay / 100) {
              showToast("BZA가 부족합니다.");
            } else {
              bool response =
              await Provider.of<UserProvider>(context, listen: false)
                  .postCharge(
                  widget.id, widget.quantity, paymentType[currentMethod]);
              if (!response) {
                Fluttertoast.showToast(msg: "에러");
              } else {
                await Provider.of<UserProvider>(context, listen: false).getAccountsHistory('ADP', 0);
                Fluttertoast.showToast(msg: "충전이 완료되었습니다.");
              }
              Navigator.of(context).pop();
            }
          }
        },
      ),
    );
  }

  buyMove(name, pay, id, q, payType) {
    print("결제");
    if(q < 500000){
      showToast("500000ADP 이상 충전 가능합니다.`");
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              Buy(
                name: name,
                pay: pay,
                id: id,
                quantity: q,
                paymentType: payType,
              )));
    }
  }
}
