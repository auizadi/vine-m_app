// import 'package:ultralytics_yolo/yolo_view.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:yolo_grapevine/models/diseases_model.dart';
import 'package:yolo_grapevine/optimization/device_specific_opt.dart';
// import 'dart:developer' as developer;
import 'package:yolo_grapevine/screens/detection_result_screen.dart';

// For even better practice:
class CameraDetectionScreen extends StatefulWidget {
  const CameraDetectionScreen({super.key});

  @override
  State<CameraDetectionScreen> createState() => _CameraDetectionScreenState();
}

class _CameraDetectionScreenState extends State<CameraDetectionScreen> {
  late YOLOViewController controller;
  // late PerformanceOptimizer optimizer;
  List<YOLOResult> currentResults = [];
  YOLOResult? selectedResult;
  // bool isSheetVisible = false;
  DateTime? lastDetectionTime;
  double? currentFPS;
  double? currentProcessingTime;
  bool _isSaving = false;
  bool _isCapturing = false;

  Future<void> _captureFrameWithDetection() async {
    if (_isSaving || _isCapturing) return;
    if (selectedResult == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada objek terdeteksi')),
      );
      return;
    }
    setState(() {
      _isSaving = true;
      _isCapturing = true;
    });
    try {
      final capturedImage = await controller.captureFrame();

      if (capturedImage != null && selectedResult != null) {
        // simpan gambar
        final directory = await getApplicationCacheDirectory();
        final timeStamp = DateTime.now().millisecondsSinceEpoch;
        final imagePath = '${directory.path}/capture_$timeStamp.jpg';
        await File(imagePath).writeAsBytes(capturedImage);
        final detectionBox = Hive.box<DetectionHistory>('detectionResults');

        // simpan history
        await detectionBox.add(
          DetectionHistory(
            className: selectedResult!.className,
            confidence: selectedResult!.confidence,
            imagePath: imagePath,
            detectionTime: DateTime.now(),
            isSaved: true,
          ),
        );

        if (!mounted) return;
        // navigasi ke detail screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => DetectionDetailScreen(
                  className: selectedResult!.className,
                  confidence: selectedResult!.confidence,
                  index: detectionBox.length - 1,
                  isFromHistory: false,
                  fromCamera: true,
                  imagePath: imagePath,
                ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _isCapturing = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller = YOLOViewController();
  }

  void _handleDetectionResult(List<YOLOResult> results) {
    if (_isCapturing) return;

    if (results.isEmpty) {
      setState(() {
        currentResults = [];
        selectedResult = null;
      });
    } else {
      setState(() {
        currentResults = results;
        selectedResult = results.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Deteksi Real-Time',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Color(0xff7864f6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Camera view with YOLO processing
          YOLOView(
            modelPath: 'model_int8',
            task: YOLOTask.detect,
            controller: controller,
            streamingConfig: LowEndOptimization.getOptimalConfig(),
            onPerformanceMetrics: (metrics) {
              setState(() {
                currentFPS = metrics.fps;
                currentProcessingTime = metrics.processingTimeMs;
              });
            },
            onResult: _handleDetectionResult,
          ),

          // Overlay UI
          Positioned(
            top: 50,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Objects: ${currentResults.length}',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 8),

                if (currentFPS != null)
                  _buildMetricChip('FPS: ${currentFPS!.toStringAsFixed(1)}'),
                if (currentProcessingTime != null)
                  _buildMetricChip(
                    'Time: ${currentProcessingTime!.toStringAsFixed(1)}ms',
                  ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton:
          _isSaving
              ? const CircularProgressIndicator()
              : FloatingActionButton(                       
                onPressed: _captureFrameWithDetection,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                child: const Icon(Icons.camera_alt),

              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildMetricChip(String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
