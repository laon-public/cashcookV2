import 'package:kakao_flutter_sdk/link.dart';

void onKakaoShare() async {
  KakaoContext.clientId = "9ff1d1f9d55b10b172ed6c2ec06f63bd";

  try {
    var uri = await  LinkClient.instance.customWithWeb(38875);
    print(Uri.parse("https://play.google.com/store/apps/details?id=com.hozo.cashcook.cashcook"));
    await launchBrowserTab(uri);
  } catch(e) {
    print(e.toString());
  }
}

void onKakaoStoreShare(String title, String imageUrl, String description) async {
  KakaoContext.clientId = "9ff1d1f9d55b10b172ed6c2ec06f63bd";
  List<Button> buttonList = [Button("캐시쿡에서 확인해보세요!", Link(
    mobileWebUrl: Uri.parse("https://play.google.com/store/apps/details?id=com.hozo.cashcook.cashcook"),
    webUrl: Uri.parse("https://play.google.com/store/apps/details?id=com.hozo.cashcook.cashcook")
  ))];
  try{
    var temp = FeedTemplate(
        Content(
            "$title\n" +
            "$description",
            Uri.parse(imageUrl),
            Link(
              mobileWebUrl: Uri.parse("https://play.google.com/store/apps/details?id=com.hozo.cashcook.cashcook"),
              webUrl: Uri.parse("https://play.google.com/store/apps/details?id=com.hozo.cashcook.cashcook")
            )
        ),
        buttons: buttonList,
    );

    Uri uri = await LinkClient.instance.defaultWithWeb(temp);
    await launchBrowserTab(uri);
  } catch(e) {
    print(e.toString());
  }
}
