import 'package:geocoder/geocoder.dart';
Future<List<double>> AddressToCoordinates(String address) async {
  var addresses = await Geocoder.local.findAddressesFromQuery(address);
  print(addresses);
  double lat = addresses.first.coordinates.latitude;
  double lon = addresses.first.coordinates.longitude;
  return [lat, lon];
}

Future<String> CoordinatesToAddress(double lat, double lon) async{
  final coordinates = new Coordinates(lat, lon);
  var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  print(addresses.first.addressLine);
  return addresses.first.addressLine;
}

