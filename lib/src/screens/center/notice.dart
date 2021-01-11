import 'package:cashcook/src/model/notice.dart';
import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

class Notice extends StatelessWidget {
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
      center.fetchNoticeData(currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if(_scrollController.offset == _scrollController.position.maxScrollExtent)
        loadMore(context);
    });
    Provider.of<CenterProvider>(context, listen: false).fetchNoticeData(currentPage);

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text("공지사항",
        style: appBarDefaultText,),
        centerTitle: true,
        elevation: 1.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    return NoticeList();
  }

  Widget NoticeList() {
    return Consumer<CenterProvider>(
      builder: (context, center, _){
        return ListView.builder(itemBuilder: (context, idx) {
          if(idx < center.notice.length){
            return NoticeItem(center.notice[idx]);
          }
          // return Center(
          //     child: CircularProgressIndicator(
          //         backgroundColor: mainColor,
          //         valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
          //     )
          // );
        },
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          // itemCount: center.notice.length + 1,
          itemCount: center.notice.length,
        );
      },
    );
  }
}

class NoticeItem extends StatefulWidget {
  NoticeModel noticeModel;

  NoticeItem(this.noticeModel);

  @override
  _NoticeItemState createState() => _NoticeItemState();
}

class _NoticeItemState extends State<NoticeItem> {

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
              child: title()),
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
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: "${widget.noticeModel.title}\n",
                  style: Body1.apply(
                      fontWeightDelta: 2
                  )),
              TextSpan(
                  text: widget.noticeModel.created_at.split("T").first,
                  style: TextStyle(fontSize: 12, color: Color(0xff888888))),
            ],
          ),
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
        child: Text(
          widget.noticeModel.contents,
          style: Body2.apply(
              color: black
          ),
        ),
      ),
    );
  }
}
