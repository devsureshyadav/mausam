import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CityProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _allCities = [];
  List<Map<String, dynamic>> _filteredCities = [];
  List<Map<String, dynamic>> get filteredCities => _filteredCities;

  Future<void> loadCities() async {
    final cities = await rootBundle.loadString("./lib/cities/cities.json");

    List<dynamic> cityList = await jsonDecode(cities);
    List<Map<String, dynamic>> allCities =
        cityList.map<Map<String, dynamic>>((city) {
      if (city is Map<String, dynamic>) {
        return {
          'id': city['id'],
          'name': city['name'],
          'country': city['country'],
          'population': city['population'],
          'coordinates': city['coord'],
          'flag': city['flag'],
        };
      }
      return {};
    }).toList();
    _allCities = allCities;
    _filteredCities = List.from(allCities);
    notifyListeners();
  }

  void findCity(String searchCityName) {
    if (searchCityName.isEmpty) {
      _filteredCities = List.from(_allCities);
    } else {
      _filteredCities = _allCities.where((city) {
        return city['name'].toString().toLowerCase().contains(
              searchCityName.toString().toLowerCase(),
            );
      }).toList();
    }
    notifyListeners();
  }
}
