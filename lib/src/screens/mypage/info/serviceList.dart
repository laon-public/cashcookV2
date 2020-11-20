import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/log/orderLog.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/mypage/info/serviceDetail.dart';
import 'package:cashcook/src/screens/mypage/mypage.dart';
import 'package:cashcook/src/utils/CustomBottomNavBar.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ServiceList extends StatefulWidget {
  bool isHome;
  bool afterGame;

  ServiceList({this.isHome = false, this.afterGame = false});

  @override
  _ServiceList createState() => _ServiceList();
}

class _ServiceList extends State<ServiceList> {
  int page;

  @override
  void initState() {
    // TODO: implement initState
    page = 1;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).fetchServiceList(page);
    });
  }

  void loadMore() async {
    setState(() {
      page = page + 1;
    });
    await Provider.of<UserProvider>(context, listen: false).fetchServiceList(page);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.afterGame);
    // TODO: implement build
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.5,
              centerTitle: true,
              title: Text(
                "서비스 이용내역",
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'noto',
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w600
                ),
              ),
              leading: widget.afterGame ? IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MyPage(
                        isHome: true,
                      ))
                      , (route) => false);
                },
                icon: Image.asset(
                  "assets/resource/public/prev.png",
                  width: 24,
                  height: 24,
                ),
              )
                  :
              null,
            ),
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0, bottom: widget.isHome ? 60.0 : 16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Consumer<UserProvider>(
                      builder: (context, up, _){
                        return NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if(scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent){
                              if(!up.isLoading && !up.isLastList){
                                loadMore();
                              }
                            }

                            return true;
                          },
                          child: SingleChildScrollView(
                            child: Column(
                                    children: [
                                      Column(
                                          children: up.serviceLogList.map((e) =>
                                              ServiceItem(e)
                                          ).toList()
                                      ),
                                      (up.isLoading) ?
                                      Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 85,
                                          child: Center(
                                              child: CircularProgressIndicator(
                                                  backgroundColor: mainColor,
                                                  valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
                                              )
                                          )
                                      ):
                                          Column(
                                            children: [
                                              Container(),
                                              (up.isLastList) ?
                                              (page == 1) ?
                                              Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 60,
                                                  child: Center(
                                                      child: Text(
                                                          "이용내역 조회 결과가 없습니다.",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily: 'noto',
                                                              color: Color(0xFF333333)
                                                          )
                                                      )
                                                  )
                                              )
                                                  :
                                              Container(
                                                width: MediaQuery.of(context).size.width,
                                                height: 45,
                                              )
                                                  :
                                              Container(
                                                width: MediaQuery.of(context).size.width,
                                                height: 45,
                                              )
                                            ],
                                          )
                                    ]
                                )
                          ),
                        );
                      },
                    )
                  ),
                ),
                widget.isHome ? CustomBottomNavBar(context, "pointmgmt") : Container(),
              ],
            )
        ),
        onWillPop: ExitPressed);
  }

  Widget ServiceItem(ServiceLogListItem sll) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          width: MediaQuery.of(context).size.width,
          child: Text(
            sll.date,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF999999),
              fontFamily: 'noto',
              fontWeight: FontWeight.w400
            ),
          ),
        ),
        Column(
          children: sll.orderLogList.map((e) =>
            OrderItem(e)
          ).toList()
        )
      ],
    );
  }
  // 서비스 이용내역 아이템
  Widget OrderItem(OrderLog ol){
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ServiceDetail(
              ol: ol,
            )
          )
        );
      },
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          width: MediaQuery.of(context).size.width,
          height: 85,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: ol.storeImg,
                imageBuilder: (context, img) => Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(6.0)
                        ),
                        image: DecorationImage(
                            image: img, fit: BoxFit.fill
                        )
                    )
                ),
              ),
              whiteSpaceW(13.0),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(ol.storeName,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'noto',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          whiteSpaceW(12),
                          Text(DateFormat('kk:mm').format(ol.createdAt),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'noto',
                                  color: Color(0xFF999999)
                              )
                          ),
                        ],
                      ),
                      Text(ol.content,
                          style:TextStyle(
                              fontSize: 12,
                              fontFamily: 'noto',
                              color: Color(0xFF999999)
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
              ),
              whiteSpaceW(13.0),
              Container(
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("-${numberFormat.format(ol.pay)} 원",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'noto',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF999999)
                            )
                        ),
                        (ol.dl == 0) ?
                        Container()
                        :
                        Text("-${numberFormat.format(ol.dl)} DL",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'noto',
                                fontWeight: FontWeight.w600,
                                color: mainColor
                            )
                        ),
                      ],
                    ),
                    whiteSpaceW(12.0),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xff999999),)
                  ],
                ),
              )
            ],
          )
      ),
    );
  }

  Future<bool> ExitPressed() {
    return showDialog( context: context,
      builder: (context) => AlertDialog( content: Container(
          child: Text("앱을 종료하시겠습니까?",
            style: TextStyle(
                fontFamily: 'noto',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333)
            ),
            textAlign: TextAlign.center,
          )
      ),
        actions: <Widget>[
          FlatButton(
            child: Text("예",
              style: TextStyle(
                  fontFamily: 'noto',
                  fontSize: 14,
                  color: mainColor
              ),
            ),
            onPressed: () => Navigator.pop(context, true), ),
          FlatButton(
            child: Text("아니요",
              style: TextStyle(
                  fontFamily: 'noto',
                  fontSize: 14,
                  color: subColor
              ),
            ),
            onPressed: () => Navigator.pop(context, false), ), ], ), ) ?? false;

  }
}