import 'package:cashcook/src/utils/CustomBottomNavBar.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Recruitment extends StatefulWidget {
  @override
  _Recruitment createState() => _Recruitment();
}

class _Recruitment extends State<Recruitment> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AppBar appbar = AppBar(
      backgroundColor: white,
      title: Text(
        "사업설명회 안내",
        style: appBarDefaultText,
        ),
      centerTitle: true,
      elevation: 2.0,
      leading: IconButton(
      onPressed: () {
          Navigator.of(context).pop();
        },
      icon: Image.asset(
          "assets/resource/public/prev.png",
          width: 24,
          height: 24,
        ),
      ),
    );
    return Scaffold(
      backgroundColor: white,
      appBar: appbar,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - appbar.preferredSize.height - MediaQuery.of(context).padding.top,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  whiteSpaceH(24),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                    child: Text("캐시쿡 그룹",
                      textAlign: TextAlign.center,
                      style: Body1.apply(
                        color: white,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0)
                        )
                    ),
                  ),
                  whiteSpaceH(8),
                  Text("여러분의 성공을 기원합니다.",
                    style: Subtitle1.apply(
                      fontWeightDelta: 2,
                      color: primary
                    )
                  ),
                  whiteSpaceH(16),
                  Text("2021 사업설명회",
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 36,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  whiteSpaceH(35),
                  Image.asset(
                    "assets/resource/main/recruitment.png",
                    width: 269,
                    height: 170
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 66,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 70,
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icon/iconmonstr-time.png",
                            width: 24,
                            height: 24,
                          ),
                          whiteSpaceW(8),
                          Text("매주 평일 PM 00:00 호조그룹 소강당",
                              style: Body1.apply(
                                  color: Color(0xFF505365)
                              )
                          )
                        ],
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0,4),
                              blurRadius: 3,
                              color: Color(0xff888888).withOpacity(0.15),
                            )
                          ],
                          borderRadius: BorderRadius.all(
                              Radius.circular(12.0)
                          )
                      ),
                    ),
                    // whiteSpaceH(16),
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   height: 70,
                    //   child: Row(
                    //     children: [
                    //       Image.asset(
                    //         "assets/icon/iconmonstr-location.png",
                    //         width: 24,
                    //         height: 24,
                    //       ),
                    //       whiteSpaceW(8),
                    //       Text("서울시 금천구 가산디지털1로 145,207호\n"
                    //           "(가산동, 에이스하이엔드3차)",
                    //           style: Body1.apply(
                    //               color: Color(0xFF505365)
                    //           )
                    //       )
                    //     ],
                    //   ),
                    //   margin: EdgeInsets.symmetric(horizontal: 24),
                    //   padding: EdgeInsets.symmetric(horizontal: 16),
                    //   decoration: BoxDecoration(
                    //       color: white,
                    //       boxShadow: [
                    //         BoxShadow(
                    //           offset: Offset(0,4),
                    //           blurRadius: 3,
                    //           color: Color(0xff888888).withOpacity(0.15),
                    //         ),
                    //       ],
                    //     borderRadius: BorderRadius.all(
                    //       Radius.circular(12.0)
                    //     )
                    //   ),
                    // ),
                    whiteSpaceH(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icon/call.png",
                          width: 8,
                          height: 12,
                        ),
                        whiteSpaceW(4),
                        Text("문의 : 070-4350-0318",
                          style: Body1.apply(
                            color: third
                          )
                        )
                      ],
                    ),
                    whiteSpaceH(13),
                  ],
                ),
              )
            ),
            CustomBottomNavBar(context, "mypage")
          ],
        ),
      )
    );
  }
}