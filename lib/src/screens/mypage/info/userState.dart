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
            Title(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 8,
              color: Color(0xFFF2F2F2)
            ),
            Tabs(name: "계정정보 수정", routesName: "/myUpdate",),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 44,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: RaisedButton(
                color: Color(0xFFF2F2F2),
                child: Text("회원탈퇴",
                  style: Subtitle2.apply(
                    color: Color(0xFF555555),
                    fontWeightDelta: -2
                  )
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed("/withdraw",);
                },
                elevation: 0.0,
              ),
            )
          ]
      )
    );
  }


  Widget Title(){
    print("title");
    UserCheck userCheck = Provider.of<UserProvider>(context,listen: false).loginUser;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${userCheck.username}", style: Subtitle1.apply(
                        color: primary,
                        fontWeightDelta: 2
                    )),
                    Text("${userCheck.phone}", style: Subtitle2.apply(
                      color: black,
                      fontWeightDelta: -1
                    ),)
                  ],
                ),
                Spacer(),
                RaisedButton(
                  color: white,
                  elevation: 0.0,
                  child: Text("로그아웃",
                    style: Body2.apply(
                      color: Color(0xFF555555)
                    )
                  ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(3)
                      ),
                      side: BorderSide(
                        color: Color(0xFFCCCCCC),
                        width: 1
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
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
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

