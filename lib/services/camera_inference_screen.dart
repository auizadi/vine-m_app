// import 'package:ultralytics_yolo/yolo_view.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:yolo_grapevine/models/diseases_model.dart';
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
  bool _isSaving = false;

  Future<void> _captureFrameWithDetection() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
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
          )
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
      if(mounted){
        setState(() {
          _isSaving = false;
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
    final diseaseData =
        selectedResult != null
            ? getDiseaseDetailsHelper(selectedResult!.className)
            : {};
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
                                  for (var entry in diseaseData.entries) ...[
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Icon(
                                          entry.value['icon'],
                                          size: 20,
                                          color: Colors.purple,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          entry.key,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.purple,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    if (entry.value['content'] is List)
                                      _buildNumberedList(entry.value['content'])
                                    else if (entry.value['content'] is String)
                                      Text(entry.value['content']),
                                    const SizedBox(height: 16),
                                  ],
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
                                              fromCamera: true,
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
      floatingActionButton: _isSaving
          ? const CircularProgressIndicator()
          : FloatingActionButton(
            onPressed: _captureFrameWithDetection,
            child: const Icon(Icons.camera_alt),
          )
    );
  }

  Widget _buildNumberedList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Purple circular number
                CircleAvatar(
                  backgroundColor: Colors.purple,
                  radius: 14,
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Content text
                Expanded(
                  child: Text(items[i], style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
      ],
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

  // Widget _buildDetailRow(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 12),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(
  //           width: 80,
  //           child: Text(
  //             label,
  //             style: const TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //         const Text(': '),
  //         Expanded(child: Text(value)),
  //       ],
  //     ),
  //   );
  // }
}
