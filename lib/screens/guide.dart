import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: const [
            Icon(Icons.menu_book, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Panduan Aplikasi',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xff7864f6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xff7864f6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deteksi Penyakit Daun\nTanaman Anggur',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'pelajari cara menggunakan aplikasi\nsecara efektif untuk hasil akurat.',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // step 1
            stepTitle(1, 'Ambil foto secara jelas'),
            stepImageHorizontal('android/app/src/main/assets/guide1.jpg'),
            stepBulletList([
              'Pastikan pencahayaan baik',
              'Pastikan fokus pada daun',
              'Potret daun',
            ]),

            // step 2
            stepTitle(2, 'Upload gambar'),
            stepImageHorizontal('android/app/src/main/assets/guide2.jpg'),
            stepBulletList([
              'Pastikan pencahayaan baik',
              'Pastikan resolusi gambar baik',
            ]),

            // step 3
            stepTitle(3, 'Hasil Deteksi'),
            stepImageHorizontal('android/app/src/main/assets/guide3.jpg'),
            const SizedBox(height: 12),
            stepIconLabel(LucideIcons.wheatOff, 'Identifikasi Penyakit'),
            stepIconLabel(LucideIcons.crosshair, 'Akurasi'),
            stepIconLabel(LucideIcons.clipboardList, 'Rekomendasi Perawatan'),

            const SizedBox(height: 24),
            const Text(
              'Pro Tips❗',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            stepIconText(
              Icons.lightbulb_outline,
              'Pindai daun ketika kondisi pencahayaan baik',
            ),
            stepIconText(
              Icons.pan_tool_outlined,
              'Tahan perangkat kamu tetap stabil sampai kotak deteksi muncul',
            ),
            stepIconText(
              Icons.watch_later_outlined,
              'Jika deteksi real-time tidak berjalan dengan baik, coba kembali kemudian pilih menu real-time lagi',
            ),
          ],
        ),
      ),
    );
  }

  Widget stepTitle(int number, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Color(0xff7864f6),
            child: Text('$number', style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget stepImageHorizontal(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: AspectRatio(
        aspectRatio: 16 / 9, // Rasio lebar:tinggi (bisa disesuaikan)
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xff7864f6),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo, color: Colors.white, size: 32),
                    SizedBox(height: 8),
                    Text(
                      'Gambar',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget stepBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          items
              .map(
                (e) => Row(
                  children: [
                    const Icon(Icons.check, size: 16, color: Colors.black45),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        e,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
    );
  }

  Widget stepIconLabel(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[400], size: 24),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }

  Widget stepIconText(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[400], size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
