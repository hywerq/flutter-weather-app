import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/theme.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
          return Scaffold(
            appBar: AppBar(
                title: Text('Languages', style: TextStyle(fontSize: 22.0 + fontSizeZoom),),
              backgroundColor: Colors.indigo,
            ),
            body: ListView(
              padding: const EdgeInsets.all(8),
              children:  <Widget>[
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('English', style: TextStyle(fontSize: 20 + fontSizeZoom),)
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, 'English');
                  },
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Русский', style: TextStyle(fontSize: 20 + fontSizeZoom),)
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, 'Русский');
                  },
                ),
              ],
            ),
          );
        }
    );
  }
}