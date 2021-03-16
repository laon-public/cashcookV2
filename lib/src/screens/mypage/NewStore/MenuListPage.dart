import 'package:cached_network_image/cached_network_image.dart';
import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/provider/StoreApplyProvider.dart';
import 'package:cashcook/src/screens/mypage/NewStore/MenuApply.dart';
import 'package:cashcook/src/screens/mypage/NewStore/MenuPatch.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/numberFormat.dart';
import 'package:cashcook/src/widgets/showToast.dart';
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
  bool isDelete = false;
  bool allCheck = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isDelete = false;
    allCheck = false;
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
      actions: [
        InkWell(
          onTap: () {
            setState(() {
              isDelete = !isDelete;
            });
          },
          child: Container(
              padding: EdgeInsets.only(right: 15),
              child: Center(
                child: Text(isDelete ? "완료" : "편집",
                  style: Body1.apply(
                    color: secondary,
                    fontWeightDelta: 1,
                  ),
                ),
              )
          ),
        )
      ],
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isDelete ?
                            InkWell(
                              onTap: () {
                                sap.allChange(!allCheck, "menu");
                                setState(() {
                                  allCheck = !allCheck;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                child: Text("전체선택",
                                  style: Body1.apply(
                                      color: primary,
                                      fontWeightDelta: 1
                                  ),
                                ),
                              ),
                            )
                                : Container(),
                            Column(
                                children: sap.menuList.map((e) {
                                  int idx = sap.menuList.indexOf(e);

                                  return MenuItem(e,idx);
                                }).toList()
                            ),
                            whiteSpaceH(60)
                          ],
                        )
                      )
                  );
                },
              ),
              Consumer<StoreApplyProvider>(
                builder: (context, sap, _){
                  return Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: RaisedButton(
                        elevation: 0,
                        onPressed:isDelete ?
                        sap.chkQuantity == 0 ?
                        null
                            :
                            () {
                          if(sap.isDeleting){
                            showToast("삭제가 진행 중 입니다.");
                          } else {
                            sap.deleteMenu().then((value) {
                              if(value) {
                                showToast("선택하신 메뉴가 삭제되었습니다.");

                                sap.fetchMenu(widget.bigMenu.id);
                                setState(() {
                                  isDelete = false;
                                });
                              } else {
                                showToast("메뉴 삭제에 실패 하였습니다.");
                              }
                            });
                          }
                        }
                            :
                            () async {
                          await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => MenuApply(
                                    bigId: widget.bigMenu.id,
                                  )
                              )
                          );

                          await Provider.of<StoreApplyProvider>(context, listen: false).fetchMenu(widget.bigMenu.id);
                        },
                        color: (sap.isDeleting) ? deActivatedGrey : primary,
                        disabledColor: deActivatedGrey,
                        child:
                        (sap.isDeleting) ?
                        Center(
                          child: Container(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
                              )
                          ),
                        )
                            :
                        Text(isDelete ? "삭제하기" : "메뉴 추가",
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
                  );
                },
              )

            ],
          )
      ),
    );
  }

  Widget MenuItem(MenuModel menu, int idx) {
    return InkWell(
      onTap: () async {
        if(!isDelete) {
          await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      MenuPatch(
                        menu: menu,
                      )
              )
          );

          await Provider.of<StoreApplyProvider>(context, listen: false)
              .fetchMenu(widget.bigMenu.id);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Consumer<StoreApplyProvider>(
              builder: (context, sap, _){
                return AnimatedContainer(
                    width: isDelete ? 20 : 0,
                    height: isDelete ? 16 : 0,
                    duration: Duration(milliseconds: 300),
                    child: Theme(
                      data: ThemeData(unselectedWidgetColor: isDelete ? Color(0xFFDDDDDD) : Colors.transparent,),
                      child:
                      Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: isDelete ? primary : Colors.transparent,
                        checkColor: isDelete ? white : Colors.transparent,
                        value: menu.isCheck,
                        onChanged: (value) {
                          sap.changeMenuCheck(value, idx);
                        },
                      ),
                    )
                );
              },
            ),
            AnimatedContainer(
              width: isDelete ? 12 : 0,
              duration: Duration(milliseconds: 300),
            ),
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
                image: DecorationImage(
                  scale: 2,
                  image: AssetImage(
                    "assets/resource/public/close.png",
                  )
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
            ),
            isDelete ?
                Row(
                  children: [
                    whiteSpaceW(16),
                    InkWell(
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
                      child: Text("수정",
                        style: Body1.apply(
                            color: primary,
                            fontWeightDelta: 1
                        ),
                      ),
                    )
                  ],
                )
            : Container()
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