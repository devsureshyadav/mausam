import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weather/models/weather_model.dart';

class WeatherService {
  Future<Weather> getWeather(double lat, double lon, String cityName) async {
    final response = await http.get(Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,weather_code,wind_speed_10m"));
    if (response.statusCode == 200) {
      return Weather.fromOpenMeteoJson(jsonDecode(response.body), cityName);
    } else {
      throw Exception("Failed to load weather data....");
    }
  }

  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    String? city;
    try {
      // fetch the current location
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      // final latitude = position.latitude;
      // final longitude = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        city = placemarks[0].locality;
      } else if (placemarks.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
              duration: const Duration(seconds: 3),
              colorText: Colors.white,
              "Error",
              "Placemark is empty");
        });
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
            colorText: Colors.white,
            "Connection Error",
            "Check your internet connection and try again");
      });
    }
    // print(placemarks);
    // print("Placemarks: $placemarks");
    return city ?? "Your city";
  }
}
