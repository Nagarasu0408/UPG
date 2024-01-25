import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:upg/BottomNavigationBar.dart';

import 'package:upg/main.dart';
import 'package:upg/settingspage.dart';

import 'Theme.dart';

class AnimationScreen extends StatefulWidget {
  final ThemeMode preferredTheme;
  const AnimationScreen({super.key, required this.preferredTheme});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: context.watch<ThemeProvider>().darkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splashIconSize: 450,
        splash: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              child: Lottie.asset(context.watch<ThemeProvider>().darkMode?'assets/darktheme.json':'assets/logo.json',height: 200,width: 200),
            ),
             Text(
              "UPG",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w400,
                  color:context.watch<ThemeProvider>().darkMode? Colors.white: Colors.black),
            ),
          ],
        ),
        backgroundColor:  context.watch<ThemeProvider>().darkMode ? Colors.black : Colors.white,
        // nextScreen: MyApp(preferredTheme: ThemeMode.light,),
        nextScreen: BottomNavigationBarApp(),
        // nextScreen: SettingsPage(),
        splashTransition: SplashTransition.sizeTransition,
        duration: 1500,
      ),
    );
  }
}
