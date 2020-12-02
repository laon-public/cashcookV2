import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/screens/mypage/NewStore/menuApply2.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuApply extends StatefulWidget {
  final int store_id;

  MenuApply({this.store_id});

  @override
  _MenuApply createState() => _MenuApply();
}

class _MenuApply extends State<MenuApply> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<StoreServiceProvider>(context, listen: false).fetchMenu(widget.store_id);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text(
          "메뉴관리",
          style: appBarDefaultText
      ),
      centerTitle: true,
      elevation: 0.5,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24, color: black,),
      ),
    );
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      appBar: appBar,
      body: Container(
        padding: EdgeInsets.only(
          top: 12
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top - 60,
              child: Consumer<StoreServiceProvider>(
                builder: (context, ssp, _) {
                  return SingleChildScrollView(
                    child: Column(
                      children: ssp.menuList.map((e) =>
                        BigMenuItem(e)
                      ).toList(),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: RaisedButton(
                  elevation: 0,
                  onPressed: () {},
                  color: primary,
                  child: Text("대메뉴 추가",
                    style: Subtitle2.apply(
                      color: white,
                      fontWeightDelta: 1
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6)
                    )
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  Widget BigMenuItem(BigMenuModel bmm){
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MenuApplySecond(
              bigMenu: bmm,
            )
          )
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13, horizontal: 16),
        child: Row(
          children: [
            Text(bmm.name,
                style: Subtitle2.apply(
                    fontWeightDelta: -1
                )
            ),
            whiteSpaceW(6),
            Expanded(
              child: Text(bmm.menuList.length == 0 ? "빨간점"
                  :
              bmm.menuList.length == 1 ?
              bmm.menuList[0].name
                  :
              "${bmm.menuList[0].name} 외 ${bmm.menuList.length -1}개"  ,
                style: Body2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: black,)
          ],
        ),
      ),
    );
  }
}