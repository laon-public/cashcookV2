import 'dart:ui';

import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ReviewWrite extends StatefulWidget {
  final int store_id;

  ReviewWrite({this.store_id});

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
    print(widget.store_id);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      appBar: AppBar(
        title: Text("리뷰 작성하기"),
        elevation: 0.5,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        child:
          Column(
              children: [
                whiteSpaceH(15.0),
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
              whiteSpaceH(15.0),
              TextFormField(
                autofocus: false,
                maxLines: 6,
                controller: contentsController,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'noto',
                ),
                decoration: InputDecoration(
                  hintText: '리뷰를 적어주세요!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color:Colors.black
                    )
                  )
                ),
              ),
                Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 43,
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
                              contentsController.text);

                          Navigator.of(context).pop();

                          showToast("리뷰를 등록했습니다.");
                      },
                      child: Text("등록하기",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'noto',
                            color: white,
                          ))
                  )
                )
            ]
          )
      ),
    );
  }

  Widget starImage(idx) {
    return InkWell(
      onTap: () {
        setState(() {
          scope = idx;
        });
      },
      child: (scope >= idx) ?
      Image.asset(
        "assets/icon/star_full_color.png",
        fit: BoxFit.fill,
        width: 50,
        height: 50,
      )
          :
      Image.asset(
        "assets/icon/star_color.png",
        fit: BoxFit.fill,
        width: 50,
        height: 50,
      )
    );
  }
}