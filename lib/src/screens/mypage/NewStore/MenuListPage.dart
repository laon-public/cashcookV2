import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/provider/StoreApplyProvider.dart';
import 'package:cashcook/src/screens/mypage/NewStore/MenuApply.dart';
import 'package:cashcook/src/screens/mypage/NewStore/MenuPatch.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuListPage extends StatefulWidget {
  final BigMenuModel bigMenu;

  MenuListPage({this.bigMenu});

  @override
  _MenuListPage createState() => _MenuListPage();
}

class _MenuListPage extends State<MenuListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<StoreApplyProvider>(context, listen: false).fetchMenu(widget.bigMenu.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text(
          widget.bigMenu.name,
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
              Consumer<StoreApplyProvider>(
                builder: (context, sap, _){
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Column(
                                children: sap.menuList.map((e) =>
                                    MenuItem(e)
                                ).toList()
                            ),
                            whiteSpaceH(60)
                          ],
                        )
                      )
                  );
                },
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: RaisedButton(
                    elevation: 0,
                    onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MenuApply(
                              bigId: widget.bigMenu.id,
                            )
                          )
                        );

                        await Provider.of<StoreApplyProvider>(context, listen: false).fetchMenu(widget.bigMenu.id);
                    },
                    color: primary,
                    child: Text("메뉴 추가",
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

  Widget MenuItem(MenuModel menu) {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MenuPatch(
              menu: menu,
            )
          )
        );

        await Provider.of<StoreApplyProvider>(context, listen: false).fetchMenu(widget.bigMenu.id);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            (menu.imgUrl == null) ?
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: deActivatedGrey,
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0)
                ),
                border: Border.all(
                  color: Color(0xFFDDDDDD),
                  width: 0.5
                ),
              ),
            )
            :
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(12.0)
                  ),
                  border: Border.all(
                      color: Color(0xFFDDDDDD),
                      width: 0.5
                  ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    menu.imgUrl,
                  )
                )
              ),
            ),
            whiteSpaceW(16.0),
            Expanded(
              child: Text(menu.name,
                style: Body1.apply(
                    color: black,
                    fontWeightDelta: 1
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              "${numberFormat.format(menu.price)}원",
              style: Body1.apply(
                color: secondary,
                fontWeightDelta: 1
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF7F7F7), width: 1)
          )
        ),
      ),
    );
  }
}