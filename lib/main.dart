import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:yolo_grapevine/screens/detection_result_screen.dart';
import 'screens/home.dart';
import 'screens/history.dart';
import 'screens/guide.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/diseases_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DetectionHistoryAdapter());
  await Hive.openBox<DetectionHistory>('detectionResults');
  runApp(const GrapeMobileApp());
}

class GrapeMobileApp extends StatelessWidget {
  const GrapeMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
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
  void initState(){
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [HomeScreen(), HistoryScreen(), GuideScreen()];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.purple,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Guide'),
        ],
      ),
    );
  }

  
}







