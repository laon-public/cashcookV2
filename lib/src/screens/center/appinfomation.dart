import 'package:cashcook/src/model/faq.dart';
import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashcook/src/utils/Share.dart';

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
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: white,
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
                  onKakaoShare();
                },
                child: Text("공유",style:
                  TextStyle(
                      fontSize: 14,
                      color: mainColor,
                      fontFamily: 'noto',
                      decoration: TextDecoration.underline),), //오른쪽 상단에 텍스트 출력
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
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Color(0xFFDDDDDD))
                  ),
                  child:
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: Image.asset('assets/icon/mini_logo.png', fit: BoxFit.cover,),
                  ),
                ),
                whiteSpaceH(10.0),
                Text('현재버전 : v1.1.1(TESTING)',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'noto',

                    )),
                Text('최신버전을 사용 중입니다.',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'noto'
                    )),
              ],
            )
        ));
  }
}
