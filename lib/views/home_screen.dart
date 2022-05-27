import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:weather/weather.dart';

import '../controllers/weather_firebase.dart';
import '../controllers/weather_api.dart';
import '../l10n/l10n.dart';
import '../views/widgets/weather_card.dart';
import '../models/favorites.dart';
import '../models/theme.dart';
import '../models/weather.dart';
import '../constants.dart';
import '../map.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget  build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
            return MaterialApp(
              theme: themeNotifier.isDark ? ThemeData.dark() : ThemeData.light(),
              debugShowCheckedModeBanner: false,
              locale: themeNotifier.locale,
              supportedLocales: L10n.all,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              home: Home(),
            );
          }),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String _mapStyle;
  late BitmapDescriptor _mapMarker;
  late GoogleMapController _googleMapController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _itemSearchController = TextEditingController();

  List<UserWeather> _forecast = [];
  List<UserWeather> _cards = [];
  List<UserWeather> _predictionsMap = [];
  List<UserWeather> _predictionsCard = [];
  Set<Marker> _markers = {};

  int _index = 0;
  bool _isLoading = true;
  bool _isVisible = false;
  LatLng _mainLocation = const LatLng(53.893009, 27.567444);
  Locale language = Locale('en');

  @override
  void initState() {
    super.initState();

    StoredCities.getStoredCities().then((value) => getWeather(language));
    setCustomMarker();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getWeather(Locale locale) async {
    Language lang = locale.languageCode == 'en' ? Language.ENGLISH : Language.RUSSIAN;
    _forecast = await WeatherApi.getWeather(lang);
    _cards = _forecast;

    var rng = Random();

    for (var element in _forecast) {
      _markers.add(Marker(
        markerId: MarkerId(rng.nextInt(1000).toString()),
        position: LatLng(element.lat, element.lon),
        infoWindow: InfoWindow(
          title: element.city + ', ' + element.areaCode,
          snippet: element.temperature.toString() + '°C, ' + element.weatherDescription,
        ),
        icon: _mapMarker,
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child)
        {
          language = themeNotifier.locale;
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.indigo,
                actions:[
                  _index != 0
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          setState((){
                            _isVisible = !_isVisible;
                          });
                        },
                        child: const Icon( Icons.search, size: 30,),
                      ),
                  ),
                ],
              ),
              body: Column(children: <Widget>[

                _index == 0
                    ? home1(context)
                    : _index == 1
                    ? map(context)
                    : _index == 2
                    ? settings(context)
                    : favorites(context),

                Container(
                  color: themeNotifier.isDark ? Colors.indigo : Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, left: 2.0, right: 2.0, bottom: 5.0),
                    child: Row(children: <Widget>[
                      GestureDetector(

                        onTap: () {
                          setState(() {
                            _index = 3;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: _index == 3
                                  ? themeNotifier.isDark
                                  ? Colors.black38
                                  : Colors.indigo
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(25.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            child: Row(children: <Widget>[

                              Icon(Icons.star,
                                color: _index == 3
                                    ? Colors.white
                                    : themeNotifier.isDark
                                    ? Colors.white
                                    : Colors.black,
                                size: 30.0,),
                              Padding(padding: EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    _index == 3
                                        ? AppLocalizations.of(context)!.menu_fav
                                        : '',
                                    style: TextStyle(
                                        color: _index == 3 ? Colors.white : Colors
                                            .black,
                                        fontSize: 20 + fontSizeZoom
                                    ),
                                  )
                              )
                            ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(

                        onTap: () {
                          setState(() {
                            _index = 0;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: _index == 0
                                    ? themeNotifier.isDark
                                    ? Colors.black38
                                    : Colors.indigo
                                    : Colors.transparent,
                              borderRadius: BorderRadius.circular(25.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            child: Row(children: <Widget>[

                              Icon(Icons.home,
                                color: _index == 0
                                    ? Colors.white
                                    : themeNotifier.isDark
                                    ? Colors.white
                                    : Colors.black,
                                size: 30.0,),
                              Padding(padding: EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    _index == 0
                                        ? AppLocalizations.of(context)!.menu_home
                                        : '',
                                    style: TextStyle(
                                        color: _index == 0 ? Colors.white : Colors
                                            .black,
                                        fontSize: 20 + fontSizeZoom
                                    ),
                                  )
                              )
                            ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(

                        onTap: () {
                          setState(() {
                            _index = 1;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: _index == 1
                                  ? themeNotifier.isDark
                                  ? Colors.black38
                                  : Colors.indigo
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(25.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            child: Row(children: <Widget>[

                              Icon(Icons.place,
                                color: _index == 1
                                    ? Colors.white
                                    : themeNotifier.isDark
                                    ? Colors.white
                                    : Colors.black,
                                size: 30.0,),
                              Padding(padding: EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    _index == 1
                                        ? AppLocalizations.of(context)!.menu_map
                                        : '',
                                    style: TextStyle(
                                        color: _index == 1 ? Colors.white : Colors
                                            .black,
                                        fontSize: 20 + fontSizeZoom
                                    ),
                                  )
                              )
                            ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _index = 2;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: _index == 2
                                  ? themeNotifier.isDark
                                  ? Colors.black38
                                  : Colors.indigo
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(25.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            child: Row(children: <Widget>[

                              Icon(Icons.settings,
                                color: _index == 2
                                    ? Colors.white
                                    : themeNotifier.isDark
                                    ? Colors.white
                                    : Colors.black,
                                size: 30.0,),
                              Padding(padding: EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    _index == 2
                                        ? AppLocalizations.of(context)!.menu_settings
                                        : '',
                                    style: TextStyle(
                                        color: _index == 2 ? Colors.white : Colors
                                            .black,
                                        fontSize: 20 + fontSizeZoom
                                    ),
                                  )
                              )
                            ],
                            ),
                          ),
                        ),
                      ),
                    ],),
                  ),
                )
              ],
              )
          );
        }
    );
  }

  Widget home1(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
          _mapStyle = themeNotifier.isDark ? MapStyle.dark : MapStyle.light;
          return Expanded(
            child: Stack(
              children: [
                Container(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                      itemCount: _cards.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: WeatherCard(cityWeather: _cards[index]),
                          onTap: () {
                            _mainLocation = LatLng(_cards[index].lat, _cards[index].lon);
                            setState(() {
                              _index = 1;
                            });
                          },
                        );
                      }),
                ),
                Column(
                  children: [
                    !_isVisible && _index == 0
                        ? const SizedBox.shrink()
                        : Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                      child: Container(
                        height: 55,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        decoration: BoxDecoration(
                            color: themeNotifier.isDark
                                ? Colors.grey.shade900
                                : Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(3.0))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              children: [
                                Expanded(child:
                                TextFormField(
                                  controller: _itemSearchController,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!.search_hint),
                                  style: TextStyle(fontSize: 20 + fontSizeZoom),
                                  onChanged: (value) async {
                                    if (value.isNotEmpty) {
                                      autoCompleteCard(value);
                                      setState(() {
                                        _cards = _predictionsCard;
                                      });
                                    } else {
                                      if (_predictionsCard.isNotEmpty && mounted) {
                                        setState(() {
                                          _cards = _forecast;
                                        });
                                      }
                                    }
                                  },
                                )
                                ),
                                IconButton(
                                    onPressed: () {}, icon: const Icon(Icons.search)),
                              ]
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
    );
  }

  Widget favorites(BuildContext context) {
    return Expanded(
      child: Container(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
            itemCount: FavoritesList.cities.length,
            itemBuilder: (context, index) {
              return WeatherCard(cityWeather: FavoritesList.cities[index]);
            }),
      ),
    );
  }

  Widget settings(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
          return Expanded(
            child: SettingsList(
              sections: [
                SettingsSection(
                  title: Text(AppLocalizations.of(context)!.settings_section1, style: TextStyle(fontSize: 20 + fontSizeZoom),),
                  tiles: <SettingsTile>[
                    SettingsTile(
                      leading: const Icon(Icons.language, size: 30,),
                      title: Text(AppLocalizations.of(context)!.language, style: TextStyle(fontSize: 20 + fontSizeZoom)),
                      value: Text(AppLocalizations.of(context)!.locale_lang, style: TextStyle(fontSize: 18 + fontSizeZoom)),
                      onPressed: (context) => {
                        setState((){
                          print(themeNotifier.locale);
                          themeNotifier.locale == Locale('en')
                              ? themeNotifier.setLocale(Locale('ru'))
                              : themeNotifier.setLocale(Locale('en'));
                          getWeather(themeNotifier.locale);
                        })
                        /*Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => LanguagesScreen()))*/
                      },
                    ),
                    SettingsTile.switchTile(
                      onToggle: (value) {
                        setState(() {
                          fontSizeZoom == 0
                              ? fontSizeZoom = 3
                              : fontSizeZoom = 0;
                        });
                      },
                      initialValue: fontSizeZoom == 0 ? false : true,
                      leading: const Icon(Icons.zoom_in, size: 30,),
                      title: Text(AppLocalizations.of(context)!.zoom, style: TextStyle(fontSize: 20 + fontSizeZoom)),
                    ),
                  ],
                ),
                SettingsSection(
                  title: Text(AppLocalizations.of(context)!.settings_section2, style: TextStyle(fontSize: 20 + fontSizeZoom)),
                  tiles: <SettingsTile>[
                    SettingsTile.switchTile(
                      onToggle: (bool value) {
                        setState(() {
                          themeNotifier.isDark
                              ? themeNotifier.isDark = false
                              : themeNotifier.isDark = true;
                        });
                      },
                      initialValue: themeNotifier.isDark,
                      leading: const Icon(Icons.format_paint, size: 30,),
                      title: Text(AppLocalizations.of(context)!.theme_dark, style: TextStyle(fontSize: 20 + fontSizeZoom)),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
    );
  }

  Widget map(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
          _mapStyle = themeNotifier.isDark ? MapStyle.dark : MapStyle.light;
          return Expanded (
            child: Stack(
              children: <Widget>[
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 140,
                    child:
                    GoogleMap(
                      onMapCreated: _onMapCreated,
                      markers: _markers,
                      initialCameraPosition: CameraPosition(
                          target: _mainLocation, zoom: 15),
                      onTap: (value) {
                        setState((){
                          _predictionsMap = [];
                        });
                      },
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                      child: Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: themeNotifier.isDark? Colors.grey.shade900 : Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(3.0))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              children: [
                                Expanded(child:
                                TextFormField(
                                  controller: _searchController,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(hintText: AppLocalizations.of(context)!.search_hint),
                                  style: TextStyle(fontSize: 20 + fontSizeZoom),
                                  onChanged: (value) async {
                                    if (value.isNotEmpty) {
                                      autoCompleteMap(value);
                                    } else {
                                      if (_predictionsMap.isNotEmpty && mounted) {
                                        setState(() {
                                          _predictionsMap = [];
                                        });
                                      }
                                    }
                                  },
                                )
                                ),
                                IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                              ]
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: _predictionsMap.length * 65,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: _predictionsMap.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: themeNotifier.isDark? Colors.grey.shade900.withOpacity(0.8) : Colors.white,
                                  borderRadius: const BorderRadius.all(Radius.circular(5.0))
                              ),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.indigo,
                                  child: Icon(
                                    Icons.pin_drop,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(_predictionsMap[index].city, style: TextStyle(fontSize: 20 + fontSizeZoom),),
                                onTap: () {
                                  _searchController.text = _predictionsMap[index].city;
                                  _mainLocation = LatLng(_predictionsMap[index].lat, _predictionsMap[index].lon);
                                  setState((){
                                    _predictionsMap = [];
                                    _googleMapController.animateCamera(CameraUpdate.newLatLngZoom(_mainLocation, 15));
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
    );
  }

  void autoCompleteMap(String value) {
    List<UserWeather> temp = [];
    _forecast.forEach((element) => {
      element.city.toLowerCase().contains(value.toLowerCase()) ? temp.add(element) : null
    });

    setState(() {
      _predictionsMap = temp;
    });
  }

  void autoCompleteCard(String value) {
    List<UserWeather> temp = [];
    _forecast.forEach((element) => {
      element.city.toLowerCase().contains(value.toLowerCase()) ? temp.add(element) : null
    });

    setState(() {
      _predictionsCard = temp;
    });
  }

  void setCustomMarker() async {
    _mapMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size.square(100)),
        'assets/map_pin.png'
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
    controller.setMapStyle(_mapStyle);
  }
}