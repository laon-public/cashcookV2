import 'package:cashcook/src/model/account.dart';
import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/referrermanagement/referrermanagement.dart';
import 'package:cashcook/src/screens/storemanagement/storemanagement.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  bool isCheck = false;

  @override
  void initState() {
    super.initState();

    Provider.of<UserProvider>(context, listen: false).fetchMyInfo(context);
    Provider.of<UserProvider>(context,listen: false).fetchAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body(){
    UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);
    return SingleChildScrollView(
      child:Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Title(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Text("보유 포인트",style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,color: Color(0xff444444)),),
                  ),
                  Consumer<UserProvider>(
                    builder: (conetxt, user, _) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 15,),
                          R_Point(user.account),
                          SizedBox(width: 67,),
                          DL(user.account),
                          SizedBox(width: 67,),
                          hasPoint("AD_POINT", user.account)? ADP(user.account) : SizedBox(),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 24,),
                  Consumer<UserProvider>(
                    builder: (context, user, _){
                      return user.storeModel != null ? StoreCard(): SizedBox();
                    },
                  ),
                  RecoCard(),
                  SizedBox(height: 16,),
                  Tabs(name: "공지사항", routesName: "/notice",),
//                  Alarm(),
                  CustomerCenter(),
                  Tabs(name: "FAQ", routesName: "/faq",),
                  Tabs(name: "서비스 문의", routesName: "/inquiry",),
                  Tabs(name: "약관 및 정책", routesName: "",),
                  Tabs(name: "앱정보", routesName: "/appinfomation",),
                  SizedBox(height: 40,),
                ],
              ),
            ),
            userProvider.storeModel == null ? Tabs2(name: "제휴매장 등록하기", routesName: "/store/apply1",img: "assets/icon/shop.png",): SizedBox(),
            SizedBox(height: 12,),
            Tabs2(name: "캐시링크 가기", routesName: "cashlink",img: "assets/icon/cashlink-icon.png",),
          ],
        ),
    );
  }

  Widget Title(){
    UserCheck userCheck = Provider.of<UserProvider>(context,listen: false).loginUser;
    return InkWell(
      onTap: (){

      },
      child: Container(
        margin: const EdgeInsets.only(top: 16.0, bottom: 24.0),
        child: InkWell(
          onTap: () async{
            await Navigator.pushNamed(context, "/userState");
          },
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize:16, fontWeight: FontWeight.w600, color: Colors.black),
                  children: [
                    TextSpan(text:"${userCheck.name}", style: TextStyle(fontSize: 20, color: Color(0xff444444))),
                    TextSpan(text:"님\n"),
                    TextSpan(text:"반갑습니다.")
                  ]
                ),

              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios, size: 24,color: Colors.black,),

            ],
          ),
        )
      ),
    );
  }

  bool hasPoint(String type, List<AccountModel> list){
    bool rtnBool = false;

    for(AccountModel account in list) {
      if(account.type == type) {
        rtnBool = true;
        break;
      }
    }

    return rtnBool;
  }

  //보유 R point
  Widget R_Point(List<AccountModel> list){
    String quantity = "0";
    String id = "";
    AccountModel accountModel;
    print("들어옴");
    for(AccountModel account in list) {
      print("for들어옴");
      if (account.type == "R_POINT"){
        print("if들어옴");
//        quantity = account.quantity.split(".").first;
        quantity = account.quantity;
        id = account.id;
        accountModel = account;
        break;
      }
    }
    return InkWell(
      onTap: (){
        Map<String, dynamic> args = {
          'account': accountModel,
          'id' : id,
          'point': "RP",
          "pointImg":"assets/icon/rp-coin.png"
        };
        Navigator.of(context).pushNamed("/point/history",arguments: args);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset("assets/icon/rp-coin.png",height: 48, fit: BoxFit.contain,),
          SizedBox(width: 8,height: 8,),
          Text("${demicalFormat.format(double.parse(quantity))} RP",style: TextStyle(fontSize: 12, color: Color(0xff444444)),)
        ],
      ),
    );
  }

  //보유 DL
  Widget DL(List<AccountModel> list){
    String quantity = "0";
    String id = "";
    AccountModel accountModel;
    print("들어옴2");
    for(AccountModel account in list) {
      print(account.type);
      if (account.type == "DILLING"){
        print("dl표시");
//        quantity = account.quantity.split(".").first;
        quantity = account.quantity;
        id = account.id;
        accountModel = account;
        break;
      }
    }
    return InkWell(
      onTap: (){
        Map<String, dynamic> args = {
          'account': accountModel,
          'id': id,
          'point': "DL",
          "pointImg":"assets/icon/DL 2.png"
        };
        Navigator.of(context).pushNamed("/point/history",arguments: args);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset("assets/icon/DL 2.png",height: 48, fit: BoxFit.contain,),
          SizedBox(width: 8,height: 8,),
          Text("${demicalFormat.format(double.parse(quantity))} DL",style: TextStyle(fontSize: 12, color: Color(0xff444444)),)
        ],
      ),
    );
  }

  //보유 ADP
  Widget ADP(List<AccountModel> list){
    String quantity = "0";
    String id = "";
    AccountModel accountModel;
    AccountModel dlAccountModel;
    for(AccountModel account in list) {
      if (account.type == "AD_POINT"){
//        quantity = account.quantity.split(".").first;
        quantity = account.quantity;
        id = account.id;
        accountModel = account;
        print("어디서 에러가 난거징");
        if(dlAccountModel != null) {
          break;
        }
      }
      if(account.type == "DILLING") {
        dlAccountModel = account;
        print("어디서 에러가 난거징");
        if(accountModel != null) {
          break;
        }
      }
    }
    return InkWell(
      onTap: (){
        Map<String, dynamic> args = {
          'account': accountModel,
          'dlAccount' : dlAccountModel,
          'id' : id,
          'point': "ADP",
          "pointImg":"assets/icon/adp.png"
        };
        Navigator.of(context).pushNamed("/point/history",arguments: args);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset("assets/icon/adp.png",height: 48, fit: BoxFit.contain,),
          SizedBox(width: 8,height: 8,),
          Text("${demicalFormat.format(double.parse(quantity))} ADP",style: TextStyle(fontSize: 12, color: Color(0xff444444)),)
        ],
      ),
    );
  }

