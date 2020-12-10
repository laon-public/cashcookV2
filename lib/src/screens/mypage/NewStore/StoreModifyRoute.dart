import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/mypage/NewStore/BigMenuListPage.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
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
        child: Column(
          children: [
              InkWell(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                  child: Row(
                    children: [
                      Text("매장정보 수정",
                          style: Subtitle2.apply(
                              fontWeightDelta: -1
                          )
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
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                child: Row(
                  children: [
                    Text("메뉴정보 수정",
                        style: Subtitle2.apply(
                            fontWeightDelta: -1
                        )
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 16, color: black,)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                child: Row(
                  children: [
                    Text("기타정보 수정",
                        style: Subtitle2.apply(
                            fontWeightDelta: -1
                        )
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