import 'package:cashcook/src/provider/StoreApplyProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BigMenuApply extends StatefulWidget {
  final int storeId;

  BigMenuApply({this.storeId});

  @override
  _BigMenuApply createState() => _BigMenuApply();
}

class _BigMenuApply extends State<BigMenuApply> {
  TextEditingController nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text(
          "대메뉴 추가",
          style: appBarDefaultText
      ),
      centerTitle: true,
      elevation: 0.5,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Image.asset("assets/resource/public/close.png", width: 24, height: 24, color: black,),
      ),
    );
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 12, left: 16, right: 16),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("대메뉴 명",
                style: Body2
              ),
              whiteSpaceH(4),
              TextFormField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffdddddd), width: 1.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: black, width: 2.0),
                  ),
                ),
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
                      onPressed: (nameCtrl.text != "") ? () {
                        if(sap.isPosting) {
                          showToast("메뉴 추가를 진행 중 입니다.");
                        } else {
                          sap.postBigMenu(widget.storeId, nameCtrl.text).then((value) {
                            if (value) {
                              showToast("${nameCtrl.text}가 추가 되었습니다.");
                              Navigator.of(context).pop();
                            } else {
                              showToast("대메뉴 추가에 실패했습니다.");
                              Navigator.of(context).pop();
                            }
                          });
                        }
                      } : null,
                      disabledColor: deActivatedGrey,
                      color: sap.isPosting ? deActivatedGrey : primary,
                      child:
                      sap.isPosting ?
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
                      Text("대메뉴 추가",
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
        ),
      ),
    );
  }
}