//매장 관리
  Widget StoreCard(){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => StoreManagement()
        ));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffffff),
          border: Border.all(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:6, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
//              Image.asset("assets/icon/friends-wt.png", height: 32, fit: BoxFit.contain,),
              Image.asset("assets/icon/storeManage.png", height: 42, fit: BoxFit.contain,),
              SizedBox(width: 12,),
              Text("매장 관리",style: TextStyle(fontSize: 16,color: Color(0xff444444))),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.black, size: 24,),
            ],
          ),
        ),
      ),
    );
  }

  //추천인 관리
  Widget RecoCard(){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ReferrerManagement()
        ));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffffff),
          border: Border.all(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
//              Image.asset("assets/icon/friends-wt.png", height: 32, fit: BoxFit.contain,),
              Image.asset("assets/icon/recommend.png", height: 42, fit: BoxFit.contain,),
              SizedBox(width: 12,),
              Text("추천인 관리",style: TextStyle(fontSize: 16,color: Color(0xff444444))),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.black, size: 24,),
            ],
          ),
        ),
      ),
    );
  }

  //알림 뷰
  Widget Alarm(){
    return InkWell(
      onTap: (){
        setState(() {
          isCheck = !isCheck;
        });
      },
        child: Container(
          height: 48,
          child: Row(
            children: [
              Text("알림", style: TextStyle(fontSize: 14,color: Colors.black),),
              Spacer(),
              Switch(
                onChanged: (bool value){
                  setState(() {
                    isCheck = value;
                  });
                },
                value: isCheck,
                  activeColor: mainColor,
              ),
            ],
      ),
        ),
    );
  }

  //고객센터
  Widget CustomerCenter(){
    return InkWell(
      onTap: ()async {
        await launch("tel://15001500");
      },
          child: Container(
            height: 48,
            child: Row(
              children: [
                Text("고객센터",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600, color: Color(0xff444444)),),
                SizedBox(width: 12,),
                Text("1500-1500",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600, color: Color(0xff001166)),)
              ],
      ),
          ),
    );
  }
}

class Tabs extends StatelessWidget {
  final String routesName;
  final String name;

  Tabs({this.routesName, this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          Navigator.of(context).pushNamed(routesName);
        },
        enableFeedback:false,
          child: Container(
            height: 48,
            child: Row(
              children: [
                Text(name,style: TextStyle(fontSize: 14,color: Color(0xff444444)),),
                Spacer(),
                Icon(Icons.arrow_forward_ios, size: 24,color: Colors.black,)
              ],
        ),
          ),
    );
  }
}

class Tabs2 extends StatelessWidget {
  final String routesName;
  final String name;
  final String img;

  Tabs2({this.routesName, this.name, this.img});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xffeeeeee),
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
        child: InkWell(
          onTap: () async{
            if(routesName == "cashlink"){
              await launch("http://cashlink.kr");
            }else {
              Navigator.of(context).pushNamed(routesName);
            }

          },
          child: Row(
            children: [
              Text(name,style: TextStyle(fontSize: 14,color: Color(0xff444444)),),
              Spacer(),
              Image.asset(img,width: 48, fit: BoxFit.contain,),
            ],
          ),
        ),
    );
  }
}



