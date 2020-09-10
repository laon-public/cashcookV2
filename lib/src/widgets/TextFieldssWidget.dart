import 'package:cashcook/src/utils/colors.dart';
import 'package:flutter/material.dart';

Widget textFieldss(ctrl, TextInputType textType) {
  return Container(
    width: double.infinity,
    child: Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(top:5.0),
        //   child: Align(child: Text(title,style: TextStyle(fontSize: 12, color: Color(0xff888888)),),alignment: Alignment.centerLeft,),
        // ),
        TextFormField(
          textAlign: TextAlign.center,
          cursorColor: Color(0xff000000),
          controller: ctrl,
          maxLength: 3, // 문자길이 제한
          keyboardType: textType,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            counterText:'', // 
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffdddddd), width: 2.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: mainColor, width: 2.0),
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top:5.0),
        //   child: Align(child: Text(msg,style: TextStyle(fontSize: 12, color: Color(0xff888888)),),alignment: Alignment.centerRight,),
        // ),
      ],
    ),
  );
}