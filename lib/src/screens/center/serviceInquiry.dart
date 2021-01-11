import 'package:cashcook/src/model/Inquiry.dart';
import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/services/Center.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

class Inquiry extends StatefulWidget {
  @override
  _Inquiry createState() => _Inquiry();
}

class _Inquiry extends State<Inquiry> {
  ScrollController _scrollController = ScrollController();
  int currentPage = 0;
  bool isOpen = false;

  inquiryInit() async {
    await centerService.getInquiry(0).then((value) {
      setState(() {
        print("inquiryInit");
      });
  });
}

  loadMore(context) async {
    CenterProvider center = Provider.of<CenterProvider>(context,listen: false);
    if(!center.isLoading){
      if(center.pageing.offset >= center.pageing.count){
        return;
      }
      currentPage++;
      center.startLoading();
      center.fetchInquiry(currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CenterProvider>(context,listen: false).fetchInquiry(currentPage);
    _scrollController.addListener(() {
      if(_scrollController.offset == _scrollController.position.maxScrollExtent)
      loadMore(context);
    });
    AppBar appBar = AppBar(
      title: Text("서비스 문의",
        style: appBarDefaultText,
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
      ),
      centerTitle: true,
      elevation: 1.0,
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: (){
                Navigator.of(context).pushNamed("/inquiry/write").then((value){
                  isOpen = false;
                  inquiryInit();
                });
              },
              child: Text("작성하기",style: TextStyle(fontSize: 14, color: primary,decoration: TextDecoration.underline),),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: white,
      appBar: appBar,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              whiteSpaceH(12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("고객센터",
                      style: Body1.apply(
                        color: third,
                      )
                    ),
                    whiteSpaceH(8),
                    Text("070-4350-0318",
                      style: Subtitle2.apply(
                        color: black,
                        fontWeightDelta: 1
                      )
                    ),
                    whiteSpaceH(4),
                    Text("pehnice@nate.com",
                      style: Body2.apply(
                        color: third
                      )
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 8,
                color: Color(0xFFF7F7F7)
              ),
              Consumer<CenterProvider>(
                builder: (context, cp, _){

                  return Column(
                    children:
                      cp.inquiry.map((e){
                        int idx = cp.inquiry.indexOf(e);
                        return InquiryItem(idx, e);
                      }).toList(),
                  ) ;
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget InquiryItem(idx, inquiry){
    InquiryModel inquiryModel = inquiry;

    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
//              isOpen = !isOpen;
              print("터치확인");
              print(isOpen);
              print(inquiryModel.status);
              if(inquiryModel.status == "ANSWER"){
                changeStatus(context, inquiryModel.id);
                inquiryModel.status = "DONE";
              }
//              setState(() {
//                isOpen = true;
//              });
                Provider.of<CenterProvider>(context,listen: false).setOpen(idx, !inquiry.isOpen);
            },
            child: title(inquiryModel),
          ),
          inquiry.isOpen ? detail(inquiryModel) : SizedBox(),
        ],
      ),
    );
  }

  changeStatus(context, idx) async {
    await centerService.putInquiry(idx).then((value) {
      showToast("읽음");
    });
  }

  Widget title(inquiryModel) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      inquiryModel.title,
                      style: Body1.apply(
                          fontWeightDelta: 2
                      ),
                    ),
//                    Provider.of<CenterProvider>(context).inquiry[0].status == "ANSWER"?
                    inquiryModel.status == "ANSWER"?
                    Image.asset(
                      "assets/icon/n.png",
                      width: 24,
                      fit: BoxFit.contain,
                    ) : Image.asset("assets/icon/n.png",width:0),
                  ],
                ),
                Text(
                  inquiryModel.status == "NOT_ANSWER"? "관리자 확인 전입니다." :
                  inquiryModel.status == "ANSWER"? "답변이 달렸습니다." :
                  inquiryModel.status == "DONE"? "읽은 글입니다." : "알수없음",
                  style: Body1.apply(
                      fontWeightDelta: 2
                  ),
                ),
                Text(
                  inquiryModel.created_at.split("T").first,
                  style: Body2,
                ),
              ],
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF7F7F7),
            width: 1
          )
        )
      ),
    );
  }

  Widget detail(inquiryModel) {
    return Container(
      width: double.infinity,
      color: Color(0xfff7f7f7),
      child: Padding(
        padding:
        const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 24),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/icon/q.png",
                  width: 24,
                  fit: BoxFit.contain,
                ),
                whiteSpaceW(12),
                Text(
                  inquiryModel.title,
                  style: Body2.apply(
                    color: black
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 31),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/icon/a.png",
                    width: 24,
                    fit: BoxFit.contain,
                  ),
                  whiteSpaceW(12),
                  Text(
                    inquiryModel.answer == null? "아직 답이 달리지 않았습니다.": inquiryModel.answer,
                    style: Body2.apply(
                        color: black
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}