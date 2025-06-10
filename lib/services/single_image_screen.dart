import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/yolo.dart';
// import 'package:ultralytics_yolo/yolo_view.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

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

  // Configure the single-image YOLO
  late YOLO _yolo;

  @override
  void initState() {
    super.initState();
    // Create the YOLO instance for single-image inference
    _yolo = YOLO(modelPath: 'yolo11n', task: YOLOTask.detect);

    // Optionally load model ahead of time
    _yolo.loadModel();
  }

  Future<void> _pickAndPredict() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    final bytes = await file.readAsBytes();
    final result = await _yolo.predict(bytes);
    setState(() {
      // Check if boxes exist and set them as detections
      if (result.containsKey('boxes') && result['boxes'] is List) {
        _detections = List<Map<String, dynamic>>.from(result['boxes']);
      } else {
        _detections = [];
      }

      // Check if annotated image exists
      if (result.containsKey('annotatedImage') &&
          result['annotatedImage'] is Uint8List) {
        _annotatedImage = result['annotatedImage'] as Uint8List;
      } else {
        _annotatedImage = null;
      }

      _imageBytes = bytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Single Image Inference'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickAndPredict,
            child: const Text('Pick Image & Run Inference'),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_annotatedImage != null)
                    SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Image.memory(_annotatedImage!),
                    )
                  else if (_imageBytes != null)
                    SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Image.memory(_imageBytes!),
                    ),
                  const SizedBox(height: 10),
                  const Text('Detections:'),
                  Text(_detections.toString()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
