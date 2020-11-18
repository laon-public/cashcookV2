import 'package:cashcook/src/provider/AuthProvider.dart';
import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/center/appConfirm.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginVerRest extends StatefulWidget {
  @override
  _LoginVerRest createState() => _LoginVerRest();
}

class _LoginVerRest extends State<LoginVerRest> {
  TextEditingController usernameCtrl;
  TextEditingController passwordCtrl;
  bool isOpen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usernameCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if(!isOpen){
          await Provider.of<AuthProvider>(context, listen: false).authRequest();
        }
        setState(() {
          isOpen = true;
        });
    });

    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text("로그인 REST VER(TESTING)",
      //     style: TextStyle(
      //       fontSize: 14,
      //       fontFamily: 'noto',
      //       fontWeight: FontWeight.w600,
      //       color: Color(0xFF333333)
      //     )
      //   ),
      // ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [Center(
            child: Consumer<AuthProvider>(
              builder: (context, auth, _){
                return (auth.isLoading) ?
                CircularProgressIndicator(
                    backgroundColor: mainColor,
                    valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
                )
                    :
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icon/cashcook_logo.png",
                            width: 180,
                            height: 53.33,
                          ),
                          whiteSpaceH(40.0),
                          TextFormField(
                            cursorColor: Color(0xff000000),
                            controller: usernameCtrl,
                            decoration: InputDecoration(
                              hintText: "아이디를 입력하세요.",
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'noto',
                                  color: Color(0xFF999999)
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xffCCCCCC), width: 1.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: mainColor, width: 1.0),
                              ),
                            ),
                          ),
                          whiteSpaceH(8),
                          TextFormField(
                            cursorColor: Color(0xff000000),
                            obscureText: true,
                            controller: passwordCtrl,
                            decoration: InputDecoration(
                              hintText: "비밀번호를 입력하세요.",
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'noto',
                                  color: Color(0xFF999999)
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xffCCCCCC), width: 1.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: mainColor, width: 1.0),
                              ),
                            ),
                          ),
                          whiteSpaceH(24),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: 44,
                              child: RaisedButton(
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(6.0)
                                    )
                                ),
                                color: mainColor,
                                onPressed: () {
                                  if(usernameCtrl.text == "" || passwordCtrl.text == "") {
                                    showToast("계정정보를 모두 입력해주세요!");
                                  } else {
                                    Provider.of<AuthProvider>(context, listen: false).authIn(usernameCtrl.text, passwordCtrl.text);
                                  }
                                },
                                child: Text("로그인",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: white,
                                        fontFamily: 'noto'
                                    )
                                ),
                              )
                          ),
                          whiteSpaceH(8),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      height: 32,
                                      child: Center(
                                          child: InkWell(
                                            onTap: () {},
                                            child: Text("아이디 찾기",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'noto',
                                                    color: Color(0xFF333333)
                                                )
                                            ),
                                          )
                                      )
                                  )
                              ),
                              Container(
                                  width: 1,
                                  height: 10,
                                  color: Color(0xFFCCCCCC)
                              ),
                              Expanded(
                                  child: Container(
                                      height: 32,
                                      child: Center(
                                          child: InkWell(
                                            onTap: () {},
                                            child: Text("패스워드 찾기",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'noto',
                                                    color: Color(0xFF333333)
                                                )
                                            ),
                                          )
                                      )
                                  )
                              ),
                              Container(
                                  width: 1,
                                  height: 10,
                                  color: Color(0xFFCCCCCC)
                              ),
                              Expanded(
                                  child: Container(
                                      height: 32,
                                      child: Center(
                                          child: InkWell(
                                            onTap: () {},
                                            child: Text("회원가입",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'noto',
                                                    color: Color(0xFF333333)
                                                )
                                            ),
                                          )
                                      )
                                  )
                              )
                            ],
                          )
                        ],
                      ),
                    )
                );
              },
              ),
            ),
            Consumer<AuthProvider>(
              builder: (context, auth, _){
                return auth.isAuthing ?
                Positioned.fill(
                    child: Stack(
                        children : [
                          Opacity(
                            opacity: 0.7,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              color: black,
                            ),
                          ),
                          Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 3/4,
                                height: MediaQuery.of(context).size.height * 2/4,
                                decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    )
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(
                                          backgroundColor: mainColor,
                                          valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
                                      ),
                                    ),
                                    whiteSpaceH(20),
                                    Text("로그인이 진행 중 입니다.",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'noto',
                                            color: Color(0xFF333333)
                                        )
                                    )
                                  ],
                                ),
                              )
                          )
                        ]
                    )
                )
                    :
                (auth.isSuccess) ?
                    Consumer<AuthProvider>(
                      builder: (context, auth, _){
                        pageMove();

                        return Container();
                      },
                    )

                    :
                    Container();
              }
            )
          ]
        )
      ),
    );
  }

  pageMove() async {
    await Provider.of<StoreProvider>(context, listen: false).clearMap();
    await Provider.of<CenterProvider>(context, listen: false).startLoading();
    await Provider.of<UserProvider>(context,listen: false).fetchMyInfo(context);
    Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AppConfirm()), (route) => false);
  }
}