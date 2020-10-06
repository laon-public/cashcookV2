import 'package:cashcook/src/model/account.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class History extends StatelessWidget {
  String point;
  String pointImg;
  String id;
  AccountModel accountModel;
  int dl = 0;
  ScrollController _scrollController = ScrollController();
  int currentPage = 0;

  loadMore(context) async {
    UserProvider users = Provider.of<UserProvider>(context,listen: false);
    if(!users.isLoading){
      currentPage++;
      if(users.pageing.offset >= users.pageing.count){
        return;
      }
      users.startLoading();
      users.getAccountsHistory(point, currentPage);
    }
  }


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute
        .of(context)
        .settings
        .arguments as Map<String, dynamic>;
    point = args['point'];
    pointImg = args['pointImg'];

    if(point == "ADP") {
      dl = args['dlAccount'];
    }

    Provider.of<UserProvider>(context, listen: false).getAccountsHistory(point, 0);

    _scrollController.addListener(() {
      if(_scrollController.offset == _scrollController.position.maxScrollExtent)
        loadMore(context);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("$point 적립 / 사용 내역"),
        centerTitle: true,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: body(context),
      ),
    );
  }

  Widget body(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 26.0),
          child: RetentionPoint(context),
        ),
        historyTitle(),
        Flexible(child: historyList()),
      ],
    );
  }

  Widget RetentionPoint(context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("현재 보유 $point",
              style: TextStyle(fontSize: 14, color: mainColor),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(pointImg, fit: BoxFit.contain, width: 24,),
              whiteSpaceW(12),
              Consumer<UserProvider>(
                builder: (context, user, _){
                  return RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 24,
                            color: Color(0xff444444),
                            fontWeight: FontWeight.w600),
                        children: [
                          TextSpan(text: "${demicalFormat.format(user.nowPoint)}"),
                          TextSpan(text: "$point", style: TextStyle(fontSize: 14))
                        ]
                    ),
                  );
                }
              )

            ],
          ),
          btn(point, context),
        ],
      ),
    );
  }

  Widget btn(type, context) {
    if (type == "ADP") {
      return RaisedButton(
        onPressed: () async {
          Map<String, dynamic> args = {
            'point': point,
            "pointImg": pointImg,
            "id": id,
            "account": Provider.of<UserProvider>(context, listen:false).nowPoint,
            "dlAccount": dl
          };
          String path = "charge";
          await Navigator.of(context).pushNamed("/point/$path", arguments: args);
        },
        child: Text("충전하기", style: TextStyle(fontSize: 14),),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Color(0xffdddddd))
        ),
        color: Colors.white,
        elevation: 0.0,
      );
    } else if (type == "DL") {
      return SizedBox(height: 10, width: 2);
    } else if (type == "RP") {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RaisedButton(
            onPressed: () {
              Map<String, dynamic> args = {
                'point': point,
                "pointImg": pointImg,
                "quantity": Provider.of<UserProvider>(context, listen: false).nowPoint,
              };
              String path = "rp";

              Navigator.of(context).pushNamed("/point/$path", arguments: args);
            },
            child: Text("환전하기", style: TextStyle(fontSize: 14),),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Color(0xffdddddd))
            ),
            color: Colors.white,
            elevation: 0.0,
          ),
        ],
      );
    }
  }

  Widget historyTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("전체 내역"),
        Text("최신순")
      ],
    );
  }

  Widget historyList() {
    return Consumer<UserProvider>(
      builder: (context, users, _) {
        print("여기임");
        print(users.result);
        return ListView.builder(
          controller: _scrollController,
          itemBuilder: (context, idx) {
            if(idx < users.result.length){
              return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: historyItem(users.result[idx])
              );
            }
            if(users.result.length == 0) {
              return SizedBox();
            }
            return Center(
              child: Opacity(
                opacity: users.isLoading ? 1.0 : 0.0,
                child: CircularProgressIndicator(),
              ),
            );

          },
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: users.result.length + 1,
        );
      },
    );
  }

  Widget historyItem(Map<String, dynamic> data) {
    List<dynamic> histories = data['history'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(data['date']),
        ),
        Column(
          children: histories.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 17.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 13.0),
                    child: Image.asset(
                      pointImg, width: 48, fit: BoxFit.contain,),
                  ),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 12, color: Color(
                            0xff888888)),
                        children: [
                          TextSpan(text: "${e['title']}  ",
                              style: TextStyle(fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff444444))),
                          TextSpan(text: "${e['time']}\n"),
                          TextSpan(text: e['type']),
                        ]
                    ),
                  ),
                  Spacer(),
                  Text("${e['price']} $point", style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: e['type'] == "충전" ? mainColor : Color(
                          0xff888888)),),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }


}
