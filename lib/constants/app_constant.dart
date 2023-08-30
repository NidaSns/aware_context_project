import 'package:google_maps_flutter/google_maps_flutter.dart';

class ApplicationConstant {
  static ApplicationConstant instance = ApplicationConstant._init();

  ApplicationConstant._init();

  SavedLocationModel savedLocation = SavedLocationModel(
      radius: 100,
      location: const LatLng(38.559253899626654, 27.049462290648815));

  LatLng currentLocation = const LatLng(39.934507501061574, 32.835499451765436);

  String apiKey = "3c6d30032f2a0e97b6b1de102db40c28";
}

class SavedLocationModel {
  final double? radius;
  final LatLng location;

  SavedLocationModel({required this.radius, required this.location});

  Map<String, dynamic> toJson() => {
        'radius': radius,
        'location': location,
      };

  factory SavedLocationModel.fromJson(Map<String, dynamic> map) =>
      SavedLocationModel(
        radius: map['radius'],
        location: LatLng(map['location'][0], map['location'][1])
      );
}
