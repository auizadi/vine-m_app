// import 'package:ultralytics_yolo/yolo_view.dart';
import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'dart:developer' as developer;
import 'package:yolo_grapevine/services/prevention_helper.dart';

// For even better practice:
class CameraDetectionScreen extends StatefulWidget {
  const CameraDetectionScreen({super.key});

  @override
  State<CameraDetectionScreen> createState() => _CameraDetectionScreenState();
}

class _CameraDetectionScreenState extends State<CameraDetectionScreen> {
  late YOLOViewController controller;
  List<YOLOResult> currentResults = [];
  YOLOResult? selectedResult;
  bool isSheetVisible = false;
  DateTime? lastDetectionTime;

  @override
  void initState() {
    super.initState();
    controller = YOLOViewController();
  }

  void _handleDetectionResult(YOLOResult result) {
    final now = DateTime.now();

    // jika tidak sedang tampil atau hasil baru (class berbeda) atau jeda > 2 detik
    if (!isSheetVisible ||
    selectedResult?.className != result.className ||
    (lastDetectionTime != null && 
    now.difference(lastDetectionTime!).inSeconds > 2)) {
      setState(() {
        selectedResult = result;
        isSheetVisible = true;
        lastDetectionTime = now;
      });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Camera Detection',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.purple,
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
            onResult: (results) {
              if (results.isNotEmpty) {
                _handleDetectionResult(results.first);
              }
              setState(() {
                currentResults = results;
              });
            },
            onPerformanceMetrics: (metrics) {
              developer.log(
                'Performance Metrics',
                name: 'CameraDetection',
                error: {
                  'FPS': metrics.fps.toString(),
                  'ProcessingTime':
                      '${metrics.processingTimeMs.toStringAsFixed(1)}ms',
                },
              );
            },
          ),

          // Overlay UI
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),

              child: Text(
                'Objects: ${currentResults.length}',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          if (isSheetVisible && selectedResult != null)
            DraggableScrollableSheet(
              initialChildSize: 0.35,
              minChildSize: 0.2,
              maxChildSize: 0.85,
              builder:
                  (context, scrollController) => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(blurRadius: 5, color: Colors.black26),
                      ],
                    ),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Center(
                          child: Container(
                            width: 50,
                            height: 5,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Text(
                          'Deteksi Penyakit',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Penyakit: ${selectedResult!.className}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Akurasi: ${(selectedResult!.confidence * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          getPreventionSteps(selectedResult!.className),
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.close, color: Colors.white,),
                            label: const Text('Tutup',style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                            ),
                            onPressed: () {
                              setState(() {
                                isSheetVisible = false;
                                selectedResult = null;
                              });
                            },
                          ),
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
