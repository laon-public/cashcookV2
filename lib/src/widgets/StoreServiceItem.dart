import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/model/store/reviewWrite.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Widget menuForm(BuildContext context) {
  int bigIdx = 0;
  return Consumer<StoreServiceProvider>(
      builder: (context, ss, __) {
        return
          Container(
              width: MediaQuery.of(context).size.width,
              child:
              Column(
                  children:
                  ss.menuList.map((e) =>
                      BigMenuItem(bigIdx++,e, context)
                  ).toList()

              )
          );
      }
  );
}

Widget BigMenuItem(int bigIdx,BigMenuModel bmm, BuildContext context){
  int idx = 0;
  return Container(
      width: MediaQuery.of(context).size.width,
      child:
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Padding(
              padding: EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0),
              child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bmm.name,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'noto',
                          color: Color(0xFF444444),
                          fontWeight: FontWeight.w600
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ]
              ),
            ),
            Padding(
                padding: EdgeInsets.only(right: 20.0,bottom: 10.0),
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    bmm.menuList.map((e) =>
                        MenuItem(bigIdx,idx++,e, context)
                    ).toList()
                )
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height:  1,
                color: Color(0xFFEEEEEE)
            ),
          ]
      )
  );
}

Widget MenuItem(int bigIdx,int idx,MenuModel mm, BuildContext context) {
  StoreServiceProvider ssp = Provider.of<StoreServiceProvider>(context, listen: false);
  return Container(
      padding: EdgeInsets.only(left: 16.0),
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Row(
          children: [
            InkWell(
              onTap: () {
                ssp.setCheck(bigIdx,idx, !mm.isCheck);
              },
              child: Container(
                width: 48,
                height: 48,
                child: Stack(
                  children: [
                    Center(
                        child: Image.asset(
                            "assets/icon/cashcook_logo.png"
                        ),
                      ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        transform: Matrix4.translationValues(2.0, -2.0, 0.0),
                        width:12,
                        height: 12,
                        child: Transform.scale(scale: 0.6,
                          child: CircularCheckBox(
                            value: mm.isCheck,
                            activeColor: Color(0xFFFF0000),
                            inactiveColor: Color(0xFFDDDDDD),
                            onChanged: (value) {
                              ssp.setCheck(bigIdx,idx, value);
                            },
                          ),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFDDDDDD),
                        ),
                        // Checkbox(
                        //   activeColor: mainColor,
                        //   checkColor: mainColor,
                        //   value: mm.isCheck,
                        //   onChanged: (value) {
                        //     ssp.setCheck(bigIdx,idx, value);
                        //   },
                        // ),
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFDDDDDD),
                    width: 1
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0)
                  )
                ),
              ),
            ),
            whiteSpaceW(16.0),
            Expanded(
              child: Text("${mm.name}",
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'noto',
                      color: Color(0xFF333333)
                  )
              ),
            ),
            Text("${numberFormat.format(mm.price)} 원",
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Color(0xFF444444),
                  fontSize: 14,
                  fontFamily: 'noto'
              ),
              textAlign: TextAlign.end,
            )
          ]
      ),
  );
}

Widget reviewForm(BuildContext context, StoreModel store) {
  StoreProvider sp = Provider.of<StoreProvider>(context, listen: false);
  StoreModel selStore = store == null ? sp.selStore : store;
  return Consumer<StoreServiceProvider>(
      builder: (context, ss, __){
        return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            child: SingleChildScrollView(
                child: Center(
                    child:Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(10.0),
                              child:Stack(
                                  children: [
                                    Positioned(
                                        top:0,
                                        right: 0,
                                        child: RaisedButton(
                                            color: mainColor,
                                            onPressed: () async {
                                              await Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) => ReviewWrite(
                                                        store_id: selStore.id,
                                                      )));
                                              ss.setServiceNum(1, selStore.id);
                                            },
                                            child: Text("작성하기",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'noto',
                                                  color: white,
                                                ))
                                        )
                                    ),
                                    Column(
                                        children:[
                                          Text("평가 및 리뷰",
                                              style: TextStyle(
                                                  fontFamily: 'noto',
                                                  fontSize: 12,
                                                  color: mainColor,
                                                  fontWeight: FontWeight.w600
                                              )),
                                          Text("${NumberFormat("#.#").format(ss.reviewAvg)}",
                                              style: TextStyle(
                                                  fontFamily: 'noto',
                                                  fontSize: 40,
                                                  color: mainColor,
                                                  fontWeight: FontWeight.w600
                                              )),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                starImage(ss.reviewAvg,1),
                                                starImage(ss.reviewAvg,2),
                                                starImage(ss.reviewAvg,3),
                                                starImage(ss.reviewAvg,4),
                                                starImage(ss.reviewAvg,5),
                                              ]
                                          ),
                                        ]
                                    )
                                  ]
                              )
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height:12,
                              color: Color(0xFFEEEEEE)
                          ),
                          (ss.isLoading) ?
                          Container(
                              padding: EdgeInsets.all(10),
                              child:Center(
                                  child: CircularProgressIndicator(
                                      backgroundColor: mainColor,
                                      valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
                                  )
                              )
                          )
                              :
                          (ss.reviewList.length == 0) ?
                          Container(
                              padding: EdgeInsets.all(20),
                              child:Column(
                                  children:[
                                    Text("리뷰가 없습니다.",
                                        style: TextStyle(
                                          color: Color(0xFF888888),
                                          fontSize: 16,
                                          fontFamily: 'noto',
                                        )
                                    ),
                                    whiteSpaceH(10),
                                    RaisedButton(
                                        color: mainColor,
                                        onPressed: () async {
                                          await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => ReviewWrite(
                                                    store_id: selStore.id,
                                                  )));
                                          ss.setServiceNum(1, selStore.id);
                                        },
                                        child: Text("첫 리뷰를 작성해주세요!",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'noto',
                                              color: white,
                                            ))
                                    )
                                  ]
                              )
                          )
                              :
                          Container(
                              padding: EdgeInsets.all(10),
                              child:ListView.builder(
                                shrinkWrap: true,
                                itemCount: ss.reviewList.length,
                                itemBuilder: (context, idx) {
                                  return reviewListItem(idx,ss.reviewList[idx], context);
                                },
                                physics: NeverScrollableScrollPhysics(),
                              )
                          )
                        ]
                    )
                )
            )
        );
      }
  );
}

