class Weather {
  final String cityName;
  final String temperature;
  final String description;
  final String mainCondition;
  final String icon;
  final String feelsLike;
  final String humidity;
  final String windSpeed;
  final int timeStamp;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.description,
    required this.icon,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.timeStamp,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json['name'],
        temperature: json['main']['temp'].toString(),
        mainCondition: json['weather'][0]['main'],
        description: json['weather'][0]['description'],
        icon: json['weather'][0]['icon'],
        feelsLike: json['main']['feels_like'].toString(),
        humidity: json['main']['humidity'].toString(),
        windSpeed: json['wind']['speed'].toString(),
        timeStamp: json['dt']);
  }

  factory Weather.fromOpenMeteoJson(Map<String, dynamic> json, String cityName) {
    final current = json['current'];
    final int code = current['weather_code'];
    final isDay = current['is_day'] == 1;
    final weatherMap = mapWmoToWeather(code, isDay);

    final timeStr = current['time'] as String;
    final dt = DateTime.parse(timeStr).millisecondsSinceEpoch ~/ 1000;

    return Weather(
      cityName: cityName,
      temperature: current['temperature_2m'].toString(),
      mainCondition: weatherMap['main']!,
      description: weatherMap['description']!,
      icon: weatherMap['icon']!,
      feelsLike: current['apparent_temperature'].toString(),
      humidity: current['relative_humidity_2m'].toString(),
      windSpeed: current['wind_speed_10m'].toString(),
      timeStamp: dt,
    );
  }
}

Map<String, String> mapWmoToWeather(int code, bool isDay) {
  switch (code) {
    case 0:
      return {
        'main': 'Clear',
        'description': 'clear sky',
        'icon': isDay ? '01d' : '01n',
      };
    case 1:
      return {
        'main': 'Clouds',
        'description': 'mainly clear',
        'icon': isDay ? '02d' : '02n',
      };
    case 2:
      return {
        'main': 'Clouds',
        'description': 'partly cloudy',
        'icon': isDay ? '02d' : '02n',
      };
    case 3:
      return {
        'main': 'Clouds',
        'description': 'overcast',
        'icon': isDay ? '03d' : '03n',
      };
    case 45:
    case 48:
      return {
        'main': 'Fog',
        'description': 'foggy',
        'icon': isDay ? '50d' : '50n',
      };
    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
      return {
        'main': 'Drizzle',
        'description': 'drizzle',
        'icon': isDay ? '09d' : '09n',
      };
    case 61:
    case 63:
    case 65:
    case 66:
    case 67:
    case 80:
    case 81:
    case 82:
      return {
        'main': 'Rain',
        'description': 'rainy',
        'icon': isDay ? '10d' : '10n',
      };
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return {
        'main': 'Snow',
        'description': 'snowy',
        'icon': isDay ? '13d' : '13n',
      };
    case 95:
    case 96:
    case 99:
      return {
        'main': 'Thunderstorm',
        'description': 'thunderstorm',
        'icon': isDay ? '11d' : '11n',
      };
    default:
      return {
        'main': 'Clear',
        'description': 'clear sky',
        'icon': isDay ? '01d' : '01n',
      };
  }
}
