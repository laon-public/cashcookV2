import 'package:cashcook/src/model/Inquiry.dart';
import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Inquiry extends StatelessWidget {
  ScrollController _scrollController = ScrollController();
  int currentPage = 0;

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
    print("값확인");
    print(center);
  }

  @override
  Widget build(BuildContext context) {
    print("시작");
    Provider.of<CenterProvider>(context,listen: false).fetchInquiry(currentPage);
    _scrollController.addListener(() {
      if(_scrollController.offset == _scrollController.position.maxScrollExtent)
        print("loadMore");
        loadMore(context);
    });
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text("서비스 문의"),
        centerTitle: true,
        elevation: 1.0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).pushNamed("/inquiry/write");
                },
                child: Text("작성하기",style: TextStyle(fontSize: 14, color: mainColor,decoration: TextDecoration.underline),),
              ),
            ),
          ),
        ],
      ),
      body: body(),
    );
  }

  Widget body() {
    return InquiryList();
  }

  Widget InquiryList() {
    return Consumer<CenterProvider>(
      builder: (context, center, _){
        print("builder");
        return ListView.builder(
          itemBuilder: (context, idx) {
            if(idx < center.inquiry.length){
              print(center.inquiry[idx].status);
              print(center.inquiry[idx].title);
              return InquiryItem(center.inquiry[idx]);
            }
            return Center(
                child: CircularProgressIndicator(
                    backgroundColor: mainColor,
                    valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
                )
            );
        },
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: center.inquiry.length + 1,
        );
      },
    );
  }
}

class InquiryItem extends StatefulWidget {
  final InquiryModel inquiryModel;

  InquiryItem(this.inquiryModel);

  @override
  _InquiryItemState createState() => _InquiryItemState();
}

class _InquiryItemState extends State<InquiryItem> {

  bool isOpen = false;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
            child: title(),
          ),
          isOpen ? detail() : SizedBox(),
        ],
      ),
    );
  }

  Widget title() {
    return Container(
      width: double.infinity,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      "서비스 이용 문의",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff444444),
                      ),
                    ),
                    Provider.of<CenterProvider>(context).inquiry[0].status == "ANSWER"?
                    Image.asset(
                      "assets/icon/n.png",
                      width: 24,
                      fit: BoxFit.contain,
                    ) : Image.asset("assets/icon/n.png",width:0),
                  ],
                ),
                Text(
                  widget.inquiryModel.created_at.split("T").first,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff888888),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget detail() {
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
                  widget.inquiryModel.title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff444444),
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
                    widget.inquiryModel.answer == null? "아직 답이 달리지 않았습니다.": widget.inquiryModel.answer,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff444444),
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
