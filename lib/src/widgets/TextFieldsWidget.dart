import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';

Widget textFields(ctrl, TextInputType textType) {
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
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: deActivatedGrey, width: 1.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: black, width: 2.0),
            ),
          ),
        ),
      ],
    ),
  );
}