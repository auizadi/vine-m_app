import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Row(
        children: const [
          Icon(Icons.history, color: Colors.white),
          SizedBox(width: 8),
          Text('Riwayat Deteksi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
        ],
      ),
      backgroundColor: Colors.purple,),
      body: const Center(child: Text('Belum ada riwayat.')),
    );
  }
}
