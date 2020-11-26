import 'package:cashcook/src/provider/PointMgmtProvider.dart';
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

  TextEditingController distributorCtrl = TextEditingController(); //총판
  TextEditingController agencyCtrl = TextEditingController(); //대리점

  String viewType = "day";
  int page;

  @override
  void initState() {
    page = 1;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<PointMgmtProvider>(context, listen: false).fetchFranMgmt(viewType, page);
    });

    AppBar appBar;

    String distributorName = Provider.of<PointMgmtProvider>(context,listen: false).disMap['username'];
    String agencyName = Provider.of<PointMgmtProvider>(context,listen: false).ageMap['username'];

    print("distributorName : $distributorName");
    print("agencyName : $agencyName");

    distributorCtrl.text = distributorName;
    agencyCtrl.text = agencyName;

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
          "총판 정보",
          style: appBarDefaultText,
        ),
        automaticallyImplyLeading: false,
      ),
      body:
    Consumer<PointMgmtProvider>(
      builder: (context, pm, _) {
        print("disAgeMap");
        print(pm.disMap.length);
        print(pm.ageMap.length);
        return Container(
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
                          "나의 총판 / 대리점 정보",
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
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Align(child: Text("총판", style: Body2),
                          alignment: Alignment.centerLeft,),
                      ),
                      TextFormField(
                        controller: distributorCtrl,
                        cursorColor: Color(0xff000000),
                        readOnly: true,
                      ),
                    ],
                  ),
                  whiteSpaceH(4),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Align(child: Text("대리점", style: Body2),
                          alignment: Alignment.centerLeft,),
                      ),
                      TextFormField(
                        controller: agencyCtrl,
                        cursorColor: Color(0xff000000),
                        readOnly: true,
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