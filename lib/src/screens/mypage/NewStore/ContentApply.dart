import 'dart:io';

import 'package:cashcook/src/model/store/content.dart';
import 'package:cashcook/src/provider/StoreApplyProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ContentApply extends StatefulWidget {
  final int storeId;
  final String comment;

  ContentApply({this.storeId, this.comment});

  @override
  _ContentApply createState() => _ContentApply();
}

class _ContentApply extends State<ContentApply> {
  List<PickedFile> contentsImgList = [];
  TextEditingController contentCtrl = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<StoreApplyProvider>(context, listen: false).fetchContent(widget.storeId);
    });
    setState(() {
      contentCtrl.text = widget.comment;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AppBar appBar = AppBar(
      title: Text("기타정보",
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

    return Scaffold(
      appBar: appBar,
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 16, top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("매장사진 ${contentsImgList.length}/10",
                      style: Body2,
                    ),
                    whiteSpaceH(4),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Consumer<StoreApplyProvider>(
                        builder: (context, sap, _){
                          return Row(
                            children: [
                              (sap.contentsList.length == 0) ? 
                                  Container()
                              :
                                  Row(
                                    children: sap.contentsList.map((e) =>
                                        contentImageItem(e)
                                    ).toList(),
                                  ),
                              Row(
                                children: contentsImgList.map((e) =>
                                    imageItem(e)
                                ).toList(),
                              ),
                              imagePlusItem(),
                            ],
                          );
                        },
                      ),
                    ),
                    whiteSpaceH(20),
                    Text("매장 설명",
                      style: Body2,
                    ),
                  ],
                ),
              ),
              whiteSpaceH(4),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: deActivatedGrey
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 8),
                  child: Theme(
                    data: ThemeData(
                      highlightColor: deActivatedGrey,
                    ),
                    child: Scrollbar(
                      child: TextFormField(
                        maxLength: 100,
                        maxLines: 50,
                        controller: contentCtrl,
                        style: Subtitle1.apply(
                          fontWeightDelta: 1
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 28,),
                          border: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.transparent),
                          ),
                          counterStyle: TabsTagsStyle,
                        ),
                      ),
                    ),
                  )
                )
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: RaisedButton(
                  color: primary,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(6.0)
                    ),
                  ),
                  onPressed: () {
                      Provider.of<StoreApplyProvider>(context, listen: false).patchContent(widget.storeId, contentsImgList);
                  },
                  child: Text("수정하기",
                      style: Subtitle2.apply(
                          color: white,
                          fontWeightDelta: 1
                      )
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  Widget contentImageItem(ContentModel content) {
    return InkWell(
      onTap: () {
      },
      child: Container(
        margin: EdgeInsets.only(right: 8.0),
        width: 104,
        height: 104,
        decoration: BoxDecoration(
            color: Color(0xFFF7F7F7),
            borderRadius: BorderRadius.all(
                Radius.circular(4)
            ),
            border: Border.all(
                color: Color(0xFFDDDDDD),
                width: 1
            ),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                content.imgUrl
              ),
            )
        ),
      ),
    );
  }

  Widget imageItem(PickedFile img) {
    return InkWell(
      onTap: () {
        int idx = contentsImgList.indexOf(img);

        setState(() {
          contentsImgList.removeAt(idx);
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 8.0),
        width: 104,
        height: 104,
        decoration: BoxDecoration(
            color: Color(0xFFF7F7F7),
            borderRadius: BorderRadius.all(
                Radius.circular(4)
            ),
            border: Border.all(
                color: Color(0xFFDDDDDD),
                width: 1
            ),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: FileImage(
                File(img.path)
              ),
            )
        ),
      ),
    );
  }

  Widget imagePlusItem() {
    return InkWell(
      onTap: () async {
        PickedFile pickedImg = await ImagePicker().getImage(source: ImageSource.gallery);

        if(pickedImg != null) {
          setState(() {
            contentsImgList.add(pickedImg);
          });

        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 8.0),
        width: 104,
        height: 104,
        child: Center(
            child: Image.asset(
              "assets/icon/plus.png",
              width: 36,
              height: 36,
            )
        ),
        decoration: BoxDecoration(
            color: Color(0xFFF7F7F7),
            borderRadius: BorderRadius.all(
                Radius.circular(4)
            ),
            border: Border.all(
                color: Color(0xFFDDDDDD),
                width: 1
            )
        ),
      ),
    );
  }
}