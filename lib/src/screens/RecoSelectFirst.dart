import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecoFrst extends StatefulWidget {
  @override
  _RecoFirstState createState() => _RecoFirstState();
}

class _RecoFirstState extends State<RecoFrst> {
//  List<String> recos = ["asd", "asdf"];
  String selectVal = "추천인 없음";
  int selectKey;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getReco();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("추천인 입력"),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: body(),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Reco(),
          ),
          Expanded(
            child: SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 56),
            child: bottom(),
          )
        ],
      ),
    );
  }

  Widget Reco() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("추천인"),
        Consumer<UserProvider>(
          builder: (context, user, _){
            return  DropdownButton<String>(
              underline: Container(
                width: MediaQuery.of(context).size.width,
                height: 2,
                color: Color(0xFFDDDDDD),
              ),
              elevation: 0,
              isExpanded: true,
              style: TextStyle(color: black, fontSize: 16, fontFamily: 'noto'),
              items: user.recoList.map((values) {
                return DropdownMenuItem<String>(
                  value: values.values.toList()[0],
                  child: Text(
                    values.values.toList()[0],
                    style:
                    TextStyle(color: black, fontSize: 16, fontFamily: 'noto'),
                  ),
                );
              }).toList(),
              value: selectVal,
              onChanged: (value) {
                setState(() {
                  selectVal = value;
                });
              },
            );
          },
        ),
        SizedBox(
            width: double.infinity,
            child: Align(
                alignment: Alignment.centerRight,
                child: Text("캐시쿡을 추천해준 친구를 선택해주세요.")))
      ],
    );
  }

  Widget bottom() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: SizedBox(),),
            Text(
              "캐시쿡을 추천해준\n친구를 선택해주세요.",
              textAlign: TextAlign.right,
            ),
            whiteSpaceW(12),
            Container(
              width: 48,
              height: 48,
              color: Color(0xffdddddd),
            )
          ],
        ),
        whiteSpaceH(29),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: RaisedButton(
            onPressed: () {

            },
            child: Text("확인"),
            color: mainColor,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
