import 'package:flutter/material.dart';
import '../services/camera_inference_screen.dart'; // Buat file ini dari CameraInferenceScreen
import '../services/single_image_screen.dart'; // Buat file ini dari SingleImageScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Row(
        children: const [
          Icon(Icons.eco, color: Colors.white),
          SizedBox(width: 8),
          Text('VineCare',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
        ],
      ),
      backgroundColor: Colors.purple,),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Camera\nInference', textAlign: TextAlign.center,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CameraInferenceScreen(),
                  ),
                );
              },
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              child: const Text('Single\nImage Inference', textAlign: TextAlign.center,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SingleImageScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
