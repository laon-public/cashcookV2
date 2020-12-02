import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BigMenuApply extends StatefulWidget {
  @override
  _BigMenuApply createState() => _BigMenuApply();
}

class _BigMenuApply extends State<BigMenuApply> {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text(
          "대메뉴 추가",
          style: appBarDefaultText
      ),
      centerTitle: true,
      elevation: 0.5,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Image.asset("assets/resource/public/close.png", width: 24, height: 24, color: black,),
      ),
    );
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 12, left: 16, right: 16),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("대메뉴 명",
                style: Body2
              ),
              whiteSpaceH(4),
              TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: black, width: 2.0),
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                padding: EdgeInsets.symmetric(vertical: 8),
                child: RaisedButton(
                  elevation: 0,
                  onPressed: () {},
                  color: primary,
                  child: Text("완료",
                    style: Subtitle2.apply(
                        color: white,
                        fontWeightDelta: 1
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(6)
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}