import 'package:flutter_lab/controllers/weather_firebase.dart';
import 'package:flutter_lab/models/weather.dart';

class FavoritesList {
  static List<UserWeather> cities = [];

  static Future<void> changeStatus(UserWeather city) async {
    if(!cities.contains(city)) {
      cities.add(city);
      StoredCities.addFavorite(city.city);
    }
    else {
      cities.remove(city);
      StoredCities.removeFavorite(city.city);
    }
    city.isFavorite = !city.isFavorite;
  }

  static bool hasCity(String city) {
      return cities.any((element) => element.city == city);
  }
}