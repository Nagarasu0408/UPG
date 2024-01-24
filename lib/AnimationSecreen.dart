import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:upg/main.dart';

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({super.key});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splashIconSize: 450,
        splash: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              child: Lottie.asset('assets/logo.json',height: 200,width: 200),
            ),
            const Text(
              "UPG",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
          ],
        ),
        nextScreen: MyApp(),
        splashTransition: SplashTransition.sizeTransition,
        duration: 1500,
      ),
    );
  }
}
