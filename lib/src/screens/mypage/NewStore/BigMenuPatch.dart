import 'package:cashcook/src/model/store/menu.dart';
import 'package:cashcook/src/provider/StoreApplyProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BigMenuPatch extends StatefulWidget {
  final BigMenuModel bigMenu;

  BigMenuPatch({this.bigMenu});

  @override
  _BigMenuPatch createState() => _BigMenuPatch();
}

class _BigMenuPatch extends State<BigMenuPatch> {
  TextEditingController nameCtrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameCtrl = TextEditingController(text: widget.bigMenu.name);
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text(
          "${widget.bigMenu.name} 수정",
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
      body: SingleChildScrollView(
        child:Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("대메뉴 명",
                style: Body2
              ),
              Expanded(
                  child: TextFormField(
                    controller: nameCtrl,
                    style: Body1.apply(
                        color: black,
                        fontWeightDelta: 1
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: black, width: 2.0),
                      ),
                    ),
                  )
              ),
              Spacer(),
              Consumer<StoreApplyProvider>(
                builder: (context, sap, _){
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: RaisedButton(
                      elevation: 0,
                      onPressed: (nameCtrl.text != "") ?  () {
                        if(sap.isPatching) {
                          showToast("수정 중 입니다.");
                        } else {
                          sap.patchBigMenu(widget.bigMenu.id, nameCtrl.text).then((value) async
                          {
                            if(value) {
                              showToast("대메뉴가 수정되었습니다.");
                              PaintingBinding.instance.imageCache.clear();

                              Navigator.of(context).pop();
                            }
                            else {
                              showToast("대메뉴 수정에 실패했습니다.");
                              Navigator.of(context).pop();
                            }
                          });
                        }
                      } : null,
                      disabledColor: deActivatedGrey,
                      color: (sap.isPatching) ? deActivatedGrey : primary,
                      child: (sap.isPatching) ?
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
                      Text("수정하기",
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
                  );
                },
              ),
            ],
          ),
        )
      )
    );
  }
}