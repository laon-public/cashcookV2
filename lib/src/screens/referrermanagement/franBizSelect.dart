import 'package:cashcook/src/screens/mypage/store/storeApply.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import '../../provider/UserProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import '../../widgets/showToast.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';

class FranBizSelect extends StatefulWidget {
  @override
  _FranBizSelect createState() => _FranBizSelect();
}

class _FranBizSelect extends State<FranBizSelect> {
  bool userCheck = false;

  AppBar appBar;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context,listen: false).selectDisAge();
    });
    
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
                padding: EdgeInsets.only(top: 10.0,left: 16, right: 16, bottom: 16),
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
                            "현재 성공스토어의\n상위성공마스터를 선택해주세요.",
                            textAlign: TextAlign.start,
                            style: Subtitle2.apply(
                              fontWeightDelta: -1
                            ),
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
                          if(value != "성공마스터"){
                            Provider.of<UserProvider>(context, listen: false).selectAge(value);
                          } else {
                            Provider.of<UserProvider>(context, listen: false).clearAge(value);
                          }
                        },
                      ),
                    ),
                    whiteSpaceH(4),
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
                        value: user.ageSelected ,
                        items: user.ageList.map(
                                (value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }
                        ).toList(),
                        onChanged: (value){
                          Provider.of<UserProvider>(context, listen: false).setAgeSelected(value);
                        },
                      ),
                    ),
                    whiteSpaceH(8),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '상위 성공마스터 / 성공메이커을 선택해주세요.',
                            textAlign: TextAlign.start,
                            style: Body2
                          ),
                          whiteSpaceW(12),
                        ],
                      ),
                    ),
                   Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: RaisedButton(
                        onPressed: () async {
                          if(user.disSelected == "성공마스터"){
                            showToast("성공마스터를 선택해주세요.");
                            return;
                          }

                          if(user.ageSelected == "성공메이커"){
                            showToast("성공메이커을 선택해주세요.");
                            return;
                          }

                          await Provider.of<UserProvider>(context, listen: false).insertDisAge();

                          // Navigator.of(context).pushAndRemoveUntil(
                          //     MaterialPageRoute(builder: (context) => StoreApplyState()), (route) => false);

                          showToast("성공마스터/성공메이커 등록이 완료됐습니다.");
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => MainMap()), (route) => false);
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