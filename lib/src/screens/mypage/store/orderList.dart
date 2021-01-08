import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/log/orderLog.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/mypage/info/serviceDetail.dart';
import 'package:cashcook/src/screens/mypage/mypage.dart';
import 'package:cashcook/src/screens/mypage/store/orderDetail.dart';
import 'package:cashcook/src/utils/CustomBottomNavBar.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

class OrderList extends StatefulWidget {
  @override
  OrderListState createState() => OrderListState();
}

class OrderListState extends State<OrderList> {
  int page;

  @override
  void initState() {
    // TODO: implement initState
    page = 1;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<StoreProvider>(context, listen: false).fetchOrderList(
          Provider.of<UserProvider>(context, listen: false).storeModel.id
      ,page);
    });
  }

  void loadMore() async {
    setState(() {
      page = page + 1;
    });
    await Provider.of<StoreProvider>(context, listen: false).fetchOrderList(
        Provider.of<UserProvider>(context, listen: false).storeModel.id
        ,page);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
            elevation: 0.5,
            centerTitle: true,
            title: Text(
              "매출내역",
              style: appBarDefaultText,
            ),
            leading: IconButton(
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
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 60.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Consumer<StoreProvider>(
                    builder: (context, sp, _){
                      return NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if(scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent){
                            if(!sp.isLoading && !sp.isLastList){
                              loadMore();
                            }
                          }

                          return true;
                        },
                        child: SingleChildScrollView(
                            child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                                    margin: EdgeInsets.all(24),
                                    child: Text("주문확인 후 접수완료 버튼을 꼭 눌러주세요!",
                                      style: Subtitle2.apply(
                                        fontWeightDelta: 1,
                                        color: white
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    decoration: BoxDecoration(
                                      color: primary,
                                    ),
                                  ),
                                  Column(
                                      children: sp.orderList.map((e) =>
                                          ServiceItem(e)
                                      ).toList()
                                  ),
                                  (sp.isLoading) ?
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 85,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              valueColor: new AlwaysStoppedAnimation<Color>(primary)
                                          )
                                      )
                                  ):
                                  Column(
                                    children: [
                                      Container(),
                                      (sp.isLastList) ?
                                      (page == 1) ?
                                      Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 60,
                                          child: Center(
                                              child: Text(
                                                  "이용내역 조회 결과가 없습니다.",
                                                  style: Body1
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
            CustomBottomNavBar(context, "mypage")
          ],
        )
    );
  }

  Widget ServiceItem(ServiceLogListItem sll) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 24, bottom: 4, left: 16.0),
          width: MediaQuery.of(context).size.width,
          child: Text(
            sll.date,
            style: Body2,
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
      onTap: () async {
        await Provider.of<StoreProvider>(context, listen: false).setSelOrderLog(ol);
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => OrderDetail()
            )
        );
      },
      child:  Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Color(0xFFF7F7F7),
                      width: 1
                  )
              )
          ),
          padding: EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width,
          height: 85,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(6)
                    ),
                    border: Border.all(
                        color: Color(0xFFDDDDDD),
                        width: 0.5
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        ol.storeImg,
                      ),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${numberFormat.format(ol.pay)}원",
                          style: Body1.apply(
                              fontWeightDelta: 1
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        whiteSpaceW(12),
                        Text(DateFormat('kk:mm').format(ol.createdAt),
                            style: Body2
                        ),
                      ],
                    ),
                    whiteSpaceH(3),
                    Text(ol.content,
                      style:Body2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              whiteSpaceW(13.0),
              Container(
                child: Row(
                  children: [
                    ol.status == "REFUND_CONFIRM" ?
                    Text("결제 취소",
                        style: Body1.apply(
                            color: secondary,
                            fontWeightDelta: 1
                        )
                    )
                        :
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${numberFormat.format(ol.pay)}원",
                            style: Body1.apply(
                                color: secondary,
                                fontWeightDelta: 1
                            )
                        ),
                        (ol.dl == 0) ?
                        Container()
                            :
                        Text("${numberFormat.format(ol.dl)} DL",
                            style: Body1.apply(
                                color: primary,
                                fontWeightDelta: 1
                            )
                        ),
                      ],
                    ),
                    whiteSpaceW(12.0),
                    Icon(Icons.arrow_forward_ios, size: 16, color: black,)
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
}