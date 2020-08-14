import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserState extends StatefulWidget{
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<UserState> {

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchMyInfo(context);
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("회원정보 수정"),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: body(),
      );
    }

  Widget body() {
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
                  Tabs(name: "계정정보 수정", routesName: "",),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Text("회원을 탈퇴하시겠습니까? >\n-회원을 탈퇴하시면, 보유하고 계신 포인트가 모두 사라집니다.",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,color: Color(0xff444444)),),
                ),
                ]
              )
            )
          ]
      )
    );
  }


  Widget Title(){
    print("title");
    UserCheck userCheck = Provider.of<UserProvider>(context,listen: false).loginUser;
        return Container(
          margin: const EdgeInsets.only(top: 16.0, bottom: 24.0),
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
                RaisedButton(
                  child: Text("로그아웃", style: TextStyle(fontSize: 12),),
                )
              ],
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

