
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';

class StoreApplyLastStep extends StatefulWidget {
  @override
  _StoreApplyLastStepState createState() => _StoreApplyLastStepState();
}

class _StoreApplyLastStepState extends State<StoreApplyLastStep> {
  TextEditingController etcCtrl = TextEditingController();

  List<Map<String, int>> menu;

  String company_name;
  String license_number;
  String representative;
  String tel;
  String email;
  String bank;
  String account;
  String blUri;
  String shop1_uri;
  String shop2_uri;
  String shop3_uri;
  bool isDl = true;
  String category_code;
  String category_sub_code;

  String shop_name;
  String shop_description;
  String shop_tel;
  String negotiable_time;
  String address;
  String address_detail;
  String useDL;
  String latitude;
  String longitude;

  String menu_name;
  String menu_price;

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    company_name = args['company_name'];
    license_number = args['license_number'];
    representative = args['representative'];
    tel = args['tel'];
    email = args['email'];
    bank = args['bank'];
    account = args['account'];
    blUri = args['bl'];

    category_code = args['category_code'];
    category_code = args['category_sub_code'];

    shop_name = args['shop_name'];
    shop_description = args['shop_description'];
    shop_tel = args['shop_tel'];
    negotiable_time = args['negotiable_time'];
    address = args['address'];
    address_detail = args['address_detail'];
    useDL = args['useDL'];
    latitude = args['latitude'];
    longitude = args['longitude'];

    menu_name = args[menu]['menu_name'];
    menu_price = args[menu]['menu_price'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("매장 정보 3/3"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(top:false ,child: body(context)),
    );
  }

  Widget body(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
              Text("기타정보", style: TextStyle(color: Colors.black45),),
            whiteSpaceH(10),
              Container(
                child:
                TextFormField(
                  decoration: InputDecoration(border: OutlineInputBorder(),
                      hintText: "기타정보를 입력하여주세요. (원산지 표시 등)"),
                  maxLines: 10,
                  maxLength: 300,),
              ),
            whiteSpaceH(15),
            Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 40),
              child: nextBtn(context),
            )
          ],
        ),
      ),
    );
  }

  Widget nextBtn(context) {
    return Container(
      width: double.infinity,
      height: 40,
      child: RaisedButton(
        onPressed: () async {
          Map<String, String> data = {
            "company_name": company_name,
            "business_number": license_number,
            "owner": representative,
            "tel": tel,
            "email": email,
            "bank": bank,
            "account": account,
            "shop_name": shop_name,
            "shop_description": shop_description,
            "shop_tel": shop_tel,
            "negotiable_time": negotiable_time,
            "address": address,
            "address_detail": address_detail,
            "useDL": useDL,
            "latitude": latitude,
            "longitude": longitude,
            "category_code": category_code,
            "category_sub_code": category_sub_code,
            "etc_info": etcCtrl.text
          };
        },

        child: Text("완료"),
        textColor: Colors.white,
        color: mainColor,
      ),
    );
  }
}
