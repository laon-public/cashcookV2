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
      backgroundColor: mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
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
            color: white,
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
                child: Text("공유",style: TextStyle(fontSize: 14,decoration: TextDecoration.underline, color: white),), //오른쪽 상단에 텍스트 출력
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
                Container(
                  padding: EdgeInsets.all(16),
                  child:Image.asset('assets/icon/splash.png', fit: BoxFit.cover,
                    width: 64,
                    height: 64,
                  ),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(
                      15.0
                    ),
                    border: Border.all(
                      color: Color(0xFFDDDDDD),
                      width: 1,
                    )
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
                Text('현재버전 : v1.1.1(TESTING)',
                    style: TextStyle(
                      fontSize: 14,
                    color: white,
                      fontWeight: FontWeight.w600
                    )),
                whiteSpaceH(4),
                Text('최신버전을 사용 중입니다.',
                  style: TextStyle(
                      fontSize: 14,
                      color: white,
                      fontWeight: FontWeight.w600)),
              ],
            )
        ));
  }


}
