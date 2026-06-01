import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather/colors/color.dart';
import 'package:weather/provider/city_provider.dart';
import 'package:weather/widgets/text.dart';

class MainContainer extends StatefulWidget {
  final String cityName;
  final String countryName;
  final String iconName;
  final String description;
  final String temperature;
  final int timeStamp;
  const MainContainer({
    super.key,
    required this.cityName,
    required this.countryName,
    required this.iconName,
    required this.description,
    required this.temperature,
    required this.timeStamp,
  });

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  Timer? _timer;
  String time = "";
  String formattedTime = "";
  String amOrPm = "";
  String date = DateFormat("dd MMMM").format(DateTime.now());
  String day = DateFormat("EEEE").format(DateTime.now()).toString();
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) return;
        setState(
          () {
            formattedTime =
                DateFormat("hh:mm:ss").format(DateTime.now()).toString();
            amOrPm = DateFormat("a").format(DateTime.now()).toString();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    // String iconUrl = "https://openweathermap.org/img/wn/50n@2x.png";
    String lottieName = "loading";
    switch (widget.iconName) {
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
        lottieName = "sunCloud1";
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

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(
        width: deviceWidth,
        height: deviceHeight / 1.8,
        decoration: BoxDecoration(
          color: darkColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, bottom: 20.0, top: 0.0),
          child: Consumer(builder:
              (BuildContext context, CityProvider cityProvider, Widget? child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: deviceWidth / 10,
                          width: deviceWidth / 8,
                          child: Lottie.asset(
                              "./assets/weatherAssets/location.json"),
                        ),
                        SizedBox(
                          width: deviceWidth / 3.3,
                          child: myText(
                              "${widget.cityName} ${widget.countryName}",
                              20,
                              const Color.fromARGB(255, 221, 216, 216)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: deviceWidth / 10,
                          width: deviceWidth / 8,
                          child:
                              Lottie.asset("./assets/weatherAssets/time.json"),
                        ),
                        Text(
                          formattedTime,
                          style: const TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 24, 241, 4),
                            fontFamily: "Digital",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          amOrPm,
                          style: const TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 24, 241, 4),
                            fontFamily: "Digital",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 270.0,
                  child:
                      Lottie.asset("./assets/weatherAssets/$lottieName.json"),
                ),
                myText(
                    "${widget.description[0].toUpperCase()}${widget.description.substring(1)}",
                    18,
                    greyColor),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40.0,
                          width: 50.0,
                          child: Lottie.asset(
                              "./assets/weatherAssets/temperature.json"),
                        ),
                        Text("${double.parse(widget.temperature).toInt()} °C",
                            style: TextStyle(
                              fontSize: 50.0,
                              color: Colors.white,
                              fontFamily: GoogleFonts.balooBhai2().fontFamily,
                            ))
                      ],
                    ),
                    myText("$day, $date", 15, greyColor),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
