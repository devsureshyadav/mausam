import 'package:flutter/material.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/services/weather_services.dart';
import 'package:weather/services/forecast_services.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final ForecastWeatherService _forecastWeatherService = ForecastWeatherService();

  Weather? _currentWeather;
  Weather? get currentWeather => _currentWeather;

  List<dynamic> _forecastList = [];
  List<dynamic> get forecastList => _forecastList;

  String? _cityName;
  String? get cityName => _cityName;

  String? _countryName;
  String? get countryName => _countryName;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWeather(double lat, double lon, String cityName, String countryName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cityName = cityName;
      _countryName = countryName;
      _currentWeather = await _weatherService.getWeather(lat, lon, cityName);
      _forecastList = await _forecastWeatherService.getForecast(lat, lon);
    } catch (e) {
      _errorMessage = "Failed to load weather: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherForCurrentLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final position = await _weatherService.getCurrentLocation();
      final currentCity = await _weatherService.getCurrentCity();
      _cityName = currentCity;
      _countryName = "";
      _currentWeather = await _weatherService.getWeather(position.latitude, position.longitude, currentCity);
      _forecastList = await _forecastWeatherService.getForecast(position.latitude, position.longitude);
    } catch (e) {
      _errorMessage = "Failed to load current location weather: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
