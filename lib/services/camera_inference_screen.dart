// import 'package:ultralytics_yolo/yolo_view.dart';
import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:yolo_grapevine/optimization/device_specific_opt.dart';
// import 'dart:developer' as developer;
import 'package:yolo_grapevine/services/prevention_helper.dart';
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
  bool isSheetVisible = false;
  DateTime? lastDetectionTime;
  double? currentFPS;
  double? currentProcessingTime;

  @override
  void initState() {
    super.initState();
    controller = YOLOViewController();
    // optimizer = PerformanceOptimizer(controller);
    // optimizer.optimizeForSpeed();
  }

  void _handleDetectionResult(List<YOLOResult> results) {
    if (results.isEmpty) {
      setState(() {
        currentResults = [];
        isSheetVisible = false;
        selectedResult = null;
      });
    } else {
      setState(() {
        currentResults = results;
        selectedResult = results.first;
        isSheetVisible = true;
        lastDetectionTime = DateTime.now();
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
            streamingConfig: MidRangeOptimization.getOptimalConfig(),
            onPerformanceMetrics: (metrics) {
              setState(() {
                currentFPS = metrics.fps;
                currentProcessingTime = metrics.processingTimeMs;
              });
            },
            onResult: _handleDetectionResult,
            // onPerformanceMetrics: (metrics) {
            //   developer.log(
            //     'Performance Metrics',
            //     name: 'CameraDetection',
            //     error: {
            //       'FPS': metrics.fps.toString(),
            //       'ProcessingTime':
            //           '${metrics.processingTimeMs.toStringAsFixed(1)}ms',
            //     },
            //   );
            // },
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
          if (isSheetVisible && selectedResult != null)
            DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.2,
              maxChildSize: 0.85,
              snap: true,
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
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 5,
                          margin: const EdgeInsets.only(top: 10, bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Deteksi Penyakit',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildDetailRow(
                                    'Penyakit',
                                    selectedResult!.className,
                                  ),
                                  _buildDetailRow(
                                    'Akurasi',
                                    '${(selectedResult!.confidence * 100).toStringAsFixed(1)}%',
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Langkah Pencegahan',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    getPreventionSteps(
                                      selectedResult!.className,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed:
                                      () => setState(
                                        () => isSheetVisible = false,
                                      ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text(
                                    "Tutup",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => DetectionDetailScreen(
                                              className:
                                                  selectedResult!.className,
                                              confidence:
                                                  selectedResult!.confidence,
                                              index: 0,
                                              isFromHistory: false,
                                            ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text(
                                    'Detail',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
