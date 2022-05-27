import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lab/constants.dart';
import 'package:flutter_lab/models/favorites.dart';

import '../../models/weather.dart';

class WeatherCard extends StatelessWidget {
  final UserWeather cityWeather;

  WeatherCard({
    required this.cityWeather,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
      width: MediaQuery.of(context).size.width - 44.0,
      height: 185.0,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            offset: const Offset(
              0.0,
              10.0,
            ),
            blurRadius: 10.0,
            spreadRadius: -6.0,
          ),
        ],
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.multiply,
          ),
          image: AssetImage(getPicture(cityWeather.weatherCode)),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Align(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
              child:
              StarButton(
                isStarred: cityWeather.isFavorite,
                iconSize: 50.0,
                valueChanged: (_isStarred) {
                  FavoritesList.changeStatus(cityWeather).then((value) => null);
                },
              ),
            ),
            alignment: Alignment.topRight,
          ),
          Align(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 5.0),
              child: Column(
                children: [
                  Text(
                    cityWeather.city + ', ' + cityWeather.areaCode,
                    style: TextStyle(
                      fontSize: 24 + fontSizeZoom,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    cityWeather.weatherDescription,
                    style: TextStyle(
                        fontSize: 22 + fontSizeZoom,
                        color: Colors.white
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            alignment: Alignment.center,
          ),
          Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        '(' + cityWeather.lat.toString() + ', ' + cityWeather.lon.toString() + ')',
                        style: TextStyle(
                            fontSize: 18 + fontSizeZoom,
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.thermostat,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 7),
                      Text(
                          cityWeather.temperature.toString(),
                          style: TextStyle(
                              fontSize: 18 + fontSizeZoom,
                              color: Colors.white
                          ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            alignment: Alignment.bottomLeft,
          ),
        ],
      ),
    );
  }

  String getPicture(int pictureCode) {
    if (pictureCode == 800) {
      return 'assets/cards/clear.jpg';
    }

    int code = (pictureCode / 100).round();
    return code == 2 ? 'assets/cards/thunderstorm.jpg'
        : code == 3 ? 'assets/cards/drizzle.jpg'
        : code == 5 ? 'assets/cards/rain.jpg'
        : code == 6 ? 'assets/cards/snow.jpg'
        : code == 7 ? getAtmosphereType(pictureCode)
        : getCloudType(pictureCode);
  }

  String getCloudType(int code) {
    return code == 801 ? 'assets/cards/few_clouds.jpg'
        : code == 802 ? 'assets/cards/scattered_clouds.jpg'
        : code == 803 ? 'assets/cards/broken_clouds.jpg'
        : 'assets/cards/clouds.jpg';
  }

  String getAtmosphereType(int code) {
    return code == 701 ? 'assets/cards/mist.jpg'
        : code == 711 ? 'assets/cards/smoke.jpg'
        : code == 781 ? 'assets/cards/tornado.jpg'
        : 'assets/cards/dust.jpg';
  }
}