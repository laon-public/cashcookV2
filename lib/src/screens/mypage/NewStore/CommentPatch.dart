import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/provider/StoreProvider.dart';
import 'package:cashcook/src/provider/StoreServiceProvider.dart';
import 'package:cashcook/src/provider/UserProvider.dart';
import 'package:cashcook/src/screens/main/mainmap.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CommentPatch extends StatefulWidget{
  @override
  _CommentPatch createState() => _CommentPatch();
}

class _CommentPatch extends State<CommentPatch> {
  TextEditingController commentCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StoreModel store = Provider.of<UserProvider>(context,listen: false).storeModel;

    commentCtrl.text = store.store.comment;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: Text(
          "기타정보",
          style: appBarDefaultText,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("기타정보",
                    style: Body2
                ),
                whiteSpaceH(10),
                TextFormField(
                  autofocus: false,
                  maxLines: 6,
                  controller: commentCtrl,
                  style: Subtitle2.apply(
                      fontWeightDelta: -1
                  ),
                  decoration: InputDecoration(
                      hintText: '기타 정보를 입력하여주세요.(원산지 표시 등)',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:Colors.black
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:mainColor
                          )
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:40.0),
                  child: nextBtn(context),
                )
              ]
          ),
        ),
      )
    );
  }

  Widget nextBtn(context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 8),
      child:
      Consumer<StoreServiceProvider>(
        builder: (context, ssp, _) {
          return RaisedButton(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(6.0)
                )
            ),
            onPressed: () async {
              StoreModel store = Provider.of<UserProvider>(context,listen: false).storeModel;

              Map<String, String> data = {};

              if(store.store.comment == commentCtrl.text) {
                showToast("변경된 정보가 없습니다.");
                return;
              }

              data["comment"] = commentCtrl.text;

              bool isReturn = await Provider.of<StoreProvider>(context,listen: false).patchStore(data, "");

              if(isReturn){
                Fluttertoast.showToast(msg: "가맹점 수정이 성공하였습니다.");
                PaintingBinding.instance.imageCache.clear();
              }else {
                Fluttertoast.showToast(msg: "가맹점 수정이 실패하였습니다.");

              }

              await Provider.of<StoreProvider>(context, listen: false).clearMap();
              await Provider.of<StoreProvider>(context, listen: false).hideDetailView();
              await Provider.of<UserProvider>(context, listen: false).fetchMyInfo();

              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainMap()), (route) => false);
            },
            child: Text("수정",
              style: Subtitle2.apply(
                  color: white,
                  fontWeightDelta: 1
              ),
            ),
            color: mainColor,
          );
        },
      ),
    );
  }
}