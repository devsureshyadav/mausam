
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather/colors/color.dart';
import 'package:weather/provider/weather_provider.dart';
import 'package:weather/widgets/text.dart';

class SevenDays extends StatelessWidget {
  const SevenDays({super.key});

  @override
  Widget build(BuildContext context) {
    final dailyForecast = Provider.of<WeatherProvider>(context).dailyForecast;

    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dailyForecast.length,
        itemBuilder: (context, index) {
          final timeStamp = dailyForecast[index]['dt'] as int;
          final icon = dailyForecast[index]['weather'][0]['icon'] as String;
          final tempMax = dailyForecast[index]['temp_max'] as double;
          final tempMin = dailyForecast[index]['temp_min'] as double;
          
          final forecastDate = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
          final isToday = DateFormat("yyyy-MM-dd").format(forecastDate) ==
              DateFormat("yyyy-MM-dd").format(DateTime.now());
          final dayName = isToday ? "Today" : DateFormat("EEE").format(forecastDate);
          
          String lottieName = "loading";
          switch (icon) {
            case "01d":
              lottieName = "sun";
              break;
            case "01n":
              lottieName = "night2";
              break;
            case "02d":
              lottieName = "cloudSun";
              break;
            case "02n":
            case "04n":
              lottieName = "cloudy_night";
              break;
            case "03d":
            case "03n":
            case "04d":
              lottieName = "cloud";
              break;
            case "09d":
            case "09n":
            case "10n":
              lottieName = "cloud_rain";
              break;
            case "10d":
              lottieName = "cloudSun1";
              break;
            case "11d":
            case "11n":
              lottieName = "thunderstorm";
              break;
            case "50d":
            case "50n":
              lottieName = "wind";
              break;
            default:
              lottieName = "loading";
              break;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
            child: Container(
              width: 90,
              decoration: BoxDecoration(
                color: darkColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  myText(dayName, 14, Colors.white),
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Lottie.asset("./assets/weatherAssets/$lottieName.json"),
                  ),
                  myText(
                      "${tempMax.toInt()}° / ${tempMin.toInt()}°",
                      12,
                      Colors.white70),
                ],
              ),
            ),
          );
        });
  }
}
