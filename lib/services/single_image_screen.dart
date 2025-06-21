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
    yolo = YOLO(modelPath: 'model_int8', task: YOLOTask.detect);
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Single Image Detection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          backgroundColor: Colors.purple,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white,),
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
                              'No image selected',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
              ),
            ),
            // Expanded(
            //   flex: 3,
            //   child: Center(
            //     child:
            //         isLoading
            //             ? CircularProgressIndicator()
            //             : annotatedImage != null
            //             ? Image.memory(annotatedImage!)
            //             : selectedImage != null
            //             ? Image.file(selectedImage!)
            //             : Placeholder(),
            //   ),
            // ),

            // Detection results summary
            Container(
              padding: EdgeInsets.all(8),
              child: Text(
                'Detected ${results.length} objects',
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
                        detection['class'] ?? 'Unknown',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Confidence: ${(detection['confidence'] * 100).toStringAsFixed(1)}%',
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        if (selectedImage != null){
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => DetectionDetailScreen(imagePath: selectedImage!.path,
                               className: detection['class'] ?? 'Unknown', confidence: detection['confidence']?.toDouble() ?? 0.0,
                              index: index
                              ),
                            )
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
                  child: Text('Pick Image & Detect Objects'),
                ),
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
