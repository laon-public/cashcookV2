import 'package:fluttertoast/fluttertoast.dart';

bool isResponse(Map<String, dynamic> response) {
  if(response["result"] == 1){
    return true;
  }
  Fluttertoast.showToast(msg: response['resultMsg']);
  return false;
}