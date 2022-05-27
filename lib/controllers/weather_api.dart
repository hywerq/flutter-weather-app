import 'package:flutter_lab/controllers/weather_firebase.dart';
import 'package:flutter_lab/models/favorites.dart';
import 'package:flutter_lab/models/weather.dart';
import 'package:weather/weather.dart';

class WeatherApi {
  static String key = 'd6d1bbb09c190104efc1201899e7238b';
  static List<String> cities = ['Minsk', 'Moscow', 'Dublin', 'Tokyo', 'New York'];

  static Future<List<UserWeather>> getWeather(Language lang) async {
    WeatherFactory ws = WeatherFactory(key, language: lang);
    List<UserWeather> forecast = [];

    cities = StoredCities.cities;
    FavoritesList.cities = [];

    Weather temp;
    UserWeather weather;

    for(int i = 0; i < cities.length; i++) {
      temp = await ws.currentWeatherByCityName(cities[i]);
      weather = UserWeather.getWeather(temp);

      if(StoredCities.favorites.containsKey(cities[i])) {
        weather.isFavorite = true;
        FavoritesList.cities.add(weather);
      }

      forecast.add(weather);
    }

    return forecast;
  }
}