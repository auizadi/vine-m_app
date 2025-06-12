import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/yolo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

// Hive model class for detection history
@HiveType(typeId: 0)
class DetectionHistory {
  @HiveField(0)
  final Uint8List imageBytes;
  
  @HiveField(1)
  final Uint8List? annotatedImage;
  
  @HiveField(2)
  final List<Map<String, dynamic>> detections;
  
  @HiveField(3)
  final DateTime timestamp;
  
  DetectionHistory({
    required this.imageBytes,
    this.annotatedImage,
    required this.detections,
    required this.timestamp,
  });
}

class DetectionHistoryAdapter extends TypeAdapter<DetectionHistory> {
  @override
  final int typeId = 0;

  @override
  DetectionHistory read(BinaryReader reader) {
    return DetectionHistory(
      imageBytes: reader.read() as Uint8List,
      annotatedImage: reader.read() as Uint8List?,
      detections: List<Map<String, dynamic>>.from(reader.read() as List),
      timestamp: DateTime.parse(reader.read() as String),
    );
  }

  @override
  void write(BinaryWriter writer, DetectionHistory obj) {
    writer.write(obj.imageBytes);
    writer.write(obj.annotatedImage);
    writer.write(obj.detections);
    writer.write(obj.timestamp.toIso8601String());
  }
}

class SingleImageScreen extends StatefulWidget {
  const SingleImageScreen({super.key});

  @override
  State<SingleImageScreen> createState() => _SingleImageScreenState();
}

class _SingleImageScreenState extends State<SingleImageScreen> {
  final _picker = ImagePicker();
  List<Map<String, dynamic>> _detections = [];
  Uint8List? _imageBytes;
  Uint8List? _annotatedImage;
  late YOLO _yolo;
  Box<DetectionHistory>? _historyBox;
  bool _isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    _yolo = YOLO(modelPath: 'yolo11n', task: YOLOTask.detect);
    _yolo.loadModel();
    _initHive();
  }

 Future<void> _initHive() async {
    try {
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(DetectionHistoryAdapter());
      }
      _historyBox = await Hive.openBox<DetectionHistory>('detection_history');
      setState(() {
        _isHiveInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing Hive: $e');
      // Handle error appropriately
    }
  }

  Future<void> _pickAndPredict() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    final bytes = await file.readAsBytes();
    final result = await _yolo.predict(bytes);
    
    setState(() {
      _detections = result.containsKey('boxes') && result['boxes'] is List 
          ? List<Map<String, dynamic>>.from(result['boxes']) 
          : [];
      
      _annotatedImage = result.containsKey('annotatedImage') && 
          result['annotatedImage'] is Uint8List
          ? result['annotatedImage'] as Uint8List
          : null;
      
      _imageBytes = bytes;
    });
  }

  Future<void> _saveDetection() async {
    if (_imageBytes == null || !_isHiveInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot save: No image or database not ready'),
        ),
      );
      return;
    }

    try {
      final historyItem = DetectionHistory(
        imageBytes: _imageBytes!,
        annotatedImage: _annotatedImage,
        detections: _detections,
        timestamp: DateTime.now(),
      );

      await _historyBox!.add(historyItem);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Detection saved to history')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: ${e.toString()}')),
      );
    }
  }

  Widget _buildDetectionItem(Map<String, dynamic> detection) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detection['class'] ?? 'Unknown',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text('Confidence: ${(detection['confidence'] as double).toStringAsFixed(2)}'),
            Text('Position: (${detection['x']?.toStringAsFixed(1)}, ${detection['y']?.toStringAsFixed(1)})'),
            Text('Size: ${detection['width']?.toStringAsFixed(1)} × ${detection['height']?.toStringAsFixed(1)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(DetectionHistory item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.memory(
              item.annotatedImage ?? item.imageBytes,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMM dd, yyyy - HH:mm').format(item.timestamp),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Detected ${item.detections.length} objects',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (item.detections.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    children: item.detections
                        .take(3)
                        .map((d) => Chip(
                              label: Text(
                                '${d['class']} (${(d['confidence'] as double).toStringAsFixed(1)})',
                                style: const TextStyle(fontSize: 12),
                              ),
                              visualDensity: VisualDensity.compact,
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Object Detection'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.camera_alt), text: 'Detect'),
              Tab(icon: Icon(Icons.history), text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Detection Tab
            Column(
              children: [
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickAndPredict,
                  child: const Text('Pick Image & Run Inference'),
                ),
                const SizedBox(height: 10),
                if (_imageBytes != null) ...[
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Image.memory(_annotatedImage ?? _imageBytes!),
                  ),
                  const SizedBox(height: 10),
                  if (_detections.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Detected ${_detections.length} objects',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _saveDetection,
                            icon: const Icon(Icons.save),
                            label: const Text('Save'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _detections.length,
                        itemBuilder: (context, index) => 
                            _buildDetectionItem(_detections[index]),
                      ),
                    ),
                  ] else ...[
                    const Expanded(
                      child: Center(
                        child: Text('No objects detected'),
                      ),
                    ),
                  ],
                ] else ...[
                  const Expanded(
                    child: Center(
                      child: Text('Pick an image to start detection'),
                    ),
                  ),
                ],
              ],
            ),
            
            // History Tab
            _isHiveInitialized
                ? ValueListenableBuilder(
                    valueListenable: _historyBox!.listenable(),
                    builder: (context, Box<DetectionHistory> box, _)
             {
                if (box.isEmpty) {
                  return const Center(
                    child: Text('No detection history yet'),
                  );
                }
                
                final items = box.values.toList().reversed.toList();
                
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) => 
                      _buildHistoryCard(items[index]),
                );
              },
                )
                : const Center (child: CircularProgressIndicator(),)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // _yolo.dispose();
    Hive.close();
    super.dispose();
  }
}