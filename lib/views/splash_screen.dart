import 'package:flutter_lab/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lab/views/home_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _coffeeController;
  bool copAnimated = false;
  bool animateCafeText = false;

  @override
  void initState() {
    super.initState();
    _coffeeController = AnimationController(vsync: this);
    _coffeeController.addListener(() {
      if (_coffeeController.value > 0.8) {
        _coffeeController.stop();
        copAnimated = true;
        setState(() {});
        Future.delayed(const Duration(seconds: 1), () {
          animateCafeText = true;
          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _coffeeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cafeBrown, Colors.indigo, Colors.blue])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // White Container top half
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              height: copAnimated ? screenHeight / 1.9 : screenHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(copAnimated ? 40.0 : 0.0),
                    bottomLeft: Radius.circular(copAnimated ? 40.0 : 0.0))
              ),
              child: Align(
                alignment: Alignment.center,
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !copAnimated,
                      child: Lottie.asset(
                        'assets/weather.json',
                        controller: _coffeeController,
                        onLoaded: (composition) {
                          _coffeeController
                            ..duration = composition.duration
                            ..forward();
                        },
                      ),
                    ),
                    Center(
                      child: Visibility(
                        visible: copAnimated,
                        child: Image.asset(
                          'assets/weather.gif',
                          height: 280.0,
                          width: 280.0,
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: animateCafeText ? 1 : 0,
                      duration: const Duration(seconds: 1),
                      child: const Text(
                        'WEATHER',
                        style: TextStyle(fontSize: 50.0, color: cafeBrown),
                      ),
                    ),
                  ]
                  ),
                ),
              ),

            // Text bottom part
            Visibility(visible: copAnimated, child: const _BottomPart()),
          ],
        ),
      ),
    );
  }
}

class _BottomPart extends StatelessWidget {
  const _BottomPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeModel(),
        child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child)
          {
            return Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.entrance_title,
                        style: TextStyle(
                            fontSize: 27.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        AppLocalizations.of(context)!.entrance_description,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.5,
                            fontFamily: 'Raleway'
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 50.0),
                      Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                            },
                            child: Container(
                              height: 85.0,
                              width: 85.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2.0),
                              ),
                              child: const Icon(
                                Icons.chevron_right,
                                size: 50.0,
                                color: Colors.white,
                              ),
                            ),
                          )

                      ),
                      const SizedBox(height: 50.0),
                    ],
                  ),
                ),
            );
          }
        )
    );
  }
}