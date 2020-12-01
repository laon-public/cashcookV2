import 'dart:ui';

import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

class ReviewWrite extends StatefulWidget {
  final int store_id;
  final int order_id;

  ReviewWrite({this.store_id, this.order_id});

  @override
  _ReviewWrite createState() => _ReviewWrite();
}

class _ReviewWrite extends State<ReviewWrite> {
  int scope = 5;

  TextEditingController contentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text("리뷰 작성",
        style: appBarDefaultText,
      ),
      elevation: 0.5,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
      ),
    );

    return Scaffold(
      backgroundColor: white,
      appBar: appBar,
      body:
          SingleChildScrollView(
            child:
            Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      whiteSpaceH(12),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            starImage(1),
                            starImage(2),
                            starImage(3),
                            starImage(4),
                            starImage(5),
                          ]
                      ),
                      whiteSpaceH(4),
                      Text("매장을 평가해주세요.",
                          style: Body2
                      ),
                      whiteSpaceH(12.0),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: Color(0xFFDDDDDD),
                        margin: EdgeInsets.only(bottom: 15),
                      ),
                      TextFormField(
                        autofocus: false,
                        maxLines: 6,
                        controller: contentsController,
                        style: Subtitle2.apply(
                          fontWeightDelta: 1
                        ),
                        decoration: InputDecoration(
                          hintStyle: Subtitle2.apply(
                              color: third,
                              fontWeightDelta: -2
                          ),
                          hintText: '리뷰를 50자 내외로 작성해주세요.',
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent)
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent)
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          child:RaisedButton(
                            color: mainColor,
                            onPressed: () async {
                              print(contentsController.text);

                              if(contentsController.text == "") {
                                showToast("리뷰를 입력해주세요.");
                                return;
                              }

                              await Provider.of<StoreServiceProvider>(context, listen: false).insertReview(
                                widget.store_id,
                                scope,
                                contentsController.text,
                                widget.order_id,
                              ).then((value) async {
                                if(value != 0) {
                                  await Provider.of<UserProvider>(context, listen: false).updateServiceLogList(value, widget.order_id);

                                  showToast("리뷰를 등록했습니다.");
                                } else {
                                  showToast("리뷰 등록에 실패 했습니다.");
                                }
                              });

                              Navigator.of(context).pop();
                            },
                            elevation: 0.0,
                            child: Text("완료",
                                style: Subtitle2.apply(
                                    color: white,
                                    fontWeightDelta: 1
                                )
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(6)
                                )
                            ),
                          )
                      )
                    ]
                )
            ),
          )
    );
  }

  Widget starImage(idx) {
    return
      Container(
        margin: EdgeInsets.only(right: 4.0),
        child: InkWell(
            onTap: () {
              setState(() {
                scope = idx;
              });
            },
            child: (scope >= idx) ?
            Image.asset(
              "assets/icon/star_full_color.png",
              fit: BoxFit.fill,
              width: 24,
              height: 24,
            )
                :
            Image.asset(
              "assets/icon/star_color.png",
              fit: BoxFit.fill,
              width: 24,
              height: 24,
            )
        ),
      );
  }
}