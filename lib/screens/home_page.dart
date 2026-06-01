import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/components/extra_weather_info.dart';
import 'package:weather/components/main_container.dart';
import 'package:weather/components/five_days_forecast.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/screens/developer_profile.dart';
import 'package:weather/services/weather_services.dart';
import 'package:weather/widgets/text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //api key
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  String? _country;
  //fetch weather
  _fetchWeather() async {
    String? cityName = await _weatherService.getCurrentCity();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
          duration: const Duration(seconds: 3),
          colorText: Colors.white,
          "Location",
          "Your residential area is $cityName");
    });
    try {
      final weather = await _weatherService.getWeather(cityName);

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      // throw new Exception("Fetch weather failed");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
            colorText: Colors.white,
            "Error",
            "Failed to load weather data ha ha ha..");
      });
    }
  }

  //weather animation

  @override
  void initState() {
    super.initState();
    // _weatherService.getCurrentCity();
    _fetchWeather();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final deviceWidth = MediaQuery.of(context).size.width;
    // final deviceHeight = MediaQuery.of(context).size.height;
    String? description = _weather?.description;
    // String iconUrl = "https://openweathermap.org/img/wn/01d@2x.png";
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
                    Get.to(() => const DeveloperContactInfo());
                  },
                  icon: Hero(
                      tag: "Hero",
                      child: Lottie.asset(
                          "./assets/weatherAssets/developer1.json")),
                ),
              ),
            ],
          ),
          body: _weather == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Lottie.asset(
                          height: 100.0, "./assets/weatherAssets/loading.json"),
                      // myText("Loading...", 20, Colors.white),
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
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          // if (_weather?.icon != null)
                          MainContainer(
                            cityName: "${_weather?.cityName}",
                            countryName: _country ?? "",
                            iconName: _weather?.icon ?? "01d",
                            description: "$description",
                            temperature: _weather?.temperature ?? "",
                            timeStamp: _weather?.timeStamp ?? 0,
                          ),
                          // Image.network(iconUrl),
                          // myText("${_weather?.cityName}", 10, Colors.white),
                          ExtraWeatherInfo(
                            feelsLike: _weather?.feelsLike ?? "",
                            humidity: _weather?.humidity ?? "",
                            windSpeed: _weather?.windSpeed ?? "",
                            iconName: _weather?.icon ?? "01d",
                          ),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child:
                                    myText("5 Days Forecast", 18, Colors.white),
                              )),
                          const SizedBox(
                            height: 120,
                            child: SevenDays(),
                          ),
                          const SizedBox(height: 5.0),
                          // const Search(),
                        ],
                      ),
                    ),
                  ),
                ),
          // bottomNavigationBar: BottomNavBar(),
        ),
      ],
    );
  }
}
