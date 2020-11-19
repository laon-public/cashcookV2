import 'package:cashcook/src/provider/AuthProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("회원가입",
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'noto',
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333)
          )
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
        ),
      ),
      body: Container(
        color: white,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

        child: SingleChildScrollView(
          child: Consumer<AuthProvider>(
            builder: (context, auth, _){
              return Column(
                children: [
                  withBtnTextForm("아이디","대소문자, 숫자 5~20자 사이로 입력해주세요.", "중복확인", "username"),
                  normalTextForm("비밀번호","6~20자 사이로 입력해주세요.", "password"),
                  normalTextForm("비밀번호 확인", "비밀번호를 확인해주세요.", "password_confirm"),
                  normalTextForm("이름","이름을 입력하세요.", "name"),

                  Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text("성별",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'noto',
                                  color: Color(0xFF333333)
                              )
                          )
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: InkWell(
                                onTap: () {
                                  auth.changeFormValue("sex", "MAN");
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("남성",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'noto',
                                        color: auth.registerForm['sex'] == "MAN" ? white: Color(0xFF333333)
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  decoration: BoxDecoration(
                                      color: auth.registerForm['sex'] == "MAN" ? mainColor : white,
                                      border: Border.all(
                                          color: Color(0xFFCCCCCC),
                                          width: 1
                                      )
                                  ),
                                ),
                              )
                          ),
                          Expanded(
                              child: InkWell(
                                onTap: () {
                                  auth.changeFormValue("sex", "WOMAN");
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("여성",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'noto',
                                        color: auth.registerForm['sex'] == "WOMAN" ? white: Color(0xFF333333)
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  decoration: BoxDecoration(
                                      color: auth.registerForm['sex'] == "WOMAN" ? mainColor : white,
                                      border: Border.all(
                                          color: Color(0xFFCCCCCC),
                                          width: 1
                                      )
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    ],
                  ),
                  whiteSpaceH(16.0),

                  Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text("생일",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'noto',
                                  color: Color(0xFF333333)
                              )
                          )
                      ),
                      Container(
                        height: 35,
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          readOnly: true,
                          cursorColor: Color(0xff000000),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime(1980),
                                      firstDate: DateTime(1920),
                                      lastDate: DateTime(DateTime.now().year),
                                      helpText: "Select U'r BirthDay :)",
                                      cancelText: "취소",
                                      confirmText: "확인",
                                      builder: (context, child) {
                                        return Theme(
                                            data: ThemeData.dark(),
                                            child: child
                                        );
                                      }
                                  ).then((value) {
                                    auth.changeFormValue("year",value.year.toString());
                                    auth.changeFormValue("month",value.month.toString());
                                    auth.changeFormValue("day",value.day.toString());
                                  });
                                },
                                icon: Icon(Icons.calendar_today)
                            ),
                            hintText: "${auth.registerForm['year']}.${auth.registerForm['month']}.${auth.registerForm['day']}",
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
                      )
                    ],
                  ),
                  withBtnTextForm("전화번호","전화번호를 입력하세요.", "인증번호전송", "phone"),
                  withBtnTextForm("인증번호","인증번호를 입력하세요.", "확인", "csrf"),
                  whiteSpaceH(16.0),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: RaisedButton(
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          color: mainColor,
                          onPressed: () async {
                            await auth.authRegister();
                          },
                          child: Text("완료",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'noto',
                                  color: white
                              )
                          )
                      )
                  ),
                  whiteSpaceH(16.0),
                ],
              );
            }
          )
        )
      )
    );
  }

  Widget withBtnTextForm(
      String label,
      String hint,
      String btnText,
      String key) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Text(label,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'noto',
              color: Color(0xFF333333)
            )
          )
        ),
        Container(
          margin: EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: Container(
                    height: 35,
                    child: TextFormField(
                      onChanged: (value) {
                        Provider.of<AuthProvider>(context, listen: false).changeFormValue(key, value);
                      },
                      cursorColor: Color(0xff000000),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(
                            fontSize: 12,
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
                  )
              ),Container(
                  height: 40,
                  child: RaisedButton(
                    elevation: 0.0,
                    color: mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(0)
                      ),
                    ),
                    onPressed: () async {
                      if(key == "phone") {
                        await Provider.of<AuthProvider>(context, listen: false).requestSms();
                      }
                    },
                    child: Text(btnText,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'noto',
                          color: white,
                        )
                    ),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }

  Widget normalTextForm(
      String label,
      String hint,
      String key){
    return Column(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            child: Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'noto',
                    color: Color(0xFF333333)
                )
            )
        ),
        Container(
          height: 35,
          margin: EdgeInsets.only(bottom: 16.0),
          child: TextFormField(
            onChanged: (value) {
              Provider.of<AuthProvider>(context, listen: false).changeFormValue(key, value);
            },
            obscureText: key == "password" || key == "password_confirm" ? true : false,
            cursorColor: Color(0xff000000),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                  fontSize: 12,
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
        )
      ],
    );
  }
}