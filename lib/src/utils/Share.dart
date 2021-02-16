import 'package:kakao_flutter_sdk/link.dart';

void onKakaoShare() async {
  KakaoContext.clientId = "a46ee0b56592aa1c088ad53fd40a60d0";

  try {
    var uri = await  LinkClient.instance.customWithWeb(47472);
    print(Uri.parse("https://play.google.com/store/apps/details?id=com.hojo.cashcook.cashcook"));
    await launchBrowserTab(uri);
  } catch(e) {
    print(e.toString());
  }
}

void onKakaoStoreShare(String title, String imageUrl, String description) async {
  KakaoContext.clientId = "a46ee0b56592aa1c088ad53fd40a60d0";
  List<Button> buttonList = [Button("캐시쿡에서 확인해보세요!", Link(
    mobileWebUrl: Uri.parse("https://play.google.com/store/apps/details?id=com.hojo.cashcook.cashcook"),
    webUrl: Uri.parse("https://play.google.com/store/apps/details?id=com.hojo.cashcook.cashcook")
  ))];
  try{
    var temp = FeedTemplate(
        Content(
            "$title\n" +
            "$description",
            Uri.parse(imageUrl),
            Link(
              mobileWebUrl: Uri.parse("https://play.google.com/store/apps/details?id=com.hojo.cashcook.cashcook"),
              webUrl: Uri.parse("https://play.google.com/store/apps/details?id=com.hojo.cashcook.cashcook")
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
