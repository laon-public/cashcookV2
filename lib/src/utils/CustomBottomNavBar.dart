import 'package:cashcook/src/screens/main/home.dart';
import 'package:cashcook/src/screens/main/search.dart';
import 'package:cashcook/src/screens/mypage/info/scrap.dart';
import 'package:cashcook/src/screens/mypage/info/serviceList.dart';
import 'package:cashcook/src/screens/mypage/mypage.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/utils/pageMoving.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';

Widget CustomBottomNavBar(BuildContext context, String pageName) {
  return Positioned(
    bottom: 0,
    left: 0,
    child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
                color: deActivatedGrey,
              blurRadius: 3
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  if(pageName != "scrap") {
                    pushSlideMove(Scrap(
                      isHome: true,
                    ), context, 1);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/resource/main/steam.png",
                      width: 24,
                      height: 24,
                      color: pageName == "scrap" ? mainColor : null,
                    ),
                    whiteSpaceH(4),
                    Text(
                      "찜",
                      style: TabsTagsStyle,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  if(pageName != "search") {
                    pushSlideMove(SearchPage(), context, 1);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icon/search.png",
                      width: 24,
                      height: 24,
                    ),
                    whiteSpaceH(4),
                    Text(
                      "검색",
                      style: TabsTagsStyle,
                    )
                  ],
                ),
              ),
            ),
            Container(
                width: 60,
                height: 60,
                transform: Matrix4.translationValues(0.0, pageName == "home" ? -6.0 : -12.0, 0.0),
                decoration: BoxDecoration(
                  color: pageName == "home" ? null : white,
                  shape: BoxShape.circle,
                  boxShadow: pageName == "home" ? null : [
                    BoxShadow(
                      offset: Offset(3,3),
                      blurRadius: 3,
                      color: Color(0xff888888).withOpacity(0.15),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    if(pageName != "home") {
                      removeSlideMove(Home(), context, 1);
                    }
                  },
                  child: Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/icon/home_icon.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Center(
                        child: Text(
                          "COOK",
                          style: TabsTagsStyle.apply(
                            fontWeightDelta: 1,
                            color: white
                          ),
                        ),
                      )
                    ],
                  ),
                )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  if(pageName != "pointmgmt") {
                    pushSlideMove(ServiceList(
                      isHome: true,
                    ), context, 1);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icon/list.png",
                      width: 24,
                      height: 24,
                      color: pageName == "pointmgmt" ? mainColor : null,
                    ),
                    whiteSpaceH(4),
                    Text(
                      "이용내역",
                      style: TabsTagsStyle,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  if(pageName != "mypage") {
                    pushSlideMove(MyPage(
                      isHome: true,
                    ), context, 1);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icon/mypage.png",
                      width: 24,
                      height: 24,
                      color: pageName == "mypage" ? mainColor : null,
                    ),
                    whiteSpaceH(4),
                    Text(
                      "마이",
                      style: TabsTagsStyle,
                    )
                  ],
                ),
              ),
            ),
          ],
        )
    ),
  );
}