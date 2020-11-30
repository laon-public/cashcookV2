import 'package:cashcook/src/model/account.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/mypage/points/chargePoint_2.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

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
        // title: Text("${point == "DL" ? "DL" : point} 적립 / 사용 내역",
        title: Text("${point == "DL" ? "DL" : point == "CARAT" ? "CARAT" : point == "RP" ? "CP" : point} 적립 / 사용 내역",
          style: appBarDefaultText),
        centerTitle: true,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24, color: black,),
        ),
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
            // child: Text("현재 보유 ${point == "DL" ? "DL" : point}",
              child: Text("현재 보유 ${point == "DL" ? "DL" : point == "CARAT" ? "CARAT" : point == "RP" ? "CP" : point}",
              style: Body1.apply(
                color: primary
              ),),
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
                        style: Headline,
                        children: [
                          TextSpan(text: "${demicalFormat.format(user.nowPoint)} "),
                          TextSpan(text: "${point == "DL" ? "DL" : point == "CARAT" ? "CARAT" : point == "RP" ? "CP" : point}", style: Body1)
                        ]
                    ),
                  );
                }
              )

            ],
          ),
          whiteSpaceH(4.0),
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
          await Provider.of<UserProvider>(context, listen: false).clearQuantity();
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChargePoint2(
                pointType: point,
              )
            )
          );
        },
        child: Text("충전하기", style: Body1,),
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
      return
          RaisedButton(
            onPressed: () async {
              Map<String, dynamic> args = {
                'point': point,
                "pointImg": pointImg,
                "quantity": Provider.of<UserProvider>(context, listen: false).nowPoint,
              };
              String path = "rp";

              await Navigator.of(context).pushNamed("/point/$path", arguments: args);
            },
            child: Text("DL 구매", style: Body1,),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Color(0xffdddddd))
            ),
            color: Colors.white,
            elevation: 0.0,
          );
    } else if (type == "CARAT") {
      return
          RaisedButton(
            onPressed: () async {
              Map<String, dynamic> args = {
                'point': point,
                "pointImg": pointImg,
                "id": id,
                "account": Provider.of<UserProvider>(context, listen:false).nowPoint,
                "dlAccount": dl
              };
              String path = "charge";
              await Provider.of<UserProvider>(context, listen: false).clearQuantity();
              await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ChargePoint2(
                        pointType: point,
                      )
                  )
              );
            },
            child: Text("충전하기", style: Body1,),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Color(0xffdddddd))
            ),
            color: Colors.white,
            elevation: 0.0,
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
                  child:CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
                  )
                )
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
          child: Text(DateFormat("yy.MM.dd").format(
              DateTime.parse( data['date'].toString())),
            style: Body2
          ),
        ),
        Column(
          children: histories.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 17.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child : Padding(
                      padding: const EdgeInsets.only(right: 13.0),
                      child: Image.asset(
                        pointImg, width: 48, fit: BoxFit.contain,),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex:2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${e['title']}  ",
                                  overflow: TextOverflow.ellipsis,
                                  style: Body1.apply(
                                    fontWeightDelta: 1
                                  )
                              ),
                              Text(e['type'],
                                  overflow: TextOverflow.ellipsis,
                                  style: Caption
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text("${e['time']}\n",
                               overflow: TextOverflow.ellipsis,
                               style: Body2,
                               textAlign: TextAlign.start,),
                           ],
                          )
                        )
                      ]
                    )
                  ),
                  Expanded(
                    flex: 3,
                    child: Text("${e['price']} ${point == "DL" ? "DL" : point == "CARAT" ? "CR" : "CP"}",
                      style: Subtitle1.apply(
                          color: e['type'] == "충전" ?
                          mainColor
                              :
                          third
                      ),
                        textAlign: TextAlign.end,),
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }


}
