import 'package:cashcook/src/model/faq.dart';
import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Faq extends StatelessWidget {
  ScrollController _scrollController = ScrollController();
  int currentPage = 0;

  loadMore(context) async {
    CenterProvider center = Provider.of<CenterProvider>(context,listen: false);
    if(!center.isLoading){
      currentPage++;
      if(center.pageing.offset >= center.pageing.count){
        return;
      }
      center.startLoading();
      center.fetchFaqData(currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CenterProvider>(context,listen: false).fetchFaqData(currentPage);
    _scrollController.addListener(() {
      if(_scrollController.offset == _scrollController.position.maxScrollExtent)
        loadMore(context);
    });
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text("FAQ"),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: body(),
    );
  }
  Widget body() {
    return FaqList();
  }
  Widget FaqList() {
    return Consumer<CenterProvider>(
      builder: (context, centers, _){
        return ListView.builder(
          controller: _scrollController,
          itemBuilder: (context, idx) {
            if(idx < centers.faq.length){
              return FaqItem(centers.faq[idx]);
            }
            return Center(
              child: Opacity(
                opacity: centers.isLoading ? 1.0 : 0.0,
                child: CircularProgressIndicator(),
              ),
            );
          },
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: centers.faq.length + 1,
        );
      },
    );
  }
}

class FaqItem extends StatefulWidget {
  FaqModel faqModel;
  FaqItem(this.faqModel);

  @override
  _FaqItemState createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/icon/q.png",fit: BoxFit.contain, width: 24,),
            whiteSpaceW(12),
             Text(
                widget.faqModel.question,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff444444),
                ),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/icon/a.png",fit: BoxFit.contain, width: 24,),
            whiteSpaceW(12),
            Text(
              widget.faqModel.answer,
              style: TextStyle(fontSize: 12, color: Color(0xff444444)),
            ),
          ],
        ),
      ),
    );
  }
}
