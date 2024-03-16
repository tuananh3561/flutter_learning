import 'package:flutter/material.dart';
import 'package:flutter_learning/models/weather_model.dart';
import 'package:flutter_learning/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeathPage extends StatefulWidget {
  const WeathPage({super.key});

  @override
  State<WeathPage> createState() => _WeathPageState();
}

class _WeathPageState extends State<WeathPage> {
  // api key from openweathermap.org
  final _weatherService =
      WeatherService(apiKey: '23251d4ceb001dd3c0d16567cf076732');
  Weather? _weather;

  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get the weather for city
    try {
      Weather weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    // fetch the weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city name
            Text(_weather?.cityName ?? 'Loading city...'),

            // weather description aminations
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // temperature
            Text('${_weather?.temperature.round() ?? 0}°C'),

            // weather condition
            Text(_weather?.mainCondition ?? 'Loading...'),
          ],
        ),
      ),
    );
  }
}
