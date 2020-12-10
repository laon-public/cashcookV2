import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/mypage/NewStore/BigMenuListPage.dart';
import 'package:cashcook/src/screens/mypage/NewStore/CommentPatch.dart';
import 'package:cashcook/src/screens/mypage/NewStore/StorePatch.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreModifyRoute extends StatefulWidget {
  @override
  _StoreModifyRoute createState() => _StoreModifyRoute();
}

class _StoreModifyRoute extends State<StoreModifyRoute> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("매장정보 수정",
            style: appBarDefaultText
          ),
          leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
            icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => StorePatch()
                    )
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("매장 기본 정보",
                            style: Subtitle2.apply(
                                fontWeightDelta: -1
                            )
                        ),
                        whiteSpaceH(4),
                        Text("기본 영업 정보 및 대표사진 관리",
                            style: Body2.apply(
                              color: secondary,
                            )
                        )
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 16, color: black,)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => CommentPatch()
                    )
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("매장 기타 정보",
                            style: Subtitle2.apply(
                                fontWeightDelta: -1
                            )
                        ),
                        whiteSpaceH(4),
                        Text("기타 매장 사진 및 기타 추가 정보 관리",
                            style: Body2.apply(
                              color: secondary,
                            )
                        )
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 16, color: black,)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => BigMenuListPage(
                          store_id: Provider.of<UserProvider>(context, listen:false).storeModel.id,
                        )
                    )
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("매장 메뉴 수정",
                            style: Subtitle2.apply(
                                fontWeightDelta: -1
                            )
                        ),
                        whiteSpaceH(4),
                        Text("매장 메뉴 및 분류 및 메뉴관리",
                            style: Body2.apply(
                              color: secondary,
                            )
                        )
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 16, color: black,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}