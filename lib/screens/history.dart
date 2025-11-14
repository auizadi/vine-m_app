import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:yolo_grapevine/models/diseases_model.dart';
import 'package:yolo_grapevine/screens/detection_result_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        backgroundColor: Color(0xff7864f6),
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
                    formatClassName(result?.className ?? 'Unknown'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Akurasi: ${((result?.confidence ?? 0.0) * 100).toStringAsFixed(1)}%',
                      ),
                      Text('Waktu: ${_formatDate(result?.detectionTime)}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed:
                        () => _showDeleteConfirmation(context, box, index),
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

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown Date';
    final formatter = DateFormat('dd MMMM yyyy HH:mm');
    return formatter.format(dateTime);
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

  void _showDeleteConfirmation(
    BuildContext context,
    Box<DetectionHistory> box,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Konfirmasi Hapus',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Apakah Anda yakin ingin menghapus riwayat ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Tutup dialog
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await Future.delayed(const Duration(milliseconds: 300));
                if (context.mounted) {
                  await _deleteResult(context, box, index);
                }
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
