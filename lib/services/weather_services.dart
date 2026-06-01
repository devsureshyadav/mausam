import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weather/models/weather_model.dart';

class WeatherService {
  Future<Weather> getWeather(String city) async {
    await dotenv.load();
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=${dotenv.env['API_KEY']}"));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception("City not found");
    } else {
      throw Exception("Failed to load weather data....");
    }
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
