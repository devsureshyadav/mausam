import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/models/weather_model.dart';

class ForecastWeatherService {
  Future<List> getForecast(double lat, double lon) async {
    final url =
        "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&hourly=temperature_2m,weather_code&forecast_days=7";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final hourly = data['hourly'];
      final List<dynamic> times = hourly['time'];
      final List<dynamic> weatherCodes = hourly['weather_code'];
      
      List<Map<String, dynamic>> forecastList = [];
      for (int i = 0; i < times.length; i += 3) {
        DateTime dt = DateTime.parse(times[i] as String);
        int epochSeconds = dt.millisecondsSinceEpoch ~/ 1000;
        int wmoCode = weatherCodes[i] as int;
        bool isDay = dt.hour >= 6 && dt.hour < 18;
        Map<String, String> weatherMap = mapWmoToWeather(wmoCode, isDay);
        
        forecastList.add({
          'dt': epochSeconds,
          'weather': [
            {
              'icon': weatherMap['icon'],
              'description': weatherMap['description'],
            }
          ],
        });
      }
      return forecastList;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
