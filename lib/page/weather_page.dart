import 'package:flutter/material.dart';
import '../features/weather_page/current_weather.dart';
import '../features/weather_page/hourly_weather.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: const [
        CurrentWeather(),
        HourlyWeather(),
      ],
    );
  }
}
