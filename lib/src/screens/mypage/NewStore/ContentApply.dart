import 'dart:io';

import 'package:cashcook/src/model/store.dart';
import 'package:cashcook/src/model/store/content.dart';
import 'package:cashcook/src/provider/StoreApplyProvider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/showToast.dart';
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

  bool isDelete = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<StoreApplyProvider>(context, listen: false).fetchContent(widget.storeId);
    });
      contentCtrl.text = widget.comment;
      isDelete = false;
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

    return Consumer<StoreApplyProvider>(
      builder: (context, sap, _){
        return Stack(
          children: [
              Scaffold(
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
                            Text("성공스토어 사진 ${contentsImgList.length + sap.contentsList.length}/10",
                              style: Body2,
                            ),
                            whiteSpaceH(4),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    (sap.isContentFetch) ?
                                    customLinearLoading() : Container(),
                                    (sap.contentsList.length == 0) ?
                                    Container()
                                        :
                                    Row(
                                        children: List.generate(sap.contentsList.length, (index) =>
                                            contentImageItem(sap.contentsList[index], index)
                                        )
                                    ),
                                    Row(
                                      children: contentsImgList.map((e) =>
                                          imageItem(e)
                                      ).toList(),
                                    ),
                                    (contentsImgList.length + sap.contentsList.length < 10) ?
                                    imagePlusItem()
                                        :
                                    Container(),
                                  ],
                                )
                            ),
                            whiteSpaceH(20),
                            Text("성공스토어 설명",
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
                          color: (sap.isContenting) ? deActivatedGrey : primary,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(6.0)
                            ),
                          ),
                          onPressed: () {
                            if(sap.isContenting) {
                              showToast("정보 수정이 진행 중 입니다.");
                              return;
                            } else {
                              String updateContent = "";
                              if(contentCtrl.text != widget.comment) {
                                updateContent = contentCtrl.text;
                              }
                              sap.patchContent(widget.storeId, updateContent, contentsImgList).then((value) async {
                                if(value) {
                                  showToast("기타 정보가 수정되었습니다.");

                                  setState(() {
                                    contentsImgList = [];
                                  });

                                  PaintingBinding.instance.imageCache.clear();
                                  await sap.fetchContent(widget.storeId);
                                } else {
                                  showToast("기타 정보 수정이 실패했습니다.");
                                }
                              });
                            }
                          },
                          child: sap.isContenting ?
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
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ),
            (sap.isContentDeleting) ? Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: SafeArea(
                    child: Container(
                      child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 3 / 4,
                            height: MediaQuery.of(context).size.height * 2 / 4,
                            child: Center(
                            child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(mainColor)
                              )
                            ),
                            decoration: BoxDecoration(
                                color: white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0)
                              )
                            ),
                          )
                      ),
                      decoration: BoxDecoration(
                          color: black.withOpacity(0.7)
                      ),
                    ),
                  )
              ),
            )
                : Container()
          ],
        );
      },
    );
  }

  Widget customLinearLoading() {
    return Row(
      children: List.generate(((MediaQuery.of(context).size.width + 104) / 104).round() , (index) =>
          Container(
            margin: EdgeInsets.only(right: 8.0),
            width: 104,
            height: 104,
            child: LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFF7F7F7)),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(4)
              ),
              border: Border.all(
                  color: Color(0xFFDDDDDD),
                  width: 1
              ),
            ),
          )
      ),
    );
  }

  Widget contentImageItem(ContentModel content, int index) {
    return InkWell(
      onTap: () async {
          await Provider.of<StoreApplyProvider>(context, listen: false).updateImg(index,
              await ImagePicker().getImage(source: ImageSource.gallery)
          );
      },
      child: Container(
        margin: EdgeInsets.only(right: 8.0),
        width: 104,
        height: 104,
        child: Stack(
          children: [
            Positioned(
              top:0,
              right:0,
              child: InkWell(
                onTap: () {
                  Provider.of<StoreApplyProvider>(context, listen: false).deleteContent(content.id).then((value) {
                    if(value) {
                      Provider.of<StoreApplyProvider>(context, listen: false).fetchContent(widget.storeId);

                      showToast("사진이 삭제되었습니다.");
                    } else {
                      showToast("사진 삭제에 실패했습니다.");
                    }
                  });
                },
                child: Container(
                  child: Image.asset(
                    "assets/icon/contentDel.png",
                    width: 28,
                    height: 28,
                  ),
                ),
              )
            )
          ],
        ),
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
              image: (content.updateFile == null) ? NetworkImage(
                content.imgUrl
              )
              :
                  FileImage(
                    File(content.updateFile.path)
                  )
              ,
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