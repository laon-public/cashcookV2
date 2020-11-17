import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';

dialogPop(context) {
  Navigator.of(context, rootNavigator: true).pop();
}

dialog(
    {context,
    title,
    content,
    sub,
    selectOneText,
    selectTwoText,
    VoidCallback selectOneVoid,
    VoidCallback selectTwoVoid}) {
  return showDialog(
//      barrierColor: Color.fromRGBO(0, 0, 0, 0.5),
      context: (context),
      barrierDismissible: true,
      builder: (_) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(true);
          },
          child: Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: white,
            child: Container(
              padding: EdgeInsets.all(20.0),
              width: 240,
              height: 300,
              decoration: BoxDecoration(
                  color: white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  whiteSpaceH(3),
                  Text(
                    title,
                    style: TextStyle(
                        color: Color(0xFF333333),
                        fontFamily: 'noto',
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  whiteSpaceH(23),
                  Text(
                    content,
                    style: TextStyle(
                        fontSize: 12, fontFamily: 'noto', color: Color(0xFF333333),),
                    textAlign: TextAlign.center,
                  ),
                  whiteSpaceH(23),
                  Text(
                    sub,
                    style: TextStyle(
                      color: Color(0xFF888888),
                      fontFamily: 'noto',
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  whiteSpaceH(23),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        child: ClipOval(
                          child: RaisedButton(
                            color: Color(0xFF999999),
                            onPressed: () {
                              selectOneVoid();
                            },
                            elevation: 0.0,
                            padding: EdgeInsets.zero,
                            child: Center(
                              child: Text(
                                selectOneText,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'noto',
                                    color: white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      whiteSpaceW(24),
                      Container(
                        width: 64,
                        height: 64,
                        child: ClipOval(
                          child: RaisedButton(
                            color: mainColor,
                            onPressed: () {
                              selectTwoVoid();
                            },
                            elevation: 0.0,
                            padding: EdgeInsets.zero,
                            child: Center(
                              child: Text(
                                selectTwoText,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'noto',
                                    color: white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
