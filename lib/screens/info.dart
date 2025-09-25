import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Informasi Aplikasi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Color(0xff7864f6),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle('📌 Tentang Aplikasi'),
            sectionText(
              '''VineCare adalah aplikasi cerdas berbasis kecerdasan buatan untuk mendeteksi penyakit daun tanaman anggur secara otomatos. Aplikasi ini membantu petani dan penggiat tanaman menjaga kualitas tanaman mereka secara cepat dan efisien.''',
            ),
            const SizedBox(height: 16),
            sectionTitle('🌿 Jenis Penyakit yang Dideteksi'),
            _buildNumberedList(['Downy Mildew','Black Rot','Leaf Blight','Esca']),
           
            const SizedBox(height: 16),
            sectionTitle('📦 Fitur Aplikasi'),
            _buildNumberedList(['Deteksi Real-time','Deteksi dengan upload gambar', 'Simpan dan lihat riwayat deteksi', 'Panduan perawatan tanaman']),

            const SizedBox(height: 16),
            sectionTitle('🔒 Privasi & Data'),
            _buildNumberedList(['Aplikasi tidak menyimpan data pribadi pengguna', 'Gambar hanya digunakan untuk deteksi dan disimpan lokal', 'Semua data tersimpan aman di perangkat pengguna']),

            const SizedBox(height: 16),
            sectionTitle('📞 Kontak & Bantuan'),
            _buildNumberedList(['Email: dani@mail.com', 'Hubungi kami untuk saran, masukan, atau bantuan teknis']),

          ],
        ),
      ),
    );
  }
}

Widget sectionTitle(String text) {
  return Text(
    text,
    style: TextStyle(
      color: Color(0xff7864f6),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget sectionText(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 4.0),
    child: Text(
      text,
      style: TextStyle(fontSize: 14),
      textAlign: TextAlign.justify,
    ),
  );
}

Widget _buildNumberedList(List<String> items) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (int i = 0; i < items.length; i++)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Color(0xff7864f6),
                radius: 10,
                child: Text(
                  '${i + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  items[i],
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
    ],
  );
}
