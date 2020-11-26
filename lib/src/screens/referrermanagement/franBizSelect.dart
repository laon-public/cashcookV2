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
          "총판 입력",
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
                            "현재 매장의\n상위총판을 선택해주세요.",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'noto', fontSize: 16, color: black),
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
                          if(value != "총판"){
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
                            '상위 총판 / 대리점을 선택해주세요.',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'noto', fontSize: 12, color: Color(0xFF888888)),
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
                          if(user.disSelected == "총판"){
                            showToast("총판을 선택해주세요.");
                            return;
                          }

                          if(user.ageSelected == "대리점"){
                            showToast("대리점을 선택해주세요.");
                            return;
                          }

                          await Provider.of<UserProvider>(context, listen: false).insertDisAge();

                          // Navigator.of(context).pushAndRemoveUntil(
                          //     MaterialPageRoute(builder: (context) => StoreApplyState()), (route) => false);

                          showToast("총판/대리점 등록이 완료됐습니다.");
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => MainMap()), (route) => false);
                        },
                        elevation: 0.0,
                        color: mainColor,
                        child: Center(
                          child: Text(
                            "확인",
                            style: TextStyle(
                                color: white,
                                fontSize: 14,
                                fontFamily: 'noto',
                                fontWeight: FontWeight.w600),
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