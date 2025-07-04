import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class LowEndOptimization {
  static YOLOStreamingConfig getOptimalConfig() {
    return YOLOStreamingConfig.powerSaving(
      inferenceFrequency: 5, // Very low frequency
      maxFPS: 10,
    );
  }

  static Map<String, double> getOptimalThresholds() {
    return {
      'confidence': 0.7, // High threshold for fewer detections
      'iou': 0.2, // Fast NMS
      'maxItems': 5.0, // Minimal detections
    };
  }
}