Widget reviewListItem(idx,review, BuildContext context) {
  return Container(
      width: MediaQuery.of(context).size.width,
      child:
      Column(
          children: [
            Row(
                children: [
                  Text("${review.username}",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'noto',
                          fontWeight: FontWeight.w600
                      )),
                  whiteSpaceW(15),
                  Text("${review.date.split("T").first}",
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'noto',
                          color: Color(0xFF888888)
                      )),
                  Spacer(),
                  Image.asset(
                    "assets/icon/review/star_full_color.png",
                    width: 14,
                    height: 14,
                  ),
                  Text("${review.scope}",
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'noto',
                          color: Color(0xFF888888)
                      ))
                ]),
            whiteSpaceH(5),
            Container(
                width: MediaQuery.of(context).size.width,
                child:Text(
                    "${review.contents}",
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'noto',
                        color: Color(0xFF888888)
                    )
                )
            ),
            whiteSpaceH(8),
            Row(
                children: [
                  likeImage(idx,review.id,review.isLike, context),
                  whiteSpaceW(10),
                  Text(
                      "${review.like}",
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'noto',
                          color: Color(0xFF888888)
                      )
                  ),
                  whiteSpaceW(20),
                  hateImage(idx,review.id, review.isHate, context),
                  whiteSpaceW(10),
                  Text(
                      "${review.hate}",
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'noto',
                          color: Color(0xFF888888)
                      )
                  )
                ]
            ),
            whiteSpaceH(15)
          ]
      )
  );
}

Widget hateImage(idx,review_id,isHate,BuildContext context) {
  print(review_id);
  return (isHate == 0) ?
  InkWell(
      onTap: () async {
        print("싫어요 누르는 액션");
        await Provider.of<StoreServiceProvider>(context, listen:false).patchReview(idx,review_id, "hate", "inc");
      },
      child:Image.asset(
        "assets/icon/dislike_grey.png",
        width: 18,
        height: 18,
      )
  )
      :
  InkWell(
      onTap: () async {
        print("싫어요 취소하는 액션");
        await Provider.of<StoreServiceProvider>(context, listen:false).patchReview(idx,review_id, "hate", "dec");
      },
      child:Image.asset(
          "assets/icon/hate_color.png",
          width: 18,
          height: 18,
          color: mainColor
      )
  );
}

Widget likeImage(idx,review_id,isLike, BuildContext context) {
  print(review_id);
  return (isLike == 0) ?
  InkWell(
      onTap: () async {
        print("좋아요 누르는 액션");
        await Provider.of<StoreServiceProvider>(context, listen:false).patchReview(idx,review_id, "like", "inc");
      },
      child:Image.asset(
        "assets/icon/like_grey.png",
        width: 18,
        height: 18,
      )
  )
      :
  InkWell(
      onTap: () async {
        print("좋아요 취소하는 액션");
        await Provider.of<StoreServiceProvider>(context, listen:false).patchReview(idx,review_id, "like", "dec");
      },
      child:Image.asset(
        "assets/icon/like_color.png",
        width: 18,
        height: 18,
        color: mainColor,
      )
  );
}

Widget starImage(avg,idx) {
  return (avg >= idx) ?
  Image.asset(
    "assets/icon/star_full_color.png",
    width: 14,
    height: 14,
  )
      :
  Image.asset(
    "assets/icon/star_color.png",
    width: 14,
    height: 14,
  );
}

Widget otherForm(BuildContext context, StoreModel store) {
  StoreProvider sp = Provider.of<StoreProvider>(context, listen: false);
  store == null ? store = sp.selStore : store = store;
  return Consumer<StoreServiceProvider>(
      builder: (context, ss, __){
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  width: MediaQuery.of(context).size.width,
                  child: Text("매장 정보",
                      style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'noto'
                      )
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  width: MediaQuery.of(context).size.width,
                  height: 192,
                  child:
                    Stack(
                      children: [
                        Text(
                            store.store.comment,
                            style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF666666),
                                fontFamily: 'noto'
                            )
                        ),
                        Positioned(
                          bottom: 0,
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.white,
                                  Colors.white,
                                  Colors.transparent,
                                ],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: Container(
                                color: white,
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                            ),
                          ),
                        )
                    ],
                  )

                ),
              ],
            )
        );
      }
  );
}