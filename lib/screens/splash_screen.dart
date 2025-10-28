import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yolo_grapevine/screens/form.dart';
import 'package:yolo_grapevine/screens/introduction_screen.dart';
import 'package:yolo_grapevine/main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.fadeIn(
      backgroundColor: const Color(0xFFFFEB3B), //0xff7864F6
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(seconds: 2),
      childWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("android/app/src/main/assets/logo.png", height: 120),
          const SizedBox(height: 20),
          const Text(
            "VineCare",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      nextScreen: const SplashNavigator(),
    );
  }
}

class SplashNavigator extends StatelessWidget {
  const SplashNavigator({super.key});

  Future<Widget> _determineStartScreen() async {
    final settingsBox = await Hive.openBox('settings');
    final bool hasSeenOnBoarding = settingsBox.get(
      'onboarding_seen',
      defaultValue: false,
    );
    final bool hasCompletedProfile = settingsBox.get(
      'profile_completed',
      defaultValue: false,
    );

    debugPrint(
      "Splash check → onboarding: $hasSeenOnBoarding | profile: $hasCompletedProfile",
    );

    if (hasCompletedProfile) return const MainScreen();
    if (hasSeenOnBoarding) return const FormScreen();
    return const OnBoardingPage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _determineStartScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.yellow,
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        return snapshot.data!;
      },
    );
  }
}
