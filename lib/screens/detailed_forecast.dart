import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather/colors/color.dart';
import 'package:weather/provider/weather_provider.dart';
import 'package:weather/widgets/text.dart';

class DetailedForecastScreen extends StatelessWidget {
  const DetailedForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final hourlyForecast = weatherProvider.hourlyForecast;
    final dailyForecast = weatherProvider.dailyForecast;

    if (hourlyForecast.isEmpty || dailyForecast.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Lottie.asset(
            height: 100.0,
            "./assets/weatherAssets/loading.json",
          ),
        ),
      );
    }

    // Build the 7 tab labels based on daily timestamps
    List<String> tabLabels = [];
    for (int i = 0; i < dailyForecast.length; i++) {
      final timeStamp = dailyForecast[i]['dt'] as int;
      final date = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
      final isToday = DateFormat("yyyy-MM-dd").format(date) ==
          DateFormat("yyyy-MM-dd").format(DateTime.now());
      tabLabels.add(isToday ? "Today" : DateFormat("EEE").format(date));
    }

    return DefaultTabController(
      length: dailyForecast.length,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Blurred background image to match home screen
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: const Image(
              fit: BoxFit.cover,
              image: AssetImage("./assets/images/splash.jpeg"),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: myText("Hourly Forecast", 22, Colors.white),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              bottom: TabBar(
                isScrollable: true,
                labelColor: const Color.fromARGB(255, 24, 241, 4),
                unselectedLabelColor: Colors.white60,
                indicatorColor: const Color.fromARGB(255, 24, 241, 4),
                indicatorWeight: 3.0,
                labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                tabs: tabLabels.map((label) => Tab(text: label)).toList(),
              ),
            ),
            body: TabBarView(
              children: List.generate(dailyForecast.length, (dayIndex) {
                // Get the 24 hourly records for the specific day
                final startIndex = dayIndex * 24;
                final endIndex = (dayIndex + 1) * 24;
                final dayHours = hourlyForecast.sublist(
                  startIndex,
                  endIndex > hourlyForecast.length ? hourlyForecast.length : endIndex,
                );

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: dayHours.length,
                    itemBuilder: (context, index) {
                      final hourData = dayHours[index];
                      final DateTime time = hourData['time'] as DateTime;
                      final String timeStr = DateFormat("hh:mm a").format(time);
                      final String icon = hourData['icon'] as String;
                      final double temp = hourData['temp'] as double;
                      final double feelsLike = hourData['feels_like'] as double;
                      final int humidity = hourData['humidity'] as int;
                      final double windSpeed = hourData['wind_speed'] as double;
                      final String description = hourData['description'] as String;

                      // Map the standard icon to a Lottie animation name
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
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: darkColor.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Left: Time & Description
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    myText(timeStr, 18, Colors.white),
                                    const SizedBox(height: 4),
                                    myText(
                                      "${description[0].toUpperCase()}${description.substring(1)}",
                                      13,
                                      greyColor,
                                    ),
                                  ],
                                ),
                              ),

                              // Middle: Lottie Weather Icon
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: Lottie.asset(
                                  "./assets/weatherAssets/$lottieName.json",
                                ),
                              ),

                              const SizedBox(width: 10),

                              // Right: Temperature, Wind & Humidity specs
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    myText("${temp.toInt()} °C", 20, Colors.white),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Icon(
                                          Icons.water_drop,
                                          size: 13,
                                          color: Colors.blueAccent,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          "$humidity%",
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 11,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.air,
                                          size: 13,
                                          color: Colors.tealAccent,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          "${windSpeed.toInt()} km/h",
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
