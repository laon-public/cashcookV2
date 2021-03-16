import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/provider/StoreApplyProvider.dart';
import 'package:cashcook/src/screens/mypage/NewStore/BigMenuApply.dart';
import 'package:cashcook/src/screens/mypage/NewStore/BigMenuPatch.dart';
import 'package:cashcook/src/screens/mypage/NewStore/MenuListPage.dart';
import 'package:cashcook/src/screens/mypage/mypage.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BigMenuListPage extends StatefulWidget {
  final int store_id;

  BigMenuListPage({this.store_id});

  @override
  _BigMenuListPage createState() => _BigMenuListPage();
}

class _BigMenuListPage extends State<BigMenuListPage> {
  bool isDelete = false;
  bool allCheck = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isDelete = false;
    allCheck = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<StoreApplyProvider>(context, listen: false).fetchBigMenu(widget.store_id);
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 12),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top - 60,
              child: Consumer<StoreApplyProvider>(
                builder: (context, ssp, _) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isDelete ?
                            InkWell(
                              onTap: () {
                                ssp.allChange(!allCheck, "bigMenu");
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
                        (ssp.isFetching) ?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate((MediaQuery.of(context).size.height / 40).round(), (index) =>
                            loadingItem(index)
                          ),
                        ) : Container(),
                        Column(
                          children: ssp.bigMenuList.map((e) {
                            int idx = ssp.bigMenuList.indexOf(e);

                            return BigMenuItem(e, idx);
                          }).toList(),
                        ),
                      ],
                    )
                  );
                },
              ),
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
                      onPressed: isDelete ?
                          sap.chkQuantity == 0 ?
                              null
                              :
                          () {
                        if(sap.isDeleting) {
                          showToast("삭제가 진행 중 입니다.");
                        } else {
                          sap.deleteBigMenu().then((value) {
                            if(value) {
                              showToast("선택하신 대메뉴가 삭제되었습니다.");

                              sap.fetchBigMenu(widget.store_id);
                              setState(() {
                                isDelete = false;
                              });
                            } else {
                              showToast("대메뉴 삭제에 실패 하였습니다.");
                            }
                          });
                        }
                      }
                          :
                          () async {
                        await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => BigMenuApply(
                                  storeId: widget.store_id,
                                )
                            )
                        );

                        await Provider.of<StoreApplyProvider>(context, listen: false).fetchBigMenu(widget.store_id);
                      },
                      disabledColor: deActivatedGrey,
                      color: (sap.isDeleting) ? deActivatedGrey : primary,
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
                      Text(isDelete ? "삭제하기" : "대메뉴 추가",
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

  Widget loadingItem(int idx) {
    return Container(
      width: MediaQuery.of(context).size.width - (10 * idx),
      margin: EdgeInsets.only(bottom: 12.0),
      height: 40,
      child: LinearProgressIndicator(
        backgroundColor: Colors.transparent,
        valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFF7F7F7)),
      ),
    );
  }

  Widget BigMenuItem(BigMenuModel bmm, int idx){
    return InkWell(
      onTap: () async {
        if(!isDelete) {
          await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => MenuListPage(
                    bigMenu: bmm,
                  )
              )
          );

          await Provider.of<StoreApplyProvider>(context, listen: false).fetchBigMenu(widget.store_id);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13, horizontal: 16),
        child: Row(
          children: [
            Consumer<StoreApplyProvider>(
              builder: (context, sap, _){
                return AnimatedContainer(
                    width: isDelete ? 20 : 0,
                    height: isDelete ? 16 : 0,
                    duration: Duration(milliseconds: 250),
                    child: Theme(
                      data: ThemeData(unselectedWidgetColor: isDelete ? Color(0xFFDDDDDD) : Colors.transparent,),
                      child:
                      Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: isDelete ? mainColor : Colors.transparent,
                        checkColor: isDelete ? white : Colors.transparent,
                        value: bmm.isCheck,
                        onChanged: (value) {
                          sap.changeBigMenuCheck(value, idx);
                        },
                      ),
                    )
                );
              },
            ),
            AnimatedContainer(
                width: isDelete ? 12 : 0,
                duration: Duration(milliseconds: 250),
            ),
            Text(bmm.name,
                style: Subtitle2.apply(
                    fontWeightDelta: -1
                )
            ),
            whiteSpaceW(6),
            Expanded(
              child: Text(bmm.menuList.length == 0 ? "●"
                  :
              bmm.menuList.length == 1 ?
              bmm.menuList[0].name
                  :
              "${bmm.menuList[0].name} 외 ${bmm.menuList.length -1}개"  ,
                style: bmm.menuList.length == 0 ?
                Body2.apply(
                  color: Colors.red
                )
                :
                Body2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            isDelete ?
                InkWell(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BigMenuPatch(
                          bigMenu: bmm,
                        )
                      )
                    );

                    await Provider.of<StoreApplyProvider>(context, listen: false).fetchBigMenu(widget.store_id);
                  },
                  child: Text("수정",
                    style: Body1.apply(
                        color: primary,
                        fontWeightDelta: 1
                    ),
                  ),
                )
                :
            Icon(Icons.arrow_forward_ios, size: isDelete ? 0 : 16, color: black,),
          ],
        ),
      ),
    );
  }
}