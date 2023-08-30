import 'package:aware_context_app/page/save_location_page.dart';
import 'package:geolocator/geolocator.dart';
import '../../page/weather_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../features/weather_page/city_search_box.dart';
import 'location_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //bool activeConnection = false;
  bool isEnglish = false;
  String flagPath = "assets/flag/united-kingdom.png";

  // Future checkUserConnection() async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       if (mounted) {
  //         setState(() {
  //           activeConnection = true;
  //         });
  //       }
  //     }
  //   } on SocketException catch (_) {
  //     if (mounted) {
  //       setState(() {
  //         activeConnection = false;
  //         SnackBarWidgets.buildErrorSnackbar(
  //             context, "Check your internet connection".tr());
  //       });
  //     }
  //   }
  // }

  Position? _currentPosition;

  @override
  void initState() {
    _getCurrentPosition();
    super.initState();
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        title: const CitySearchBox(),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.rainGradient,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              child: Row(
                children: [
                  Image.asset(
                    flagPath,
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    isEnglish ? "TR" : "EN",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              onPressed: () {
                setState(() {
                  isEnglish = !isEnglish;
                  flagPath = isEnglish
                      ? "assets/flag/turkey.png"
                      : "assets/flag/united-kingdom.png";
                  context.setLocale(isEnglish
                      ? const Locale('en', 'US')
                      : const Locale('tr', 'TR'));
                });
              },
            ),
            const Expanded(
              flex: 3,
              child: Center(child: WeatherPage()),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Location(
                                currentLocation: _currentPosition,
                              )),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_searching,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "view your location".tr(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SaveLocationPage()),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add_location_alt_sharp,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "add location".tr(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
