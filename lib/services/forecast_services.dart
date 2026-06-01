import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/models/weather_model.dart';

class ForecastWeatherService {
  Future<Map<String, List>> getForecast(double lat, double lon) async {
    final url =
        "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&hourly=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // 1. Process daily forecast (7 items)
      final daily = data['daily'];
      final List<dynamic> dailyTimes = daily['time'];
      final List<dynamic> dailyCodes = daily['weather_code'];
      final List<dynamic> tempMax = daily['temperature_2m_max'];
      final List<dynamic> tempMin = daily['temperature_2m_min'];
      
      List<Map<String, dynamic>> dailyList = [];
      for (int i = 0; i < dailyTimes.length; i++) {
        DateTime dt = DateTime.parse(dailyTimes[i] as String);
        int epochSeconds = dt.millisecondsSinceEpoch ~/ 1000;
        int wmoCode = dailyCodes[i] as int;
        Map<String, String> weatherMap = mapWmoToWeather(wmoCode, true);
        
        dailyList.add({
          'dt': epochSeconds,
          'temp_max': tempMax[i],
          'temp_min': tempMin[i],
          'weather': [
            {
              'icon': weatherMap['icon'],
              'description': weatherMap['description'],
            }
          ],
        });
      }

      // 2. Process hourly forecast (168 items)
      final hourly = data['hourly'];
      final List<dynamic> hourlyTimes = hourly['time'];
      final List<dynamic> hourlyCodes = hourly['weather_code'];
      final List<dynamic> hourlyTemps = hourly['temperature_2m'];
      final List<dynamic> hourlyFeelsLike = hourly['apparent_temperature'];
      final List<dynamic> hourlyHumidity = hourly['relative_humidity_2m'];
      final List<dynamic> hourlyWind = hourly['wind_speed_10m'];
      
      List<Map<String, dynamic>> hourlyList = [];
      for (int i = 0; i < hourlyTimes.length; i++) {
        DateTime dt = DateTime.parse(hourlyTimes[i] as String);
        int epochSeconds = dt.millisecondsSinceEpoch ~/ 1000;
        int wmoCode = hourlyCodes[i] as int;
        bool isDay = dt.hour >= 6 && dt.hour < 18;
        Map<String, String> weatherMap = mapWmoToWeather(wmoCode, isDay);
        
        hourlyList.add({
          'time': dt,
          'epoch': epochSeconds,
          'temp': hourlyTemps[i],
          'feels_like': hourlyFeelsLike[i],
          'humidity': hourlyHumidity[i],
          'wind_speed': hourlyWind[i],
          'icon': weatherMap['icon'],
          'description': weatherMap['description'],
          'main': weatherMap['main'],
        });
      }

      return {
        'daily': dailyList,
        'hourly': hourlyList,
      };
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
