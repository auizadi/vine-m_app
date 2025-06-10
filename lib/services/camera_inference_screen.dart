import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/yolo.dart';
import 'package:ultralytics_yolo/yolo_view.dart';

class CameraInferenceScreen extends StatefulWidget {
  const CameraInferenceScreen({super.key});

  @override
  State<CameraInferenceScreen> createState() => _CameraInferenceScreenState();
}

class _CameraInferenceScreenState extends State<CameraInferenceScreen> {
  int _detectionCount = 0;
  double _confidenceThreshold = 0.7;
  double _iouThreshold = 0.5;
  String _lastDetection = "";

  // Method 1: Create a controller to interact with the YoloView
  final _yoloController = YoloViewController();

  // Method 2: Create a GlobalKey to access the YoloView directly
  final _yoloViewKey = GlobalKey<YoloViewState>();

  // Flag to toggle between using controller and direct key access
  // This is just for demonstration - normally you'd pick one approach
  bool _useController = true;

  void _onDetectionResults(List<YOLOResult> results) {
    if (!mounted) return;

    debugPrint('_onDetectionResults called with ${results.length} results');

    // Print details of the first few detections for debugging
    for (var i = 0; i < results.length && i < 3; i++) {
      final r = results[i];
      debugPrint(
        '  Detection $i: ${r.className} (${(r.confidence * 100).toStringAsFixed(1)}%) at ${r.boundingBox}',
      );
    }

    // Make sure to actually update the state
    setState(() {
      _detectionCount = results.length;
      if (results.isNotEmpty) {
        // Get detection with highest confidence
        final topDetection = results.reduce(
          (a, b) => a.confidence > b.confidence ? a : b,
        );
        _lastDetection =
            "${topDetection.className} (${(topDetection.confidence * 100).toStringAsFixed(1)}%)";

        debugPrint(
          'Updated state: count=$_detectionCount, top=$_lastDetection',
        );
      } else {
        _lastDetection = "None";
        debugPrint('Updated state: No detections');
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // Set initial thresholds via controller
    // We do this in a post-frame callback to ensure the view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_useController) {
        _yoloController.setThresholds(
          confidenceThreshold: _confidenceThreshold,
          iouThreshold: _iouThreshold,
        );
      } else {
        _yoloViewKey.currentState?.setThresholds(
          confidenceThreshold: _confidenceThreshold,
          iouThreshold: _iouThreshold,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Inference'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Toggle button to switch between controller and direct access methods
          // This is just for demonstration purposes
          IconButton(
            icon: Icon(_useController ? Icons.gamepad : Icons.key),
            tooltip:
                _useController ? 'Using Controller' : 'Using Direct Access',
            onPressed: () {
              setState(() {
                _useController = !_useController;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Panel to display detection count and last detection class
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.black.withValues(alpha: 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Detection count: $_detectionCount'),
                Text('Top detection: $_lastDetection'),
              ],
            ),
          ),
          // Confidence threshold slider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text('Confidence threshold: '),
                Expanded(
                  child: Slider(
                    value: _confidenceThreshold,
                    min: 0.1,
                    max: 0.9,
                    divisions: 8,
                    label: _confidenceThreshold.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _confidenceThreshold = value;
                        // Update threshold via controller or direct key access
                        if (_useController) {
                          _yoloController.setConfidenceThreshold(value);
                        } else {
                          _yoloViewKey.currentState?.setConfidenceThreshold(
                            value,
                          );
                        }
                      });
                    },
                  ),
                ),
                Text('${(_confidenceThreshold * 100).toInt()}%'),
              ],
            ),
          ),
          // IoU threshold slider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text('IoU threshold: '),
                Expanded(
                  child: Slider(
                    value: _iouThreshold,
                    min: 0.1,
                    max: 0.9,
                    divisions: 8,
                    label: _iouThreshold.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _iouThreshold = value;
                        // Update threshold via controller or direct key access
                        if (_useController) {
                          _yoloController.setIoUThreshold(value);
                        } else {
                          _yoloViewKey.currentState?.setIoUThreshold(value);
                        }
                      });
                    },
                  ),
                ),
                Text('${(_iouThreshold * 100).toInt()}%'),
              ],
            ),
          ),
          // Camera view
          Expanded(
            child: Container(
              color: Colors.black12,
              child: YoloView(
                // Use GlobalKey or controller based on flag
                key: _useController ? null : _yoloViewKey,
                controller: _useController ? _yoloController : null,
                modelPath: 'yolo11n',
                task: YOLOTask.detect,
                onResult: _onDetectionResults,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
