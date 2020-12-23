import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
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
          padding: EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
          child: SingleChildScrollView(
            child: Text.rich(
              TextSpan(
                style: Body2.apply(
                  color: secondary
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: "실시간 스토어 할인 앱, 캐시쿡\n\n",
                      style: Body2.apply(
                          color: secondary,
                      fontWeightDelta: 1
                    )
                  ),
                  TextSpan(
                      text: "▶ 캐시쿡은 소비가 소득이 되도록 지원하는 모바일 쇼핑 어플리케이션입니다.\n",
                      style: Body2.apply(
                          color: secondary,
                          fontWeightDelta: 1
                      )
                  ),
                  TextSpan(
                      text: "온·오프라인  쇼핑 시 캐시쿡 앱을 활용하여 결제 후 캐시백 할인을 요청하면, 최소 10%~최대 100%까지 할인받을 수 있습니다.\n"
                          "할인율만큼 가상화폐 디엘(DL)을 지급받습니다.\n"
                          "- 1디엘(DL)은 100원의 가치가 있습니다.\n"
                          "- 디엘(DL)은 캐시쿡에 등록된 온라인 제휴업체 결제, 오프라인 제휴업체 직접 결제, 배달결제 시 현금처럼 사용할수있습니다.\n\n"
                  ),
                  TextSpan(
                      text: "▶ 캐시쿡 실시간 할인은 캐시쿡 앱으로 결제하면 곧바로 이용할 수 있습니다.\n",
                      style: Body2.apply(
                          color: secondary,
                          fontWeightDelta: 1
                      )
                  ),
                  TextSpan(
                      text: "매장에서 직접 결제할 시에는 QR 코드를 발급받아야 실시간 할인을 이용할 수 있습니다.\n"
                          "캐시쿡 실시간 할인은 결제 후 7일 이내까지 가능합니다.\n\n"
                  ),
                  TextSpan(
                    text: "▶ 최초 회원 가입 시 100캐럿을 적립해드립니다.(오픈 이벤트)\n",
                      style: Body2.apply(
                          color: secondary,
                          fontWeightDelta: 1
                      )
                  ),
                  TextSpan(
                    text : "캐시쿡을 지인에게 홍보하면 10캐럿을 적립해드립니다.(오픈 이벤트)\n"
                      "캐럿은 실시간 캐시백 할인 요청시 사용할 수 있습니다.\n"
                      "1캐럿은 100원의 가치로 사용할 수 있습니다.\n\n"
                  ),
                  TextSpan(
                    text: "▶ 캐시쿡 회원은 소비가 소득이 됩니다.\n",
                      style: Body2.apply(
                          color: secondary,
                          fontWeightDelta: 1
                      )
                  ),
                  TextSpan(
                    text: "내가 결제한 금액의 최대 100%까지 디엘(DL) 적립\n"
                        "공유 회원의 결제금액에 따라 캐시쿡 포인트(CP) 적립\n"
                        "- 적립된 캐시쿡 포인트(CP)로 디엘(DL) 구매\n"
                        "가상화폐 디엘(DL)은 현금처럼 결제수단으로 사용\n\n",
                  ),
                  TextSpan(
                    text: "▶ 스마트 월렛 & 디엘(DL) 중개소 캐시링크에서 디엘(DL)을 거래할 수 있습니다.\n",
                      style: Body2.apply(
                          color: secondary,
                          fontWeightDelta: 1
                      )
                  ),
                  TextSpan(
                    text: "캐시쿡 회원은 디엘(DL) 거래로 수익을 창출할 수 있습니다.\n\n\n\n"
                  ),
                  TextSpan(
                    text: "결제하고 할인받고, 공유하고 캐럿 받고,\n"
                        "공유회원이 결제할 때마다 또 캐시쿡 포인트 받는다!\n"
                        "소비가 소득이 되는 실시간 스토어 할인 앱, 캐시쿡\n\n\n",
                      style: Body2.apply(
                          color: secondary,
                          fontWeightDelta: 1
                      )
                  ),
                  TextSpan(
                    text: "캐시쿡 CashCook\n",
                      style: Body2.apply(
                          color: secondary,
                          fontWeightDelta: 1
                      )
                  ),
                  TextSpan(
                    text: "상호명 : 주식회사 캐시쿡그룹\n"
                        "사업자 등록번호 : 838-86-01766\n"
                        "대표자 : 장수진\n"
                        "주소 : 서울시 금천구 가산디지털 1로 145, 207호\n"
                        "연락처 : T) 070-4350-0318\n"
                  )
                ]
              )
            )
          ),
        )
    );
  }
}
