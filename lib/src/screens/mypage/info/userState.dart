import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

class UserState extends StatefulWidget{
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<UserState> {

  @override
  void initState() {
    super.initState();
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
          ),
          title: Text("회원정보 수정",
            style: appBarDefaultText
          ),
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
                  Tabs(name: "계정정보 수정", routesName: "/myUpdate",),
                  Tabs(name: "회원 탈퇴", routesName: "/withdraw",),

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
                      style: Subtitle2,
                      children: [
                        TextSpan(text:"${userCheck.name}", style: Subtitle1),
                        TextSpan(text:"님\n"),
                        TextSpan(text:"반갑습니다.")
                      ]
                  ),
                ),
                Spacer(),
                RaisedButton(
                  color: primary,
                  elevation: 0.0,
                  child: Text("로그아웃",
                    style: Body2.apply(
                      color: white
                    )
                  ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(6.0)
                      )
                    ),
                    onPressed:(){
                      Navigator.of(context).pushNamedAndRemoveUntil("/logout", (route) => false);
                    }
                ),
//                Tabs(name: "로그아웃", routesName: "/users/logout",),
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
            Text(name,style: Body1,),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16,color: black,)
          ],
        ),
      ),
    );
  }
}

