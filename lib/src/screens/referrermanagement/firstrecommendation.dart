import 'package:cashcook/src/model/usercheck.dart';
import 'package:cashcook/src/screens/main/home.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'dart:math';
import 'package:cashcook/src/screens/mypage/store/store.dart';

class FirstRecommendation extends StatefulWidget {
  final String type;

  FirstRecommendation({this.type});
  @override
  _FirstRecommendation createState() => _FirstRecommendation();
}



class _FirstRecommendation extends State<FirstRecommendation> {
  String _selectedValue = "선택해주세요.";
  String _unSelectedValue = "HOJO Group.";
  String memb = '';

  int _check;
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).recoemberlist();
  }

  bool userCheck = false;

  FocusNode contactUsFocus = FocusNode();

  AppBar appBar;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);

    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: true,
      appBar: appBar = AppBar(
        backgroundColor: white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          "추천자 선택",
          style: appBarDefaultText
        ),
        automaticallyImplyLeading: false, // 뒤로가기 기능 x
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
          child: Padding(
            padding: EdgeInsets.only(top: 30,left: 16, right: 16, bottom: 16),
            child:
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "캐시쿡을 추천해준\n친구를 선택해주세요.",
                    textAlign: TextAlign.start,
                    style: Subtitle1
                ),
                whiteSpaceH(34),
                Text('추천자',
                  style: Body2.apply(
                    color: primary
                  ),
                ),
                whiteSpaceH(4),
                Consumer<UserProvider>(
                  builder: (context, user, _){
                    memb = (user.recomemberList.length < 2) ? '추천자가 아무도 없습니다.'
                        : '캐시쿡을 추천해준 친구를 선택해주세요.';
                    (user.isStop && user.recomemberList.length < 2) ?
                    (user.recomemberList.length < 2) ? nextPage(userProvider.loginUser) : print("확인1") :
                        print("확인2");
                    return (user.isStop) ? SizedBox(
                      child: DropdownButton(
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down,
                          color: black,
                        ),

                        iconSize: 24,
                        elevation: 16,
                        underline: Container(
                            height: 3,
                            color: black
                        ),
                        value: (user.recomemberList.length < 2) ? _unSelectedValue : _selectedValue ,
                        items: user.recomemberList.map(
                                (value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }
                        ).toList(),
                        style: Subtitle2.apply(
                          fontWeightDelta: -1
                        ),

                        onChanged: (value){
                          (user.recomemberList.length < 2) ?
                          setState(() {
                            _unSelectedValue = value;
                          }) :
                          setState(() {
                            _selectedValue = value;
                          });
                        },
                      ),
                    ) :
                    Center(
                        child: Column(
                          children: <Widget>[
                            new Image.asset("assets/resource/public/loading.gif"),
                          ],
                        )
                    );
                  },
                ),
                Expanded(
                  child: Container(),
                ),
                whiteSpaceH(24),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 11),
                    onPressed: () {
                      apply(userProvider.loginUser);
                    },
                    elevation: 0.0,
                    color: primary,
                    shape:
                       RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    child: Center(
                      child: Text(
                        "확인",
                        style: Subtitle2.apply(
                          color: white,
                          fontWeightDelta: 1
                        )
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  apply(UserCheck user) async {
    UserProvider userProviders = Provider.of<UserProvider>(context,listen: false);
    print(userProviders.recomemberList);
    print('추천해준 사람 선택 : $_selectedValue');
    String selectedmember;

    int i =0;
    if(userProviders.recomemberList.length > 2) {
      if (_selectedValue == '랜덤선택') {
        List<String> ss = [];
        for (String userid in userProviders.recomemberList) {
          if (i >= 2) {
            ss.add(userid);
          }
          i++;
        }
        print(ss);
        int ranmax = ss.length;
        print(ranmax);
        var ran = Random().nextInt(ranmax);

        print('$ran');
        selectedmember = ss[ran];
        print('$selectedmember');
      } else {
        selectedmember = _selectedValue;
      }
    } else {
      selectedmember = "HOJOGroup";
    }

    if (userProviders.recomemberList.length > 2 && _selectedValue == '선택해주세요.') {
      Fluttertoast.showToast(msg: "추천회원을 선택해 주세요.");
    } else {
      // if(widget.type != null && widget.type == "AGENCY"){
      //   await Provider.of<UserProvider>(context, listen: false).insertDis();
      // }
      String response = await Provider.of<UserProvider>(context, listen: false).recomemberinsert(selectedmember, widget.type); // 나를 추천한 사람을 선택 후 저장

      if(response == "true"){
        Fluttertoast.showToast(msg: "등록이 완료되었습니다.");
      }else {
        Fluttertoast.showToast(msg: response);
      }



      if(widget.type == "AGENCY"){
        Navigator.of(context)
            .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => StoreApplyFirstStep()), (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      }

    }
  }

  nextPage(UserCheck user) async {
    String selectedmember = "HOJOGroup";
    String response = await Provider.of<UserProvider>(context, listen: false).recomemberinsert(selectedmember, widget.type); // HOJOGroup저장

    if(response == "true"){
      Fluttertoast.showToast(msg: "등록이 완료되었습니다.");
    }else {
      Fluttertoast.showToast(msg: response);
    }

//    Navigator.of(context).pushAndRemoveUntil(
//        MaterialPageRoute(builder: (context) => MainMap()), (route) => false);
  }

}