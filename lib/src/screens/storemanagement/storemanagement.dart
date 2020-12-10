import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/account.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/screens/dl/dlsell.dart';
import 'package:cashcook/src/screens/qr/qrcreate.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/dialog.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreManagement extends StatefulWidget {
  @override
  _StoreManagement createState() => _StoreManagement();
}

class _StoreManagement extends State<StoreManagement> {
  bool dlPay = false;

  qrCreate(type) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => QrCreate()
    ));
  }

  int getADP(){
    UserProvider userProvider = Provider.of<UserProvider>(context,listen:false);
    int adpoint = 0;
    for(AccountModel accountModel in userProvider.account){
      if(accountModel.type == "AD_POINT"){
        adpoint = int.parse(accountModel.quantity.split(".").first);
        break;
      }
    }
    return adpoint;
  }

  @override
  void initState() {
    super.initState();
    UserProvider userProvider = Provider.of<UserProvider>(context,listen:false);
    dlPay = userProvider.storeModel.store.useDL;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context,listen:false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset(
            "assets/resource/public/prev.png",
            width: 24,
            height: 24,
          ),
        ),
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "나의 매장관리",
          style: appBarDefaultText,
        ),
      ),
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  Navigator.of(context).pushNamed("/store/modify/routes");
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 104,
                  color: white,
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("${userProvider.storeModel.store.name}",
                                style: Headline,
                              ),
                              whiteSpaceW(8),
                              Image.asset(
                                "assets/resource/public/small-arrow-right.png",
                                width: 24,
                                height: 24,
                              )
                            ],
                          ),
                          whiteSpaceH(4),
                          Text(
                            "${userProvider.storeModel.store.tel}",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'noto',
                                color: Color(0xFF888888),
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: userProvider.storeModel.store.shop_img1,
                              fit: BoxFit.fill,
                              width: 64,
                              height: 64,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  whiteSpaceW(16),
                  Image.asset(
                    "assets/resource/public/adp_icon.png",
                    width: 24,
                    height: 24,
                  ),
                  whiteSpaceW(12),
                  Text(
                    "${numberFormat.format(getADP())} ADP >",
                    style: TextStyle(
                        color: black, fontFamily: 'noto', fontSize: 12),
                  )
                ],
              ),
              whiteSpaceH(24),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 129,
                  decoration: BoxDecoration(
                      color: white,
                      border: Border.all(color: Color(0xFFDDDDDD))),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 64,
                          child: RaisedButton(
                            onPressed: () {
                              dialog(
                                title: "QR생성 안내",
                                content: "고객의 결제방식을\n확인해주세요.",
                                sub: "",
                                context: context,
                                selectOneText: "일반결제",
                                selectTwoText: "DL결제",
                                selectOneVoid: () => qrCreate(0),
                                selectTwoVoid: () => qrCreate(1)
                              );
                            },
                            color: white,
                            padding: EdgeInsets.only(
                                top: 8, bottom: 8, left: 12, right: 12),
                            elevation: 0,
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/resource/map/qr.png",
                                  width: 48,
                                  height: 48,
                                ),
                                whiteSpaceW(12),
                                Text(
                                  "결제QR 생성",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: 16,
                                      fontFamily: 'noto'),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Image.asset(
                                  "assets/resource/public/small-arrow-right.png",
                                  width: 24,
                                  height: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: Color(0xFFDDDDDD),
                      ),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 64,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DlSell()
                              ));
                            },
                            color: white,
                            padding: EdgeInsets.only(
                                top: 8, bottom: 8, left: 12, right: 12),
                            elevation: 0,
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/resource/public/dl_icon.png",
                                  width: 48,
                                  height: 48,
                                ),
                                whiteSpaceW(12),
                                Text(
                                  "DL 판매",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: 16,
                                      fontFamily: 'noto'),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Image.asset(
                                  "assets/resource/public/small-arrow-right.png",
                                  width: 24,
                                  height: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              whiteSpaceH(30),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 48,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/store/modify/business");
                  },
                  elevation: 0,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  color: white,
                  child: Row(
                    children: [
                      Text(
                        "사업자 정보 수정",
                        style: TextStyle(
                            fontFamily: 'noto', fontSize: 16, color: black),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Image.asset(
                        "assets/resource/public/small-arrow-right.png",
                        width: 24,
                        height: 24,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 48,
                color: white,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: [
                    Text(
                      "DL결제 가능여부",
                      style: TextStyle(
                          fontFamily: 'noto', fontSize: 16, color: black),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Switch(
                      onChanged: (value) {
                        setState(() {
                          dlPay = value;
                        });
                      },
                      value: dlPay,
                      activeColor: mainColor,
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 48,
                color: white,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: [
                    Text(
                      "고객센터",
                      style: TextStyle(
                          fontFamily: 'noto', fontSize: 16, color: black),
                    ),
                    whiteSpaceW(16),
                    Text(
                      "1500-1500",
                      style: TextStyle(
                          fontFamily: 'noto',
                          fontSize: 16,
                          color: Color(0xFF001166),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              whiteSpaceH(60),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 88,
                child: RaisedButton(
                  onPressed: () {},
                  color: Color(0xFFEEEEEE),
                  padding: EdgeInsets.all(16),
                  elevation: 0.0,
                  child: Row(
                    children: [
                      Text(
                        "총판, 대리점 신청 및 조회",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: black,
                            fontSize: 20,
                            fontFamily: 'noto'),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        color: Color(0xFFC4C4C4),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
