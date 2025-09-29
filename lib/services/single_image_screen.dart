import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ultralytics_yolo/yolo.dart';
import 'package:yolo_grapevine/screens/detection_result_screen.dart';

class SingleImageScreen extends StatefulWidget {
  const SingleImageScreen({super.key});

  @override
  State<SingleImageScreen> createState() => _SingleImageScreenState();
}

class _SingleImageScreenState extends State<SingleImageScreen> {
  YOLO? yolo;
  File? selectedImage;
  Uint8List? annotatedImage;
  List<dynamic> results = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadYOLO();
  }

  Future<void> loadYOLO() async {
    setState(() => isLoading = true);
    yolo = YOLO(
      modelPath: 'nadam2-best_int8',
      useGpu: false,
      task: YOLOTask.detect,
    );
    await yolo!.loadModel();
    setState(() => isLoading = false);
  }

  Future<void> pickAndDetect() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
        isLoading = true;
        results = [];
        annotatedImage = null;
      });

      final imageBytes = await selectedImage!.readAsBytes();
      final detectionResults = await yolo!.predict(imageBytes);

      setState(() {
        results = detectionResults['boxes'] ?? [];
        annotatedImage = detectionResults['annotatedImage'] as Uint8List?;
        isLoading = false;
      });
    }
  }

  String formatClassName(String className) {
    final specialCases = {
      'Downey_mildew': 'Downy Mildew',
      'Leaf_blight': 'Leaf Blight',
      'Black_rot': 'Black Rot',
      'Esca': 'Esca',
      'Healthy': 'Daun Sehat',
    };

    return specialCases[className] ??
        className
            .replaceAll('_', ' ')
            .split(' ')
            .map((word) {
              if (word.isEmpty) return '';
              return word[0].toUpperCase() + word.substring(1).toLowerCase();
            })
            .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Deteksi Gambar Tunggal',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          backgroundColor: Color(0xff7864f6),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: [
            // Image display area
            Expanded(
              flex: 3,
              child: Center(
                child:
                    isLoading
                        ? CircularProgressIndicator()
                        : annotatedImage != null
                        ? Image.memory(annotatedImage!)
                        : selectedImage != null
                        ? Image.file(selectedImage!)
                        : Column(
                          // Ganti Placeholder()
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_library,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Tidak ada gambar yang dipilih',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
              ),
            ),

            // Detection results summary
            Container(
              padding: EdgeInsets.all(8),
              child: Text(
                'Objek yang terdeteksi ${results.length}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            // Detection details list
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final detection = results[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(
                        formatClassName(detection['class'] ?? 'Unknown'),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Akurasi: ${(detection['confidence'] * 100).toStringAsFixed(1)}%',
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        if (selectedImage != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => DetectionDetailScreen(
                                    imagePath: selectedImage!.path,
                                    className: detection['class'] ?? 'Unknown',
                                    confidence:
                                        detection['confidence']?.toDouble() ??
                                        0.0,
                                    index: index,
                                  ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),

            // Detection button
            Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: yolo != null ? pickAndDetect : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Upload Gambar dan Deteksi'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
