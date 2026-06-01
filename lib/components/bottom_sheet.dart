import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather/colors/color.dart';
import 'package:weather/provider/city_provider.dart';
import 'package:weather/provider/weather_provider.dart';
import 'package:weather/widgets/text.dart';

class Bottomsheet extends StatefulWidget {
  const Bottomsheet({super.key});

  @override
  State<Bottomsheet> createState() => _BottomsheetState();
}

class _BottomsheetState extends State<Bottomsheet> {
  @override
  void initState() {
    super.initState();
    // Load cities using Providers
    Provider.of<CityProvider>(context, listen: false).loadCities();
  }

  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      decoration: const BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    radius: 18,
                    child: Lottie.asset("./assets/weatherAssets/cross.json"),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Consumer<CityProvider>(
              builder: (BuildContext context, CityProvider cityProvider,
                  Widget? child) {
                final List<Map<String, dynamic>> cities =
                    cityProvider.filteredCities;
                if (cities.isEmpty) {
                  return Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 3.5,
                      child: Lottie.asset("./assets/weatherAssets/nodata.json"),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: cities.length,
                      itemBuilder: (context, index) {
                        final cityData = cities[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              final coordinates = cityData['coordinates'];
                              if (coordinates != null) {
                                final lat = double.tryParse(coordinates['lat'].toString()) ?? 0.0;
                                final lon = double.tryParse(coordinates['lon'].toString()) ?? 0.0;
                                Provider.of<WeatherProvider>(context,
                                        listen: false)
                                    .fetchWeather(
                                        lat,
                                        lon,
                                        cityData['name'].toString(),
                                        cityData['country'].toString());
                              }
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: darkColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    myText(cityData['name'].toString(), 15,
                                        Colors.white),
                                    myText(cityData['id'].toString(), 12,
                                        greyColor)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            myText("Wait for few seconds after searching to see the results...",
                10, greyColor),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      hintText: "Search city",
                      hintStyle: const TextStyle(
                        color: greyColor,
                      ),
                      suffix: InkWell(
                        child: const Icon(Icons.search, color: Colors.white),
                        onTap: () {
                          Provider.of<CityProvider>(context, listen: false)
                              .findCity(_searchController.text);
                          _searchController.clear();

                          Lottie.asset("./assets/weatherAssets/loading.json");
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
