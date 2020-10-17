import 'package:kakao_flutter_sdk/link.dart';

void onKakaoShare() async {
  KakaoContext.clientId = "9ff1d1f9d55b10b172ed6c2ec06f63bd";

  try {
    var uri = await  LinkClient.instance.customWithWeb(37230);
    print(Uri.parse("https://play.google.com/store/apps/details?id=com.laon.needsclear"));
    await launchBrowserTab(uri);
  } catch(e) {
    print(e.toString());
  }
}
