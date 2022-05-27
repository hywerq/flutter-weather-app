import 'package:weather/weather.dart';

import 'favorites.dart';

class UserWeather {
  final String city;
  final String areaCode;
  final int temperature;
  final String weatherDescription;
  final int weatherCode;
  final double lat;
  final double lon;
  bool isFavorite;

  UserWeather({
    required this.city,
    required this.areaCode,
    required this.temperature,
    required this.weatherDescription,
    required this.weatherCode,
    required this.lat,
    required this.lon,
    required this.isFavorite,
  });

  factory UserWeather.getWeather(Weather json) {
    return UserWeather(
        city: json.areaName as String,
        areaCode: json.country as String,
        temperature: json.temperature?.celsius?.round() as int,
        weatherDescription: json.weatherDescription as String, /*DateFormat.Hm().format(_weather[index].date as DateTime),*/
        weatherCode: json.weatherConditionCode as int,
        lat: json.latitude as double,
        lon: json.longitude as double,
        isFavorite: FavoritesList.hasCity(json.areaName as String)
    );
  }
}