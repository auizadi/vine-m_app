import 'package:hive/hive.dart';

part 'diseases_model.g.dart';

@HiveType(typeId: 0)
class DetectionHistory {
  @HiveField(0)
  final String className;

  @HiveField(1)
  final double confidence;

  @HiveField(2)
  final String imagePath;

  @HiveField(3)
  final DateTime detectionTime;

  @HiveField(4)
  bool isSaved;

  @HiveField(5)
  final bool isFirstLaunch;

  
  

  DetectionHistory({
    required this.className,
    required this.confidence,
    required this.imagePath,
    required this.detectionTime,
    this.isSaved = false,
    this.isFirstLaunch = true,
   
  });
}
