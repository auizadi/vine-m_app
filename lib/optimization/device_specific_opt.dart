import 'package:ultralytics_yolo/ultralytics_yolo.dart';
class MidRangeOptimization {
  static YOLOStreamingConfig getOptimalConfig() {
    return YOLOStreamingConfig.throttled(
      maxFPS: 15,
      includeMasks: false, // Disable expensive features
      includeOriginalImage: false,
    );
  }

  static Map<String, double> getOptimalThresholds() {
    return {
      'confidence': 0.5, // Balanced threshold
      'iou': 0.4,
      'maxItems': 20.0,
    };
  }
}
