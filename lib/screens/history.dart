import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yolo_grapevine/models/diseases_model.dart';
import 'package:yolo_grapevine/screens/detection_result_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.history, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Riwayat Deteksi',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.purple,
      ),
      body: ValueListenableBuilder(
        valueListenable:
            Hive.box<DetectionHistory>('detectionResults').listenable(),
        builder: (context, Box<DetectionHistory> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Belum ada riwayat.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final result = box.getAt(index);
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading:
                      result?.imagePath != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(result!.imagePath),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.eco, size: 50);
                              },
                            ),
                          )
                          : const Icon(Icons.photo, size: 50),
                  title: Text(
                    result?.className ?? 'Unknown',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Akurasi: ${((result?.confidence ?? 0.0) * 100).toStringAsFixed(1)}%',
                      ),
                      Text(
                        'Tanggal: ${result?.detectionTime.toString().substring(0, 16)}',
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteResult(context, box, index),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => DetectionDetailScreen(
                              imagePath: result?.imagePath ?? '',
                              className: result?.className ?? 'Unknown',
                              confidence: result?.confidence ?? 0,
                              index: index,
                              isFromHistory: true,
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteResult(
    BuildContext context,
    Box<DetectionHistory> box,
    int index,
  ) async {
    // Show loading immediately
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Menghapus riwayat...'),
        duration: Duration(seconds: 1),
      ),
    );

    try {
      await box.deleteAt(index);

      // Check if widget is still mounted before using context
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Riwayat dihapus'),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menghapus riwayat')));
    }
  }
}
