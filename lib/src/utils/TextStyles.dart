import 'package:flutter/material.dart';

final TextStyle appBarDefaultText = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w700,
  fontFamily: 'noto',
  color: Color(0xFF333333)
);
// New Module
/*
  Usage
  색깔 변경은
  Headline.apply(color: Colors.red)
  와 같이 추가해서 쓰면 됩니다.

  FontWeight 변경은
  w600으로 고정되어 있는 것들은
  fontWeightDelta: -1 ( 무게 낮추기 )
  w500으로 고정되어 있는 것들은
  fontWeightDelta: 1 ( 무게 올리기 )
 */
TextStyle Headline = const TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w500,
  fontFamily: 'noto',
  color: Color(0xFF333333)
);
TextStyle Subtitle1 = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    fontFamily: 'noto',
    color: Color(0xFF333333)
);
TextStyle Subtitle2 = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'noto',
    color: Color(0xFF333333)
);
TextStyle Body1 = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'noto',
    color: Color(0xFF444444)
);
TextStyle Body2 = const TextStyle(
  fontSize: 12,
  fontFamily: 'noto',
  fontWeight: FontWeight.w400,
  color : Color(0xFF999999)
);
TextStyle Caption = const TextStyle(
    fontSize: 11,
    fontFamily: 'noto',
    fontWeight: FontWeight.w400,
    color: Color(0xFF999999)
);
TextStyle TabsTagsStyle = const TextStyle(
    fontSize: 10,
    fontFamily: 'noto',
    fontWeight: FontWeight.w400,
    color: Color(0xFF999999)
);