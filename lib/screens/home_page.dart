import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather/components/extra_weather_info.dart';
import 'package:weather/components/main_container.dart';
import 'package:weather/components/five_days_forecast.dart';
import 'package:weather/components/search_component.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/provider/weather_provider.dart';
import 'package:weather/screens/developer_profile.dart';
import 'package:weather/screens/detailed_forecast.dart';
import 'package:weather/widgets/text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false)
          .fetchWeatherForCurrentLocation();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weather = weatherProvider.currentWeather;
    final cityName = weatherProvider.cityName;
    final countryName = weatherProvider.countryName;
    final isLoading = weatherProvider.isLoading;

    return Stack(
      fit: StackFit.expand,
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: const Image(
            fit: BoxFit.cover,
            image: AssetImage("./assets/images/splash.jpeg"),
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: myText(widget.title, 25, Colors.white),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: IconButton(
                  onPressed: () {
                    Get.to(() => const DeveloperDetailsScreen());
                  },
                  icon: Hero(
                      tag: "Hero",
                      child: Lottie.asset(
                          "./assets/weatherAssets/developer1.json")),
                ),
              ),
            ],
          ),
          body: isLoading || weather == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Lottie.asset(
                          height: 100.0, "./assets/weatherAssets/loading.json"),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 10.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          MainContainer(
                            cityName: cityName ?? weather.cityName,
                            countryName: countryName ?? "",
                            iconName: weather.icon,
                            description: weather.description,
                            temperature: weather.temperature,
                            timeStamp: weather.timeStamp,
                          ),
                          ExtraWeatherInfo(
                            feelsLike: weather.feelsLike,
                            humidity: weather.humidity,
                            windSpeed: weather.windSpeed,
                            iconName: weather.icon,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                myText("7 Days Forecast", 18, Colors.white),
                                TextButton(
                                  onPressed: () {
                                    Get.to(
                                        () => const DetailedForecastScreen());
                                  },
                                  child: const Text(
                                    "See All",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 24, 241, 4),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 120,
                            child: SevenDays(),
                          ),
                          const SizedBox(height: 10.0),
                          const Search(),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
