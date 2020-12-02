import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:dio/dio.dart';

class StoreApplyService {
  Dio dio = Dio();

  Future<String> imageTest(String imagePath) async {
    Map<String, MultipartFile> data = {
      "image" : MultipartFile.fromFileSync(imagePath)
    };

    Response res = await dio.post(cookURL + "/franchises/image",
      data: FormData.fromMap(data),
      options: Options(
        headers: {"Authorization": "BEARER ${dataStorage.token}"},
      )
    );

    print(res.data.toString());
  }
}