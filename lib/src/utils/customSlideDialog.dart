import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/storemanagement/orderMenu.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:slide_popup_dialog/pill_gesture.dart';

class CustomSlideDialog extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final Color pillColor;

  CustomSlideDialog({
    @required this.child,
    @required this.pillColor,
    @required this.backgroundColor,
  });

  @override
  _CustomSlideDialogState createState() => _CustomSlideDialogState();
}

class _CustomSlideDialogState extends State<CustomSlideDialog> {
  var _initialPosition = 0.0;
  var _currentPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          EdgeInsets.only(top: deviceHeight / 8.0 + _currentPosition),
      duration: Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child:
          Consumer<StoreServiceProvider>(
            builder:(context, ss, _) {
              return Center(
                child: Container(
                  width: deviceWidth,
                  height: deviceHeight - 20,
                  child: Material(
                    color: widget.backgroundColor ??
                        Theme.of(context).dialogBackgroundColor,
                    elevation: 24.0,
                    type: MaterialType.card,
                    child:
                    Stack(
                        children: [
                          Column(
                            children: <Widget>[
                              PillGesture(
                                pillColor: white,
                                onVerticalDragStart: _onVerticalDragStart,
                                onVerticalDragEnd: _onVerticalDragEnd,
                                onVerticalDragUpdate: _onVerticalDragUpdate,
                              ),
                              widget.child,
                            ],

                          ),
                          (ss.serviceNum == 0) ?
                          Positioned(
                              bottom: 0,
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  child:
                                  RaisedButton(
                                      color: Colors.cyan,
                                      onPressed: () {
                                        List<BigMenuModel> bigMenus = [];
                                        int orderPay = 0;

                                        ss.menuList.forEach((menu) {
                                          List<MenuModel> menus = menu.menuList.where((m) => m.isCheck).toList();

                                          if(menus != null && menus.length != 0) {
                                            menus.forEach((m) {
                                              m.count = 1;
                                              orderPay += m.price;
                                            });
                                            bigMenus.add(BigMenuModel(
                                                id: menu.id,
                                                name: menu.name,
                                                menuList: menus
                                            ));
                                          }
                                        });

                                        if(bigMenus.length != 0) {
                                          ss.setOrderMenu(bigMenus,orderPay);

                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderMenu(
                                                        name: Provider
                                                            .of<UserProvider>(
                                                            context,
                                                            listen: false)
                                                            .loginUser
                                                            .name,
                                                        store_id: Provider
                                                            .of<StoreProvider>(
                                                            context,
                                                            listen: false)
                                                            .selStore
                                                            .user_id,
                                                      )));
                                        } else {
                                          showToast("메뉴를 한가지 이상 선택해주세요.");
                                        }
                                      },
                                      child: Text(
                                          "주문하기",
                                          style: TextStyle(
                                              color: Colors.white
                                          )
                                      )
                                  )
                              )
                          )
                              :
                              Container()
                        ]
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              );
            }
          )
      ),
    );
  }

  void _onVerticalDragStart(DragStartDetails drag) {
    setState(() {
      _initialPosition = drag.globalPosition.dy;
    });

  }

  void _onVerticalDragUpdate(DragUpdateDetails drag) {
    setState(() {
      final temp = _currentPosition;
      _currentPosition = drag.globalPosition.dy - _initialPosition;
      if (_currentPosition < 0) {
        _currentPosition = temp;
      }
    });
  }

  void _onVerticalDragEnd(DragEndDetails drag) {
    if (_currentPosition > 100.0) {
      Navigator.pop(context);

      return;
    }
    setState(() {
      _currentPosition = 0.0;
    });
  }
}
