import 'package:flutter/material.dart';
import 'package:yolo_grapevine/screens/splash_screen.dart';
import 'screens/home.dart';
import 'screens/history.dart';
import 'screens/guide.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/diseases_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // box untuk menyimpan hasil deteksi
  Hive.registerAdapter(DetectionHistoryAdapter());
  await Hive.openBox<DetectionHistory>('detectionResults');

  // box untuk menyimpan flag onboarding
  await Hive.openBox('settings');
  // box profile
  await Hive.openBox('userProfile');

  runApp(const GrapeMobileApp());
}

class GrapeMobileApp extends StatelessWidget {
  const GrapeMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    // cek onboarding for the first time
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const SplashScreen(),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          bodyLarge: GoogleFonts.poppins(fontWeight: FontWeight.w400),
          titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [HomeScreen(), HistoryScreen(), GuideScreen()];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Future<bool> _onWillPop() async {
    final bool? result = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Apakah anda yakin keluar aplikasi?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Ya'),
              ),
            ],
          ),
    );

    if (result == true) {
      // Keluar aplikasi sepenuhnya
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final NavigatorState navigator = Navigator.of(context);
        final bool shouldPop = await _onWillPop();
        if (shouldPop) {
          navigator.pop();
        }
      },
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Color(0xff7864f6),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Guide',
            ),
          ],
        ),
      ),
    );
  }
}
