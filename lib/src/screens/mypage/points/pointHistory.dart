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
      body: Container(
        child: body(context),
      ),
    );
  }

  Widget body(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RetentionPoint(context),
        Container(
          margin: EdgeInsets.symmetric(vertical: 24),
          width: MediaQuery.of(context).size.width,
          height: 8,
          color: Color(0xFFF2F2F2)
        ),
        historyTitle(),
        Flexible(child: historyList()),
      ],
    );
  }

  Widget RetentionPoint(context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12, bottom: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            // child: Text("현재 보유 ${point == "DL" ? "DL" : point}",
              child: Text("현재 보유 ${point == "DL" ? "DL" : point == "CARAT" ? "CARAT" : point == "RP" ? "CP" : point}",
              style: Body1.apply(
                color: third
              ),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<UserProvider>(
                builder: (context, user, _){
                  return RichText(
                    text: TextSpan(
                        style: Subtitle1.apply(
                          fontWeightDelta: 2
                        ),
                        children: [
                          TextSpan(text: "${demicalFormat.format(user.nowPoint)} "),
                          TextSpan(text: "${point == "DL" ? "DL" : point == "CARAT" ? "CARAT" : point == "RP" ? "CP" : point}", style: Subtitle2.apply(
                            fontWeightDelta: 1
                          ))
                        ]
                    ),
                  );
                }
              )

            ],
          ),
          whiteSpaceH(8.0),
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
        child: Text("충전하기", style: Body1.apply(color:primary),),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 22),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
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
            child: Text("DL 구매", style: Body1.apply(color:primary),),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 22),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
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
            child: Text("충전하기", style: Body1.apply(color:primary),),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 22),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          child: Text("전체 내역",
              style: Subtitle2.apply(
                  fontWeightDelta: 1
              )
          ),
        ),
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
                  padding: const EdgeInsets.only(top: 24.0),
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
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(DateFormat("yyyy.MM.dd").format(
              DateTime.parse( data['date'].toString())),
            style: Body2
          ),
        ),
        Column(
          children: histories.map((e) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFF7F7F7),
                    width: 1,
                  )
                )
              ),
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: Row(
                children: [
                Image.asset(
                  pointImg, width: 36, height: 36, fit: BoxFit.contain
                ),
                  whiteSpaceW(12.0),
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
                    child: Text("${e['price']} ${point == "DL" ? "DL" : point == "CARAT" ? "CARAT" : point == "RP" ? "CP" : point}",
                      style: Body1.apply(
                          color: e['type'] == "충전" ?
                          mainColor
                              :
                          third,
                        fontWeightDelta: 1
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
