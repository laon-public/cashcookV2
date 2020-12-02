import 'dart:convert';
import 'dart:io';

import 'package:cashcook/src/services/API.dart';
import 'package:cashcook/src/utils/datastorage.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<String> postMenu(int bigId, String menuName, String menuPrice, PickedFile menuImg) async {
    Map<String, dynamic> data = {
      "bigId" : bigId,
      "menuName" : menuName,
      "menuPrice" : menuPrice,
      "menuImg" : MultipartFile.fromFileSync(File(menuImg.path).absolute.path)
    };

    Response res = await dio.post(cookURL + "/franchises/v2/menu",
      data: FormData.fromMap(data),
      options: Options(
        headers: {"Authorization": "BEARER ${dataStorage.token}"},
      )
    );

    print(res.data);
  }

  Future<String> patchMenu(int id, String menuName, String menuPrice, PickedFile menuImg) async {
    Map<String, dynamic> data = {
      "id" : id,
      "menuName" : menuName,
      "menuPrice" : menuPrice,
      "menuImg" : MultipartFile.fromFileSync(File(menuImg.path).absolute.path)
    };

    Response res = await dio.patch(cookURL + "/franchises/v2/menu",
        data: FormData.fromMap(data),
        options: Options(
          headers: {"Authorization": "BEARER ${dataStorage.token}"},
        )
    );

    print(res.data);
  }

  Future<String> postBigMenu(int storeId, String name) async {
    Map<String, dynamic> data = {
      "storeId" : storeId,
      "name" : name,
    };

    Response res = await dio.post(cookURL + "/franchises/v2/bigMenu",
        data: FormData.fromMap(data),
        options: Options(
          headers: {"Authorization": "BEARER ${dataStorage.token}"},
        )
    );

    print(res.data);
  }
}