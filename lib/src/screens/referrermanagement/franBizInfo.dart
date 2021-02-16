import 'package:cashcook/src/provider/PointMgmtProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

class FranBizInfo extends StatefulWidget {
  @override
  _FranBizInfo createState() => _FranBizInfo();
}

class _FranBizInfo extends State<FranBizInfo> {
  String viewType = "day";
  int page;

  @override
  void initState() {
    page = 1;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<PointMgmtProvider>(context, listen: false).fetchFranMgmt(viewType, 1);
    });

    AppBar appBar;

    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: true,
      appBar: appBar = AppBar(
        backgroundColor: white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(
            "assets/resource/public/prev.png",
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "성공마스터 정보",
          style: appBarDefaultText,
        ),
        automaticallyImplyLeading: false,
      ),
      body:
    Consumer<PointMgmtProvider>(
      builder: (context, pm, _) {
        return pm.isLoading ?
        Center(
            child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
            )
        )
            :
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - appBar.preferredSize.height,
          child: Padding(
            padding: EdgeInsets.only(
                top: 10.0, left: 16, right: 16, bottom: 16),
            child:
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 30, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "나의 성공마스터 / 성공메이커 정보",
                          textAlign: TextAlign.start,
                          style: Subtitle2,
                        ),
                        whiteSpaceW(12),
                        Container(
                          child: Image.asset(
                            "assets/icon/left_payment.png",
                            width: 48,
                            height: 48,
                          ),
                        )
                      ],
                    ),
                  ),
                  whiteSpaceH(24),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0, bottom: 6),
                        child: Align(child: Text("성공마스터", style: Body2),
                          alignment: Alignment.centerLeft,),
                      ),
                      (Provider.of<UserProvider>(context, listen: false).loginUser.userGrade == "AGENCY") ?
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                                pm.ageMap['username'],
                                style: Subtitle2,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: third,
                                  width: 1
                                )
                              )
                            ),
                          )
                      :
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          pm.disMap['username'],
                          style: Subtitle2,
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: third,
                                    width: 1
                                )
                            )
                        ),
                      )
                    ],
                  ),
                  whiteSpaceH(4),
                  (Provider.of<UserProvider>(context, listen: false).loginUser.userGrade == "AGENCY") ?
                      Container()
                      :
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0, bottom: 6),
                        child: Align(child: Text("성공메이커", style: Body2),
                          alignment: Alignment.centerLeft,),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          pm.ageMap['username'],
                          style: Subtitle2,
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: third,
                                    width: 1
                                )
                            )
                        ),
                      ),
                    ],
                  ),
                ]
            ),
          ),
        );
      }
    ),
      );
  }

}