import 'package:cashcook/src/screens/main/home.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';

import '../../provider/UserProvider.dart';
import '../../widgets/showToast.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'firstrecommendation.dart';
import 'package:cashcook/src/screens/mypage/store/store.dart';

class FirstBiz extends StatefulWidget {
  @override
  _FirstBiz createState() => _FirstBiz();
}



class _FirstBiz extends State<FirstBiz> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            "회원종류",
            style: appBarDefaultText,
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child:
          Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 40.0, bottom: 10.0),
                    child: Text(
                      "회원 종류를\n"
                          "선택해주세요.",
                      style: Subtitle1,
                      textAlign: TextAlign.start,
                    )
                ),
               whiteSpaceH(34),
               Container(
                 width: MediaQuery.of(context).size.width,
                    height: 88,
                    child:InkWell(
                      onTap: () async {
                        await Provider.of<UserProvider>(context,listen: false).recognitionSelect().then((value) async =>
                        {
                          if(value == 0){
                            showToast("추천자가 없습니다."),
                            await Provider.of<UserProvider>(context, listen: false).withoutReco(),

                            Navigator.of(context)
                                .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (route) => false),
                          } else {
                            Navigator.of(context)
                                .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => FirstRecommendation(type: "NORMAL")), (route) => false),
                          }
                        }
                        );
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/resource/character/signup-user.png",
                              width: 36,
                              height: 36,
                            ),
                            whiteSpaceW(12),
                            Text(
                              "일반회원 가입",
                              style: Subtitle2.apply(
                                color: black,
                                fontWeightDelta: 1
                              ),
                            ),
                            Spacer(),
                            Image.asset(
                                "assets/resource/public/small-arrow-right.png",
                                width: 16,
                                height: 16,
                              ),
                          ]
                      ),
                    )
                ),
                Container(
                  height: 88,
                  child:InkWell(
                    onTap: () async {
                      await Provider.of<UserProvider>(context,listen: false).recognitionSelect().then((value) async =>
                      {
                        if(value == 0){
                          showToast("추천자가 없습니다."),
                          // await Provider.of<UserProvider>(context, listen: false).withoutRecoDis(),

                          await Provider.of<UserProvider>(context, listen: false).withoutReco(),
                          // Navigator.of(context)
                          //     .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (route) => false),
                          Navigator.of(context)
                                .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => StoreApplyFirstStep()), (route) => false),
                        } else {
                          Navigator.of(context)
                              .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => FirstRecommendation(type:"AGENCY")), (route) => false),
                        }
                      }
                      );
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/resource/character/signup-store.png",
                            width: 36,
                            height: 36,
                          ),
                          whiteSpaceW(12),
                          Text(
                            "성공스토어 가입",
                            style: Subtitle2.apply(
                                color: black,
                                fontWeightDelta: 1
                            ),
                          ),
                          Spacer(),
                         Image.asset(
                              "assets/resource/public/small-arrow-right.png",
                              width: 16,
                              height: 16,
                            ),
                        ]
                    ),
                  ),
                ),
              ]
          ),
        )

    );
  }

  Widget whiteBox(text) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                text,
                style: Subtitle1,
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: 12.0),
                child: Image.asset(
                  "assets/resource/public/small-arrow-right.png",
                  width: 16,
                  height: 16,
                ),
              )
            ]
          ),
    );
  }
}