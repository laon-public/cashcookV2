import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Map<String, String> imgMap = {
  "01" : "assets/resource/markers/category01.png",
  "02" : "assets/resource/markers/category02.png",
  "03" : "assets/resource/markers/category03.png",
  "04" : "assets/resource/markers/category04.png",
  "05" : "assets/resource/markers/category05.png",
  "06" : "assets/resource/markers/category06.png",
  "07" : "assets/resource/markers/category07.png",
  "08" : "assets/resource/markers/category08.png",
  "09" : "assets/resource/markers/category09.png",
  "10" : "assets/resource/markers/category10.png",
  "MY" : "assets/resource/markers/category_my.png",
  "SEL" : "assets/resource/markers/select.png",
};

Future<BitmapDescriptor> getBitmapDescriptorFromAssetMarkers(
    String code, int width) async {
  final Uint8List imageData = await getBytesFromAsset(imgMap[code], width);
  return BitmapDescriptor.fromBytes(imageData);
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ImageByteFormat.png))
      .buffer
      .asUint8List();
}

Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
    String path, int width) async {
  final Uint8List imageData = await getBytesFromAsset(path, width);
  return BitmapDescriptor.fromBytes(imageData);
}