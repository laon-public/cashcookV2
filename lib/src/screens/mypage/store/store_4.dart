import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/mypage/store/storeApply.dart';
import 'package:cashcook/src/screens/referrermanagement/franBizSelect.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreApplyLastStep extends StatefulWidget {
  @override
  _StoreApplyLastStepState createState() => _StoreApplyLastStepState();
}

class _StoreApplyLastStepState extends State<StoreApplyLastStep> {
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("매장 정보 3/3", style:
        TextStyle(
            color: black,
            fontSize: 14,
            fontFamily: 'noto'
        )),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: SafeArea(top: false, child: body(context)),
    );
  }


  Widget body(context) {
    return
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(top: 50.0, bottom: 20.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("기타정보",
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                      fontFamily: 'noto',
                    )
                ),
                whiteSpaceH(10),
                TextFormField(
                  autofocus: false,
                  maxLines: 6,
                  controller: commentController,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'noto',
                  ),
                  decoration: InputDecoration(
                      hintText: '기타 정보를 입력하여주세요.(원산지 표시 등)',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:Colors.black
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:mainColor
                          )
                      )
                  ),
                ),
                Spacer(),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                  child:RaisedButton(
                    color: mainColor,
                    onPressed: () async {
                        await Provider.of<StoreProvider>(context, listen: false).bak_comment(commentController.text);

                        await Provider.of<StoreProvider>(context, listen: false).clearSuccess();

                        if(Provider.of<UserProvider>(context, listen: false).loginUser.userGrade == "NORMAL") {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => FranBizSelect()));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => StoreApplyState()
                          ));
                        }

                    },
                    child: Text("완료",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'noto',
                        color: white,
                      ))
                  )
                )

              ]
            )
          );
  }
}

