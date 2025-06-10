// example/lib/main.dart
// import 'dart:typed_data';
import 'package:flutter/material.dart';
// import 'package:ultralytics_yolo/yolo.dart';
// YOLOResult is now imported through yolo.dart
// import 'package:ultralytics_yolo/yolo_view.dart';
// import 'package:image_picker/image_picker.dart';
import 'screens/home.dart';
import 'screens/history.dart';
import 'screens/guide.dart';

void main() {
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
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

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







