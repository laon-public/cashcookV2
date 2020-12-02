import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuPatch extends StatefulWidget {
  final MenuModel menu;

  MenuPatch({this.menu});

  @override
  _MenuPatch createState() => _MenuPatch();
}

class _MenuPatch extends State<MenuPatch> {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text(
          "${widget.menu.name} 수정",
          style: appBarDefaultText
      ),
      centerTitle: true,
      elevation: 0.5,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24, color: black,),
      ),
    );
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Container(
                      child: Image.asset(
                        "assets/icon/cashcook_logo.png",
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(6.0)
                          ),
                          border: Border.all(
                              color: Color(0xFFDDDDDD),
                              width: 0.5
                          )
                      ),
                    ),
                    whiteSpaceW(16.0),
                    Expanded(
                        child: TextFormField(
                          initialValue: widget.menu.name,
                          style: Body1.apply(
                              color: black,
                              fontWeightDelta: 1
                          ),
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent
                                )
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent
                                )
                            ),
                          ),
                        )
                    )
                  ],
                ),
              ),
              whiteSpaceH(20),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("메뉴 가격",
                        style: Body2
                    ),
                    whiteSpaceH(8),
                    Row(
                      children: [
                        Image.asset(
                          "assets/resource/public/krw-coin.png",
                          width: 36,
                          height: 36,
                          fit: BoxFit.fill,
                        ),
                        Expanded(
                          child: TextFormField(
                            initialValue: widget.menu.price.toString(),
                            textAlign: TextAlign.end,
                            style: Subtitle2.apply(
                                fontWeightDelta: -2
                            ),
                            decoration: InputDecoration(
                              suffixText: "원",
                              suffixStyle: Subtitle2.apply(
                                  fontWeightDelta: -2
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: black, width: 2.0),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
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
                  child: Text("수정하기",
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
      )
    );
  }
}