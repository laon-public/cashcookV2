import 'dart:typed_data';
import 'dart:ui';

import 'package:cashcook/src/utils/FromAsset.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/utils/geocoder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class FindAddress extends StatefulWidget {
  @override
  _FindAddressState createState() => _FindAddressState();
}

class _FindAddressState extends State<FindAddress> {

  Location location = Location();
  CameraPosition cameraPosition;

  GoogleMapController googleMapController;
  var currentLocation;
  bool mapLoad = false;

  Set<Marker> markers = {};

  String address = "";

  double lat;
  double lon;

  getLocation() async {
    currentLocation = await location.getLocation();
    cameraPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 14);

    final icon = await getBitmapDescriptorFromAssetBytes(
        "assets/icon/my_mk.png", 48);

    markers.add(Marker(
      markerId: MarkerId("1"),
      position: LatLng(currentLocation.latitude, currentLocation.longitude),
      icon: icon,
      draggable: true,
      onDragEnd: (LatLng latLng) async {
        await moveMarker(latLng);
        address = await CoordinatesToAddress(latLng.latitude, latLng.longitude);
        setState(() {});
      },
    ));

    lat = currentLocation.latitude;
    lon = currentLocation.longitude;

    setState(() {
      mapLoad = true;
    });
  }

  moveMarker(LatLng latLng) async{

    final icon = await getBitmapDescriptorFromAssetBytes(
        "assets/icon/my_mk.png", 48);

    Marker marker = Marker(
      markerId: MarkerId("1"),
      position: LatLng(latLng.latitude, latLng.longitude),
      icon: icon,
      draggable: true,
      onDragEnd: (LatLng latLng) async {
        await moveMarker(latLng);
        address = await CoordinatesToAddress(latLng.latitude, latLng.longitude);
        setState(() {});
      },
    );

    markers.clear();
    markers.add(marker);

    lat = latLng.latitude;
    lon = latLng.longitude;

    print(lat);
    print(lon);

    setState(() {});
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

  var args;
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text("주소찾기", style: TextStyle(
          color: black,
          fontSize: 14,
          fontFamily: 'noto',
          fontWeight: FontWeight.w600
        )),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: body(),
    );
  }

  Widget body(){
    return Stack(
      children: [
        mapLoad ? googleMap() : SizedBox(),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Container(
            width: double.infinity,
            height: 40,
            padding: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0,0),
                  blurRadius: 8,
                  color: Color(0xff000000).withOpacity(0.15),
                ),
              ],
            ),
            child: Align(child: Text(address, style: TextStyle(color: Colors.black)),alignment: Alignment.centerLeft,),
          ),
        ),
        Positioned(
          bottom: 40,
          left: (MediaQuery.of(context).size.width / 2) - (56 / 2),
              child: InkWell(
                onTap: (){
                  args['getData'](address, lat, lon);
                  Navigator.of(context).pop(address);
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0,0),
                        blurRadius: 8,
                        color: Colors.black.withOpacity(0.15)
                      ),
                    ],
                  ),
                  child: Center(child: Text("선택", style: TextStyle(fontSize: 14, color: mainColor,fontWeight: FontWeight.bold),),),
                ),
              ),
        ),
//        Center(
//          child: Image.asset("assets/icon/marker.png", width: 48, fit: BoxFit.cover,),
//        ),
      ],
    );
  }

  Widget googleMap(){
    return Positioned.fill(child: GoogleMap(
      initialCameraPosition: cameraPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      markers: markers,
      onCameraIdle: () async {
          address = await CoordinatesToAddress(lat, lon);

          setState(() {});
      },
      onCameraMove: (camera) async{
        moveMarker(camera.target);
      },
      onTap: (LatLng latLng) async{
        await moveMarker(latLng);
        address = await CoordinatesToAddress(lat, lon);

        setState(() {});
      },
      onMapCreated: (GoogleMapController controller) {
        setState(() {
          googleMapController = controller;
        });
      },
    ),
    );
  }
}
