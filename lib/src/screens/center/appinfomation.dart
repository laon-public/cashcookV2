import 'package:cashcook/src/model/faq.dart';
import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppInfomation extends StatelessWidget {
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
      backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        title: Text("앱정보"),
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Colors.amberAccent,
        //leading: Icon(Icons.close), // 앱의 뒤로가기 버튼의 모양 변경 기능 왠지 작동이 안됨
        //뒤로가기 버튼은 이미지를 활용하여 x로만듬
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset(
            "assets/resource/public/close.png",
            width: 24,
            height: 24,
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: (){
                  //Navigator.of(context).pushNamed("/inquiry/write"); //공유 버튼을 눌렀을때 이동할 주소 (임시)
                },
                child: Text("공유",style: TextStyle(fontSize: 14,decoration: TextDecoration.underline),), //오른쪽 상단에 텍스트 출력
              ),
            ),
          ),
        ],
      ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,  //center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 150),
                ),
                ClipRRect( // 사각형 이미지를 둥글게하는 함수
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset('assets/icon/splash.png', fit: BoxFit.cover,),
                  ),
                ),
                /*이미지 가져오기
                Image.asset(
                  'assets/icon/splash.png',
                  width: 100,
                  height: 100,
                ), //임시
                */
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                Text('현재버전 : v1.1.1(TESTING)', style: TextStyle(fontSize: 15)),
                Text('최신버전을 사용 중입니다.', style: TextStyle(fontSize: 15)),
              ],
            )
        ));
  }

//
//   Widget body() {
//     return AppinfoList();
//   }
//   Widget AppinfoList() {
//     return Consumer<CenterProvider>(
//       builder: (context, centers, _){
//         return ListView.builder(
//           controller: _scrollController,
//           itemBuilder: (context, idx) {
//             if(idx < centers.faq.length){
//               return AppinfoItem(centers.faq[idx]);
//             }
//             return Center(
//               child: Opacity(
//                 opacity: centers.isLoading ? 1.0 : 0.0,
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           },
//           physics: AlwaysScrollableScrollPhysics(),
//           itemCount: centers.faq.length + 1,
//         );
//       },
//     );
//   }
// }
//
// class FaqItem extends StatefulWidget {
//   FaqModel faqModel;
//   FaqItem(this.faqModel);
//
//   @override
//   _FaqItemState createState() => _FaqItemState();
// }
//
// class _FaqItemState extends State<FaqItem> {
//   bool isOpen = false;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           InkWell(
//               onTap: () {
//                 setState(() {
//                   isOpen = !isOpen;
//                 });
//               },
//               child: title()),
//           isOpen ? detail() : SizedBox(),
//         ],
//       ),
//     );
//   }
//
//   Widget title() {
//     return Container(
//       width: double.infinity,
//       height: 64,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset("assets/icon/q.png",fit: BoxFit.contain, width: 24,),
//             whiteSpaceW(12),
//             Text(
//               widget.faqModel.question,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xff444444),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget detail() {
//     return Container(
//       width: double.infinity,
//       color: Color(0xfff7f7f7),
//       child: Padding(
//         padding:
//         const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 24),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset("assets/icon/a.png",fit: BoxFit.contain, width: 24,),
//             whiteSpaceW(12),
//             Text(
//               widget.faqModel.answer,
//               style: TextStyle(fontSize: 12, color: Color(0xff444444)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//


}
