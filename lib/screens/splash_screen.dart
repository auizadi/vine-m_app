import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yolo_grapevine/screens/introduction_screen.dart';
import 'package:yolo_grapevine/main.dart'; // untuk MainScreen()

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.fadeIn(
      animationCurve: Curves.easeIn,
      backgroundColor: Colors.yellow,
      duration: const Duration(seconds: 15),
      animationDuration: const Duration(seconds: 10),
      onInit: () {
        debugPrint("On Init");
      },
      onEnd: () {
        debugPrint("On End");
      },
      childWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: Image.asset("android/app/src/main/assets/logo.png"),
          ),
          const SizedBox(height: 16),
          const Text(
            'VineCare',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      onAnimationEnd: () => debugPrint("On Fade In End"),
      nextScreen: const SplashNavigator(), // Cek onboarding
    );
  }
}

class SplashNavigator extends StatelessWidget{
  const SplashNavigator({super.key});

  @override
  Widget build(BuildContext context){
    final box = Hive.box('settings');
    final hasSeenOnBoarding = box.get('onboarding_seen', defaultValue: false);

    return hasSeenOnBoarding ? const MainScreen() : const OnBoardingPage();
  }
}