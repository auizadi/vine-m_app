import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:yolo_grapevine/main.dart';
import 'package:hive/hive.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yolo_grapevine/screens/form.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});
  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    final settingsBox = Hive.box('settings');
    await settingsBox.put('onboarding_seen', true);
    // setelah onboarding, cek apakah profil sudah lengkap
    final hasCompletedProfile = settingsBox.get(
      'profile_completed',
      defaultValue: false,
    );

    if (!mounted) return;

    if (hasCompletedProfile) {
      // jika sudah lengkapi profil, langsung ke MainScreen
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
    } else {
      // jika belum lengkapi profil, ke FormScreen
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const FormScreen()));
    }
  }

  Widget _buildImage(String assetName, [double width = 230]) {
    return SvgPicture.asset(
      'android/app/src/main/assets/$assetName',
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 16.0, color: Colors.white);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Color(0xff7864F6),
      imagePadding: EdgeInsets.zero,
      imageAlignment: Alignment.bottomCenter,
      pageMargin: EdgeInsets.symmetric(vertical: 35),
      bodyAlignment: Alignment.topCenter,
    );

    return IntroductionScreen(
      key: introKey,
      showDoneButton: false,
      globalBackgroundColor: Color(0xff7864F6),
      infiniteAutoScroll: false,
      pages: [
        PageViewModel(
          title: 'VineCare',
          body: 'Aplikasi Pintar Deteksi Penyakit Daun Tanaman Anggur',
          image: _buildImage('intro1.svg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Instant Detection",
          body: "Cepat dan Akurat dalam mendeteksi Penyakit",
          image: _buildImage('intro2.svg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Expert Solutions",
          body: "Memberikan Langkah Pencegahan dan Perawatan",
          image: _buildImage('intro3.svg'),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            bodyFlex: 2,
            imageFlex: 3,
            safeArea: 100,
          ),
          footer: ElevatedButton(
            onPressed: () async {
              final settingsBox = Hive.box('settings');
              await settingsBox.put('onboarding_seen', true);
              await settingsBox.flush();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const FormScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Mulai',
              style: TextStyle(
                color: Color(0xff7864f6),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
      // onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      back: const Icon(Icons.arrow_back, color: Colors.white),
      skip: const Text(
        'Lewati',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      next: const Icon(Icons.arrow_forward, color: Colors.white),

      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding:
          kIsWeb
              ? const EdgeInsets.all(12)
              : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.white,
        activeSize: Size(22.0, 22.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
