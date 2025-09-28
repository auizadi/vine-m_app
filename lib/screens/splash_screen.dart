import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yolo_grapevine/screens/form.dart';
import 'package:yolo_grapevine/screens/introduction_screen.dart';
import 'package:yolo_grapevine/main.dart'; // untuk MainScreen()

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return FlutterSplashScreen.fadeIn(
      animationCurve: Curves.easeIn,
      backgroundColor: Colors.yellow,
      duration: const Duration(seconds: 7),
      animationDuration: const Duration(seconds: 2),
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
    final settingBox = Hive.box('settings');
    final hasSeenOnBoarding = settingBox.get('onboarding_seen', defaultValue: false);
    final hasCompletedProfile = settingBox.get('profile_completed', defaultValue: false);

    // jika sudah pernah onboarding dan sudah lengkapi profil, langsung ke MainScreen
    if (hasSeenOnBoarding && hasCompletedProfile){
      return const MainScreen();
    }
    // jika sudah onboarding tapi belum lengkapi profil ke FormScreen
    else if(hasSeenOnBoarding && !hasCompletedProfile){
      return const FormScreen();
    }
    // jika belum pernah onboarding , tampilkan onboarding 
    else {
      return const OnBoardingPage();
    }
    
  }
}