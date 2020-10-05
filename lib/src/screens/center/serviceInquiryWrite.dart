import 'package:cashcook/src/provider/CenterProvider.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/widgets/whitespace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InquiryWrite extends StatelessWidget {
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController contentCtrl = TextEditingController();

  FocusNode moveOne = FocusNode ();
  FocusNode moveTwo = FocusNode ();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(""),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: (){
                  if( titleCtrl.text == "" || contentCtrl.text == ""){
                    if(titleCtrl.text == "" ) {
                      FocusScope.of(context).requestFocus(moveOne);
                      _showDialog(context);
                    }else{
                      FocusScope.of(context).requestFocus(moveTwo);
                      _showDialog(context);
                    }

                  }else {
                    Provider.of<CenterProvider>(context, listen: false)
                        .inputInquiry(titleCtrl.text, contentCtrl.text, context);
                  }
                },
                child: Text("보내기",style: TextStyle(fontSize: 14, color: mainColor,decoration: TextDecoration.underline),),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:16, vertical: 16),
        child: body(context),
      ),
    );
  }



  Widget body(context, ){
    var a_height = AppBar().preferredSize.height;
    var s_height = MediaQuery.of(context).size.height;
    var tmp = MediaQuery.of(context).padding.top;
    print(kToolbarHeight);
    print(tmp);
    print(a_height);
    print(s_height);
    print(s_height - a_height - tmp);
    double screenHeightMinusAppBarMinusStatusBar = MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top - 32;
    print(screenHeightMinusAppBarMinusStatusBar);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(0.0),
      child: SizedBox(
        height: screenHeightMinusAppBarMinusStatusBar,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            title(),
            whiteSpaceH(30),
            content(),
            Expanded(child: SizedBox(),),
            btn(context),
          ],
        ),
      ),
    );
  }

  Widget title(){
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:5.0),
            child: Align(child: Text("제목",style: TextStyle(fontSize: 12, color: Color(0xff888888)),),alignment: Alignment.centerLeft,),
          ),
          TextFormField(
            focusNode: moveOne,
            cursorColor: Color(0xff000000),
            controller: titleCtrl,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
                borderSide: BorderSide(color: mainColor, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
                borderSide: BorderSide(color: mainColor, width: 2.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget content(){
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:5.0),
            child: Align(child: Text("내용",style: TextStyle(fontSize: 12, color: Color(0xff888888)),),alignment: Alignment.centerLeft,),
          ),
          TextFormField(
            focusNode: moveTwo,
            maxLines: 10,
            cursorColor: Color(0xff000000),
            controller: contentCtrl,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
                borderSide: BorderSide(color: Color(0xffdddddd), width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
                borderSide: BorderSide(color: mainColor, width: 2.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget btn(context){
    return Container(
      width: double.infinity,
      height: 40,
      child: RaisedButton(
        child: Text("보내기"),
        textColor: Colors.white,
        color: mainColor,
        onPressed: ( titleCtrl.text != "" && contentCtrl.text != "")? () async {

          if( titleCtrl.text == "" || contentCtrl.text == ""){
            if(titleCtrl.text == "" ) {
              //FocusScope.of(context).requestFocus(moveOne);
              _showDialog(context);
            }else{
             // FocusScope.of(context).requestFocus(moveTwo);
              _showDialog(context);
            }

          }else{
            Provider.of<CenterProvider>(context,listen: false).inputInquiry(titleCtrl.text, contentCtrl.text, context);
          }

        } : null,
        elevation: 0.0,
      ),
    );
  }

  void _showDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("${ titleCtrl.text == "" ? "제목을 입력해 주세요." :"내용을 입력해 주세요."}",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xff444444),
            ),),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

