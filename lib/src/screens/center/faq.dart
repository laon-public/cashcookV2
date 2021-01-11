import 'package:cashcook/src/model/faq.dart';
import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/TextStyles.dart';

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
        title: Text("FAQ",
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
            // return Center(
            //     child: CircularProgressIndicator(
            //         backgroundColor: mainColor,
            //         valueColor: new AlwaysStoppedAnimation<Color>(subBlue)
            //     )
            // );
          },
          physics: AlwaysScrollableScrollPhysics(),
          // itemCount: centers.faq.length + 1,
          itemCount: centers.faq.length,
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
      width: MediaQuery.of(context).size.width,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/icon/q.png",fit: BoxFit.contain, width: 24,),
            whiteSpaceW(12),
             Expanded(
               child: Text(
                 widget.faqModel.question,
                 style: Body1.apply(
                     fontWeightDelta: 2
                 ),
                 overflow: TextOverflow.clip,
               ),
             )
          ],
        ),
      ),
    );
  }

  Widget detail() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Color(0xfff7f7f7),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/icon/a.png",fit: BoxFit.contain, width: 24,),
            whiteSpaceW(12),
            Expanded(
              child: Text(
                widget.faqModel.answer,
                style: Body2.apply(
                    color: black
                ),
                overflow: TextOverflow.clip,
              ),
            )
          ],
        ),
      ),
    );
  }
}
