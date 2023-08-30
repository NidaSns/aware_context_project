import 'dart:convert';

import 'package:aware_context_app/constants/app_constant.dart';
import 'package:aware_context_app/data/local/local_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stable_geo_fence/flutter_stable_geo_fence.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/app_enum.dart';

class Location extends StatefulWidget {
  final Position? currentLocation;

  const Location({Key? key, required this.currentLocation}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final geoFenceService = GeoFenceService();
  final double radius = 30;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  StreamSubscription? _subscription;
  late LatLng currentLocation;
  SavedLocationModel? savedLocationModel;

  @override
  void initState() {
    super.initState();
    if (LocaleService.instance
        .containKey(SharedPreferencesKey.locationAddress.name)) {
      String result = LocaleService.instance
          .getStringValue(SharedPreferencesKey.locationAddress.name);
      Map<String, dynamic> decodedMap = json.decode(result);
      savedLocationModel = SavedLocationModel.fromJson(decodedMap);
    }
    currentLocation = widget.currentLocation != null
        ? LatLng(
            widget.currentLocation!.latitude,
            widget.currentLocation!.longitude,
          )
        : ApplicationConstant.instance.currentLocation;
    initGeoFenceService();
  }

  void initGeoFenceService() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.denied) {
        startService();
      } else {
        if (kDebugMode) {
          print("Location Permission should be granted to use GeoFenceSerive");
        }
      }
    } else {
      startService();
    }
  }

  void startService() async {
    String adres = "";
    geoFenceService.startService(
      fenceCenterLatitude:
          ApplicationConstant.instance.savedLocation.location.latitude,
      fenceCenterLongitude:
          ApplicationConstant.instance.savedLocation.location.longitude,
      radius: ApplicationConstant.instance.savedLocation.radius ?? 30,
    );

    _subscription = geoFenceService.geoFenceStatusListener.listen((event) {
      if (kDebugMode) {
        print("$adres: ${event.status.toString()}");
      }
      Fluttertoast.showToast(
          msg: "$adres Status : ${event.status} "
              "Uzaklık: ${event.distance}",
          toastLength: Toast.LENGTH_LONG);
    });
  }

  @override
  void dispose() {
    super.dispose();
    geoFenceService.stopFenceService();
    _subscription?.cancel();
  }

  Set<Circle> circles = {
    Circle(
      circleId: CircleId("1"),
      center: ApplicationConstant.instance.savedLocation.location,
      radius: ApplicationConstant.instance.savedLocation.radius ?? 30,
      fillColor: Colors.blueAccent.withOpacity(0.2),
      strokeColor: Colors.blueAccent,
      strokeWidth: 2,
    ),
  };

  // ApplicationConstant.instance.savedLocation.map((e) {
  //
  // }).toSet();

  void _currentLocation(LatLng location) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: location,
        zoom: 17.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('location'.tr()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: currentLocation,
                    zoom: 16,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  onCameraMove: onCameraMove,
                  circles: circles,
                ),
              ),
              // Expanded(
              //   flex: 1,
              //   child: ListView.builder(
              //     itemCount: ApplicationConstant.instance.savedLocation.length,
              //     itemBuilder: (context, index) {
              //       Map<String, SavedLocationModel> list =
              //           ApplicationConstant.instance.savedLocation;
              //       String key = list.keys.elementAt(index);
              //       SavedLocationModel? value = list[key];
              //       return GestureDetector(
              //         onTap: () {
              //           if (i < list.length) {
              //             setState(() {
              //               currentLocation = LatLng(value.location.latitude,
              //                   value.location.longitude);
              //               _currentLocation(currentLocation);
              //             });
              //             i++;
              //           } else {
              //             i = 0;
              //           }
              //         },
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Card(
              //             child: Column(
              //               children: [
              //                 Text(
              //                   key,
              //                   style: const TextStyle(
              //                       color: Colors.blue,
              //                       fontWeight: FontWeight.bold),
              //                 ),
              //                 Text("${value!.location} - ${value.radius}"),
              //               ],
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            savedLocationModel!=null?
            setState(() {
              currentLocation = LatLng(
                savedLocationModel!.location.latitude,
                savedLocationModel!.location.longitude,
              );
              _currentLocation(currentLocation);
            }):null;
          },
          child: const Icon(Icons.find_replace_outlined),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat);
  }

  void onCameraMove(position) {
    setState(() {
      currentLocation = position.target;
    });
  }

  void onFloatingButtonClick() {
    if (kDebugMode) {
      print("inside onFloatingButtonClick");
    }

    ///Check whether the user inside or outside the fence
    Fluttertoast.showToast(msg: "Status : ${geoFenceService.getStatus()}");
  }
}
