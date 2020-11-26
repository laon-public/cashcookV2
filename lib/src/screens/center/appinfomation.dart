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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<CenterProvider>(context, listen: false).getAppInfo();
    });
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
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
      ),
        body: Center(
            child:
            Consumer<CenterProvider>(
              builder: (context, cp, _){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,  //center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 150),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Color(0xFFDDDDDD))
                      ),
                      child:
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: Image.asset('assets/icon/mini_logo.png', fit: BoxFit.cover,),
                      ),
                    ),
                    whiteSpaceH(20.0),
                    Text('현재버전 : V.${cp.phoneVersion}',
                        style: Body1.apply(
                          fontWeightDelta: 2
                        )
                    ),
                    (cp.phoneVersion == cp.appVersion) ?
                        Text("최신버전을 사용 중 입니다.",
                          style: Body1
                        )
                        :
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('최신버전 : ',
                                style: Body1.apply(
                                    fontWeightDelta: 2
                                )
                            ),
                            Text("V.${cp.appVersion}",
                              style: Body1.apply(
                                color: primary,
                                  fontWeightDelta: 2
                              ),)
                          ],
                        ),
                    whiteSpaceH(20.0),
                    (cp.phoneVersion != cp.appVersion) ?
                          InkWell(
                          onTap: (){
                            launch(
                                "https://play.google.com/store/apps/details?id=com.hozo.cashcook.cashcook"
                            );
                          },
                          child: Text("업데이트",style:
                          Body1.apply(
                            color: primary,
                              fontWeightDelta: 2,
                            decoration: TextDecoration.underline
                          ),))
                    :
                      Container()
                  ],
                );
              },
            )
        ));
  }
}
