import 'package:flutter/material.dart';
import 'package:yolo_grapevine/models/diseases_model.dart';
import '../services/camera_inference_screen.dart'; // Buat file ini dari CameraInferenceScreen
import '../services/single_image_screen.dart'; // Buat file ini dari SingleImageScreen
import 'package:lucide_icons/lucide_icons.dart';
import '../screens/info.dart';
import 'package:hive/hive.dart';
// import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.eco, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'VineCare',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.purple,
        actions: [
          Row(
            children: [
              FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                  CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
                ),
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Baca Info!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.info, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const InfoScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text(
                      'Camera\nInference',
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CameraDetectionScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    child: const Text(
                      'Single\nImage Inference',
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SingleImageScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
