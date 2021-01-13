import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:cashcook/src/utils/Share.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfomation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: white,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Image.asset(
          "assets/resource/public/close.png",
          width: 24,
          height: 24,
        ),
      ),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: (){
                onKakaoShare();
              },
              child: Text("공유",style:
              Body1.apply(
                  decoration: TextDecoration.underline,
                  color: primary
              ),), //오른쪽 상단에 텍스트 출력
            ),
          ),
        ),
      ],
    );
    return Scaffold(
      backgroundColor: white,
      appBar: appBar,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Consumer<CenterProvider>(
                    builder: (context, cp, _){
                      return Column(
                        children: [
                          whiteSpaceH(40),
                          Image.asset(
                              "assets/icon/app-icon.png",
                              width: 80,
                              height: 80
                          ),
                          whiteSpaceH(24),
                          Text("현재버전 : V.${cp.phoneVersion}",
                            style: Body1.apply(
                                fontWeightDelta: 3,
                                color: black
                            ),
                          ),
                          Text("최신버전 : V.${cp.appVersion}",
                            style: Body1.apply(
                                fontWeightDelta: 3,
                                color: black
                            ),
                          ),
                          whiteSpaceH(14),
                          cp.phoneVersion == cp.appVersion ?
                              Container()
                          :
                            Text("업데이트",
                              style: Body1.apply(
                                  color: primary,
                                  decoration: TextDecoration.underline
                              ),
                            ),
                          whiteSpaceH(44),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "캐시쿡 그룹",
                    style: Subtitle2.apply(
                      fontWeightDelta: 3,
                    )
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFF7F7F7),
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFFEEEEEE),
                        width: 1
                      )
                    )
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text("상호명",
                              style: Body1.apply(
                                color: third,
                              )
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text("주식회사 캐시쿡그룹",
                              style: Body1.apply(
                                color: Color(0xFF555555)
                              ),
                            ),
                          )
                        ],
                      ),
                      whiteSpaceH(12),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text("대표자",
                                style: Body1.apply(
                                  color: third,
                                )
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text("장수진",
                              style: Body1.apply(
                                  color: Color(0xFF555555)
                              ),
                            ),
                          )
                        ],
                      ),
                      whiteSpaceH(12),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text("사업자",
                                style: Body1.apply(
                                  color: third,
                                )
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text("838-86-01766",
                              style: Body1.apply(
                                  color: Color(0xFF555555)
                              ),
                            ),
                          )
                        ],
                      ),
                      whiteSpaceH(12),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text("통신판매업",
                                style: Body1.apply(
                                  color: third,
                                )
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text("제 2020-서울금천-0470호",
                              style: Body1.apply(
                                  color: Color(0xFF555555)
                              ),
                            ),
                          )
                        ],
                      ),
                      whiteSpaceH(12),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text("연락처",
                                style: Body1.apply(
                                  color: third,
                                )
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text("070-4350-0318",
                              style: Body1.apply(
                                  color: Color(0xFF555555)
                              ),
                            ),
                          )
                        ],
                      ),
                      whiteSpaceH(12),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text("팩스번호",
                                style: Body1.apply(
                                  color: third,
                                )
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text("0303-3441-0003",
                              style: Body1.apply(
                                  color: Color(0xFF555555)
                              ),
                            ),
                          )
                        ],
                      ),
                      whiteSpaceH(12),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text("이메일",
                                style: Body1.apply(
                                  color: third,
                                )
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text("pehnice@nate.com",
                              style: Body1.apply(
                                  color: Color(0xFF555555)
                              ),
                            ),
                          )
                        ],
                      ),
                      whiteSpaceH(12),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text("주소",
                                style: Body1.apply(
                                  color: third,
                                )
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text("서울 금천구 가산디지털1로 149\n"
                              "1104호(가산동, 신한이노플렉스)",
                              style: Body1.apply(
                                  color: Color(0xFF555555)
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
          ),
        )
    );
  }
}
