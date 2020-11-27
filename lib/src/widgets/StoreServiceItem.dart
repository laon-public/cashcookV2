import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/model/store/reviewWrite.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';

Widget menuForm(BuildContext context) {
  int bigIdx = 0;
  return Consumer<StoreServiceProvider>(
      builder: (context, ss, __) {
        return
          Container(
              transform: Matrix4.translationValues(0.0, -95.0, 0.0),
              margin: EdgeInsets.only(bottom: 10.0),
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
            Consumer<StoreServiceProvider>(
              builder: (context, ssp, _){
                return Container(
                  transform: Matrix4.translationValues(0.0, bigIdx == 0 ? 0.0 : -95.0, 0.0),
                  child: StickyHeaderBuilder(
                    builder: (BuildContext context, double stuckAmount) {
                      stuckAmount = 1.0 - stuckAmount.clamp(0.0, 1.0);
                      return Container(
                        margin: EdgeInsets.only(top: 95),
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20.0),
                        child:
                        Text(bmm.name,
                          style: Subtitle2.apply(
                            fontWeightDelta: 1
                          ),
                          textAlign: TextAlign.start,
                        ),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color.lerp(white, Color(0xFFF7F7F7), stuckAmount),
                        ),
                      );
                    },
                    content: Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                            bmm.menuList.map((e) =>
                                MenuItem(bigIdx,idx++,e, context)
                            ).toList()
                        )
                    ),
                  ),
                );
              },
            )
          ]
      )
  );
}

Widget MenuItem(int bigIdx,int idx,MenuModel mm, BuildContext context) {
  StoreServiceProvider ssp = Provider.of<StoreServiceProvider>(context, listen: false);
  return InkWell(
      onTap: () {
          ssp.setCheck(bigIdx,idx, !mm.isCheck);
          },
      child:Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFF7F7F7),
              width: 1
            )
          )
        ),
        padding: EdgeInsets.only(left: 16.0),
        width: MediaQuery.of(context).size.width,
        height: 80,
        child: Row(
            children: [
              Container(
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
              whiteSpaceW(16.0),
              Expanded(
                child: Text("${mm.name}",
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: Body1.apply(
                        color: black,
                        fontWeightDelta: 2
                    )
                ),
              ),
              Text("${numberFormat.format(mm.price)} 원",
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: Body1.apply(
                    color: secondary,
                    fontWeightDelta: 2
                ),
                textAlign: TextAlign.end,
              )
            ]
        ),
      )
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
                              height: 74,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        primary,
                                        primary,
                                        Color(0xFFFF4800),
                                        Color(0xFFFF4800)
                                      ]
                                  )
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                              child:
                              Row(
                                children: [
                                  Text("고객평점",
                                      style:
                                      Subtitle2.apply(
                                        color: white
                                      )
                                  ),
                                  Spacer(),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        starImage(ss.reviewAvg,1),
                                        whiteSpaceW(2),
                                        starImage(ss.reviewAvg,2),
                                        whiteSpaceW(2),
                                        starImage(ss.reviewAvg,3),
                                        whiteSpaceW(2),
                                        starImage(ss.reviewAvg,4),
                                        whiteSpaceW(2),
                                        starImage(ss.reviewAvg,5),
                                      ]
                                  ),
                                  whiteSpaceW(8.0),
                                  Text("${NumberFormat("#.#").format(ss.reviewAvg)} | 5.0",
                                      style: Body2.apply(
                                        color: white
                                      )),
                                ],
                              )
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height:6,
                              color: Color(0xFFEEEEEE)
                          ),
                          (ss.isLoading) ?
                          Container(
                              padding: EdgeInsets.all(10),
                              child:Center(
                                  child: CircularProgressIndicator(
                                      valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
                                  )
                              )
                          )
                              :
                          Container(
                              child:Column(
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                                      height: 42,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text("리뷰  ",
                                              style: Subtitle2
                                          ),
                                          Text("${ss.reviewList.length}개",
                                              style: Subtitle2.apply(
                                                color: primary
                                              )
                                          )
                                        ],
                                      )
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: ss.reviewList.length,
                                    itemBuilder: (context, idx) {
                                      return reviewListItem(idx,ss.reviewList[idx], context);
                                    },
                                    physics: NeverScrollableScrollPhysics(),
                                  )
                                ],
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
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child:
      Column(
          children: [
            Row(
                children: [
                  Text("${review.username}",
                      style: Body1.apply(
                        fontWeightDelta: -1,
                        color: black
                      )),
                  whiteSpaceW(8.0),
                  Text("${DateFormat("yy.MM.dd").format(DateTime.parse(review.date))}",
                      style: Caption),
                  Spacer(),
                  Image.asset(
                    "assets/icon/review/star_full_color.png",
                    width: 16,
                    height: 16,
                  ),
                  whiteSpaceW(4.0),
                  Text("${review.scope}",
                      style: Body2.apply(
                        color: black
                      ))
                ]),
            whiteSpaceH(5),
            Container(
                width: MediaQuery.of(context).size.width,
                child:Text(
                    "${review.contents}",
                    softWrap: true,
                    style: Body2.apply(
                      color: secondary
                    )
                )
            ),
            whiteSpaceH(8),
            Row(
                children: [
                  likeImage(idx,review.id,review.isLike, context),
                  whiteSpaceW(2),
                  Text(
                      "${review.like}",
                      style: Body2
                  ),
                  whiteSpaceW(12),
                  hateImage(idx,review.id, review.isHate, context),
                  whiteSpaceW(2),
                  Text(
                      "${review.hate}",
                      style: Body2
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
        width: 16,
        height: 16,
          color: secondary,
        fit: BoxFit.fill,
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
          width: 16,
          height: 16,
          color: primary
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
        width: 16,
        height: 16,
        color: secondary
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
        width: 16,
        height: 16,
        color: primary,
      )
  );
}

Widget starImage(avg,idx) {
  return (avg >= idx) ?
  Image.asset(
    "assets/icon/star_full_color.png",
    width: 16,
    height: 16,
    color: white,
  )
      :
  Image.asset(
    "assets/icon/star_color.png",
    width: 16,
    height: 16,
    color: white,
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
                      style: Subtitle2
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
                            store.store.comment == null ? "매장 정보가 없습니다" : store.store.comment,
                            style: Body1.apply(
                                color: secondary,
                              fontWeightDelta: -1
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