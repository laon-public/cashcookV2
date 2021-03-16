import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';

Widget textField(title, msg, ctrl, TextInputType textType) {
  return Container(
    width: double.infinity,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top:5.0),
          child: Align(child: Text(title,style: Body2),alignment: Alignment.centerLeft,),
        ),
        TextFormField(
          cursorColor: Color(0xff000000),
          controller: ctrl,
          keyboardType: textType,
          style: Subtitle2.apply(
            fontWeightDelta: 1
          ),
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.symmetric(horizontal: 4),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: black, width: 2.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: deActivatedGrey, width: 1.0),
            ),
          ),
        ),
        whiteSpaceH(20)
      ],
    ),
  );
}