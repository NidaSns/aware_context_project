import 'dart:convert';
import 'package:aware_context_app/constants/app_constant.dart';
import 'package:aware_context_app/page/location_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constants/app_colors.dart';
import '../constants/app_enum.dart';
import '../data/local/local_service.dart';
import '../features/snackbar.dart';

class SaveLocationPage extends StatefulWidget {
  const SaveLocationPage({Key? key}) : super(key: key);

  @override
  State<SaveLocationPage> createState() => _SaveLocationPageState();
}

class _SaveLocationPageState extends State<SaveLocationPage> {
  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController radius = TextEditingController();

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  Position? position;

  void getLocation() async {
    position = await getCurrentLocation();
    if (position != null) {
      double latitude = position!.latitude;
      double longitude = position!.longitude;
      ApplicationConstant.instance.currentLocation =
          LatLng(latitude, longitude);
    }
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled
      return null;
    }

    // Check location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied
      return null;
    }

    if (permission == LocationPermission.denied) {
      // Request location permission
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Location permissions are denied
        return null;
      }
    }

    // Get current position
    return await Geolocator.getCurrentPosition();
  }

  InputDecoration decoration(String text) {
    return InputDecoration(
      labelStyle: const TextStyle(color: Colors.white),
      border:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      labelText: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.rainGradient,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                TextField(
                  controller: latitude,
                  keyboardType: TextInputType.number,
                  decoration: decoration("latitude".tr()),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: longitude,
                  keyboardType: TextInputType.number,
                  decoration: decoration("longitude".tr()),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: radius,
                  keyboardType: TextInputType.number,
                  decoration: decoration("radius".tr()),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    ApplicationConstant.instance.savedLocation =
                        SavedLocationModel(
                      radius: double.tryParse(radius.text),
                      location: LatLng(
                        double.parse(latitude.text),
                        double.parse(longitude.text),
                      ),
                    );
                    String encodedMap =
                        json.encode(ApplicationConstant.instance.savedLocation);
                    LocaleService.instance.setStringValue(
                        SharedPreferencesKey.locationAddress.name, encodedMap);
                    SnackBarWidgets.buildSuccessSnackbar(
                        context, "success".tr());
                  },
                  child: Text("save location".tr()),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Location(
                              currentLocation: position,
                            )),
                  ),
                  child: Text("view your location".tr()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
