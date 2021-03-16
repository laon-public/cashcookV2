import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';

import '../../provider/UserProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import '../../widgets/showToast.dart';
import 'firstrecommendation.dart';

class FirstBizSelect extends StatefulWidget {
  @override
  _FirstBizSelect createState() => _FirstBizSelect();
}

class _FirstBizSelect extends State<FirstBizSelect> {
  String _selectedValue = "성공마스터";

  bool userCheck = false;

  AppBar appBar;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context,listen: false).selectDis();
    });

    return Scaffold(
        backgroundColor: white,
        resizeToAvoidBottomInset: true,
        appBar: appBar = AppBar(
          backgroundColor: white,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            "성공마스터 입력",
            style: appBarDefaultText,
          ),
          automaticallyImplyLeading: false,
        ),
        body:

        Consumer<UserProvider>(
            builder: (context, user, _) {
              return (user.isLoading) ?
              Center(
                  child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
                  )
              )
                  :
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - appBar.preferredSize.height,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10,left: 16, right: 16, bottom: 16),
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        whiteSpaceH(24),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 72,
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "현재 성공스토어의\n상위 성공마스터를 선택해주세요.",
                                textAlign: TextAlign.start,
                                style: Subtitle2.apply(
                                  fontWeightDelta: -1
                                )
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
                        whiteSpaceH(10),
                        SizedBox(
                          child: DropdownButton(
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            underline: Container(
                                height: 2,
                                color: mainColor
                            ),
                            value: user.disSelected ,
                            items: user.disList.map(
                                    (value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }
                            ).toList(),
                            onChanged: (value){
                              Provider.of<UserProvider>(context, listen: false).setDisSelected(value);
                            },
                          ),
                        ),
                        whiteSpaceH(8),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '상위 성공마스터를 선택해주세요.',
                                textAlign: TextAlign.start,
                                style: Body2
                              ),
                              whiteSpaceW(12),
                            ],
                          ),
                        ),
                        Spacer(),
                        whiteSpaceH(24),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: RaisedButton(
                            onPressed: () async {
                              if(user.disSelected == "성공마스터") {
                                showToast("성공마스터를 선택해주세요.");
                                return;
                              } else {
                                await Provider.of<UserProvider>(
                                    context, listen: false)
                                    .recognitionSelect()
                                    .then((value) async =>
                                {
                                  if(value == 0){
                                    await Provider.of<UserProvider>(context, listen: false).insertDis(),
                                    showToast("추천자가 없습니다."),
                                    await Provider.of<UserProvider>(
                                        context, listen: false).withoutRecoAge(),

                                    Navigator.of(context)
                                        .pushAndRemoveUntil(MaterialPageRoute(
                                        builder: (context) => MainMap()), (
                                        route) => false),
                                  } else
                                    {
                                      Navigator.of(context)
                                          .pushAndRemoveUntil(MaterialPageRoute(
                                          builder: (context) => FirstRecommendation(
                                              type: "AGENCY")), (route) => false),
                                    }
                                }
                                );
                              }
                            },
                            elevation: 0.0,
                            color: mainColor,
                            child: Center(
                              child: Text(
                                "확인",
                                style: Body1.apply(
                                  color: white
                                )
                              ),
                            ),
                          ),
                        ),
                        whiteSpaceH(40)
                      ],
                    ),
                  ),
                ),
              );
            }
        )
    );
  }
}