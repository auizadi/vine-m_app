import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:yolo_grapevine/models/diseases_model.dart';
import 'package:yolo_grapevine/main.dart';

class DetectionDetailScreen extends StatefulWidget {
  final String? imagePath;
  final String className;
  final double confidence;
  final int index;
  final bool isFromHistory;

  const DetectionDetailScreen({
    super.key,

    required this.className,
    required this.confidence,
    required this.index,
    this.isFromHistory = false,
    this.imagePath,
  });

  @override
  State<DetectionDetailScreen> createState() => _DetectionDetailScreenState();
}

class _DetectionDetailScreenState extends State<DetectionDetailScreen> {
  late Box<DetectionHistory> detectionBox;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    detectionBox = Hive.box<DetectionHistory>('detectionResults');
  }

  String _getPreventionSteps(String className) {
    // Tambahkan langkah pencegahan berdasarkan jenis penyakit
    switch (className.toLowerCase()) {
      case 'black rot':
        return '1. Buang daun yang terinfeksi\n2. Gunakan fungisida yang sesuai\n3. Jaga kebersihan kebun\n4. Pastikan sirkulasi udara baik';
      case 'esca':
        return '1. Potong bagian tanaman yang terinfeksi\n2. Gunakan fungisida pencegah\n3. Hindari luka pada batang\n4. Gunakan varietas tahan penyakit';
      case 'leaf blight':
        return '1. Semprot dengan fungisida tembaga\n2. Hindari penyiraman dari atas\n3. Jarak tanam yang cukup\n4. Rotasi tanaman';
      default:
        return '1. Isolasi tanaman yang sakit\n2. Gunakan pestisida organik\n3. Perbaiki drainase tanah\n4. Konsultasikan dengan ahli tanaman';
    }
  }

  Future<void> _saveResult() async {
    final result = DetectionHistory(
      className: widget.className,
      confidence: widget.confidence,
      imagePath: widget.imagePath ?? '',
      detectionTime: DateTime.now(),
      isSaved: true,
    );

    await detectionBox.add(result);

    if (!mounted) return;
    setState(() {
      isSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hasil deteksi berhasil disimpan'),
        duration: Duration(seconds: 1),
      ),
    );

    // Navigasi ke HistoryScreen
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScreen(initialIndex: 1),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Deteksi', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (widget.isFromHistory) {
              Navigator.pop(context);
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(initialIndex: 1),
                ),
                (route) => false,
              );
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar yang diupload
            Center(
              child:
                  widget.imagePath != null && widget.imagePath!.isNotEmpty
                      ? Image.file(
                        File(widget.imagePath!),
                        height: 200,
                        fit: BoxFit.contain,
                      )
                      : const Icon(
                        Icons.eco,
                        size: 100,
                        color: Colors.grey,
                      ),
            ),
            const SizedBox(height: 20),

            // Hasil deteksi
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hasil Deteksi',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Penyakit: '),
                        Text(
                          widget.className,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Akurasi: '),
                        Text(
                          '${(widget.confidence * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Langkah pencegahan
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Langkah Pencegahan',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(_getPreventionSteps(widget.className)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Tombol simpan
            if (!widget
                .isFromHistory) //hanya tampil jika bukan dari menu history
              Center(
                child: ElevatedButton.icon(
                  onPressed: isSaved ? null : _saveResult,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    'Simpan Hasil',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor: isSaved ? Colors.grey : Colors.purple,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
