import 'dart:typed_data';
import 'dart:ui';

import 'package:cashcook/src/screens/mypage/store/searchAddress.dart';
import 'package:cashcook/src/utils/FromAsset.dart';
import 'package:cashcook/src/utils/colors.dart';
import 'package:cashcook/src/utils/geocoder.dart';
import 'package:cashcook/src/utils/TextStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cashcook/src/widgets/showToast.dart';
import 'package:cashcook/src/widgets/whitespace.dart';

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
        "assets/icon/my_mk.png", 96);

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
        "assets/icon/my_mk.png", 96);

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
        title: Text("주소 설정",
            style: appBarDefaultText),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset("assets/resource/public/prev.png", width: 24, height: 24,),
        ),
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
          top: 12,
          child: InkWell(
            onTap: () async {
                final res = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchAddress(
                      initQuery: address,
                    )
                  )
                );

                if(res != null) {
                  print(res['lat']);
                  print(res['lng']);

                  LatLng  coords = LatLng(res['lat'], res['lng']);

                  moveMarker(coords);


                  googleMapController.animateCamera(
                    CameraUpdate.newLatLng(
                      coords
                    ),
                  );
                }

            },
            child: Container(
                width: MediaQuery.of(context).size.width-32,
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/resource/main/search_blue.png",
                      width: 24,
                      height: 24,
                      color: primary,
                    ),
                    whiteSpaceW(8),
                    Expanded(
                      child: Text(
                        address != "" && address.contains("대한민국") ? address.split("대한민국 ")[1] : address,
                        style: Subtitle2.apply(
                            color:black,
                            fontWeightDelta: 1
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    whiteSpaceW(8),
                    InkWell(
                      onTap: () {
                        setState(() {
                          address = "";
                        });
                      },
                      child: Image.asset(
                        "assets/icon/cancle.png",
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                )
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: (MediaQuery.of(context).size.width / 2) - (56 / 2),
              child: InkWell(
                onTap: (){
                  if(address == ""){
                    showToast("주소가 설정되어 있지 않습니다.");

                    return;
                  }
                  args['getData'](address, lat, lon);
                  Navigator.of(context).pop(address);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 21, horizontal: 17),
                  decoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text("설정", style: Subtitle2.apply(color: white, fontWeightDelta: 1),)
                ),
              ),
        ),
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
