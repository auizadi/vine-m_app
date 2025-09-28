import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yolo_grapevine/models/diseases_model.dart';
import 'package:yolo_grapevine/main.dart';

class DetectionDetailScreen extends StatefulWidget {
  final String? imagePath;
  final String className;
  final double confidence;
  final int index;
  final bool isFromHistory;
  final bool fromCamera;
  final Uint8List? imageData;

  const DetectionDetailScreen({
    super.key,
    required this.className,
    required this.confidence,
    required this.index,
    this.isFromHistory = false,
    this.imagePath,
    this.fromCamera = false,
    this.imageData,
  });

  @override
  State<DetectionDetailScreen> createState() => _DetectionDetailScreenState();
}

class _DetectionDetailScreenState extends State<DetectionDetailScreen> {
  late final Box<DetectionHistory> detectionBox;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    detectionBox = Hive.box<DetectionHistory>('detectionResults');
  }

  Map<String, Map<String, dynamic>> _getDiseaseDetails(String className) {
    switch (className) {
      case 'Healthy':
        return {
          'Status': {
            'content': ['Daun dalam kondisi sehat'],
            'icon': Icons.check_circle,
          },
          'Tips': {
            'content': [
              'Lanjutkan perawatan rutin',
              'Pantau kesehatan tanaman secara berkala',
              'Jaga kebersihan kebun',
              'Berikan pupuk secara teratur',
            ],
            'icon': Icons.thumb_up,
          },
        };

      case 'Downey_mildew':
        return {
          'Penyebab': {
            'content': ['Plasmopara Viticola'],
            'icon': Icons.warning,
          },
          'Gejala': {
            'content': [
              'Bintik-bintik kuning berbentuk lingkaran',
              'Bagian daun muncul bintik-bintik putih berupa jamur',
            ],
            'icon': Icons.visibility,
          },
          'Dampak': {
            'content': [
              'Daun yang terinfeksi parah berubah menjadi coklat dan gugur sebelum waktunya',
              'Jamur yang menginfeksi sampai ke buah akan menyebabkan busuk',
            ],
            'icon': Icons.pest_control,
          },
          'Pencegahan': {
            'content': [
              'Membuat sirkulasi udara yang baik pada lahan',
              'Menjaga kelembaban tanah tetap rendah',
              'Drainase yang baik mencegah air menggenang terlalu lama',
              'Pemilihan varietas yang bagus',
            ],
            'icon': Icons.shield,
          },
          'Penanganan': {
            'content': [
              'Memotong daun yang terinfeksi',
              'Pemberian campuran Bordeaux yang terdiri dari tembaga sulfat dan kapur yang dilarutkan dengan air',
            ],
            'icon': Icons.medical_services,
          },
        };
      case 'Black_rot':
        return {
          'Penyebab': {
            'content': ['Guignardian Bidwelli'],
            'icon': Icons.warning,
          },
          'Gejala': {
            'content': [
              'Terdapat bintik-bintik bulat hingga poligonal berwarna coklat kemerahan dengan tepi gelap',
              'Banyak bercak yang terisolasi atau menyatu dapat terbentuk dipermukaan daun',
            ],
            'icon': Icons.visibility,
          },
          'Dampak': {
            'content': [
              'Buah membusuk yang diawali dengan warna coklat dan secara bertahap mengkerut',
            ],
            'icon': Icons.pest_control,
          },
          'Pencegahan': {
            'content': [
              'Membuat sirkulasi udara yang baik pada lahan',
              'Perawatan tanaman lain disekitar lahan anggur agar tidak terinfeksi penyakit dari tanaman lain',
            ],
            'icon': Icons.shield,
          },
          'Penanganan': {
            'content': [
              'Memotong dan menghancurkan daun yang terinfeksi',
              'Pengaplikasian fungisida berupa campuran Bordeaux',
            ],
            'icon': Icons.medical_services,
          },
        };
      case 'Esca':
        return {
          'Penyebab': {
            'content': ['Jamur dari famili Phaemoniella dan Chlymydospora'],
            'icon': Icons.warning,
          },
          'Gejala': {
            'content': [
              'Daun berubah pucat dan kemudian menguning/memerah secara tidak teratur diantara urat daun dan kadang ditepi daun lama kelamaan daun akan mengering',
            ],
            'icon': Icons.visibility,
          },
          'Dampak': {
            'content': [
              'Buah dapat membusuk yang ditandai dengan bintik-bintik biru kehitaman yang disebut campak (measles)',
            ],
            'icon': Icons.pest_control,
          },
          'Pencegahan': {
            'content': [
              'Perendaman akar dengan air bersuhu 50°C selama 30 menit ketika pembibitan',
            ],
            'icon': Icons.shield,
          },
          'Penanganan': {
            'content': [
              'Pengaplikasian fungisida Benomyl, Prochloraz, Carbendazim + Flusilazole, dan Cyprodinil + Fludioxonil',
            ],
            'icon': Icons.medical_services,
          },
        };
      case 'Leaf_blight':
        return {
          'Penyebab': {
            'content': ['Bakteri Xylophilus Amplinus'],
            'icon': Icons.warning,
          },
          'Gejala': {
            'content': [
              'Daun yang terinfeksi akan membentuk lesi bersudut berwarna merah kecoklatan',
              'Sebagian daun berwarna kuning biasanya terjadi saat kelembapan tinggi',
            ],
            'icon': Icons.visibility,
          },
          'Dampak': {
            'content': [
              'Jika bakteri menginfeksi hingga tunas akan menyebabkan tunas tampak kerdil dan mati',
            ],
            'icon': Icons.pest_control,
          },
          'Pencegahan': {
            'content': [
              'Memastikan saat datang dan pergi ke kebun dalam keadaan bersih',
              'Memantau kehigienisan pengunjung yang masuk ke kebun',
              'Memilih pemasok bibit yang bereputasi baik sehingga bibit dapat terjamin kesehatannya',
            ],
            'icon': Icons.shield,
          },
          'Penanganan': {
            'content': [
              'Pengaplikasian fungisida campuran Bordeaux',
              'Pengaplikasian fungisida Mancozeb',
              'Pengaplikasian fungisida Topsin - M',
              'Pengaplikasian fungisida Captan',
              'Pengaplikasian fungisida Ziram',
            ],
            'icon': Icons.medical_services,
          },
        };
      default:
        return {
          'Informasi': {
            'content': [
              'Penyakit tanaman belum teridentifikasi secara spesifik',
            ],
            'icon': Icons.help,
            'color': Colors.grey,
          },
        };
    }
  }

  Future<void> _saveResult() async {
    if (widget.imagePath != null && File(widget.imagePath!).existsSync()) {
      final permanentDirectory = await getApplicationDocumentsDirectory();
      final timeStamp = DateTime.now().millisecondsSinceEpoch;
      final permanentImagePath =
          '${permanentDirectory.path}/saved_$timeStamp.jpg';

      // Copy file dari temporary ke permanent location
      await File(widget.imagePath!).copy(permanentImagePath);

      final result = DetectionHistory(
        className: widget.className,
        confidence: widget.confidence,
        imagePath: permanentImagePath, // Gunakan path yang permanen
        detectionTime: DateTime.now(),
        isSaved: true,
      );

      // Cek apakah sudah ada hasil deteksi yang sama (dengan toleransi waktu 5 menit)
      final alreadySaved = detectionBox.values.any(
        (item) =>
            item.className == widget.className &&
            item.confidence == widget.confidence &&
            (item.detectionTime.difference(DateTime.now()).inMinutes.abs() < 5),
      );

      if (alreadySaved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hasil deteksi sudah tersimpan'),
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        await detectionBox.add(result);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hasil deteksi berhasil disimpan'),
            duration: Duration(seconds: 1),
          ),
        );
      }

      // Hapus file temporary setelah disimpan
      try {
        await File(widget.imagePath!).delete();
      } catch (e) {
        print("Gagal menghapus file temporary: $e");
      }

      if (!mounted) return;
      setState(() => isSaved = true);

      // Tunggu sebentar sebelum navigasi
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen(initialIndex: 1)),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gambar tidak ditemukan"),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  // Method untuk menangani back button
  Future<bool> _onWillPop() async {
    if (widget.fromCamera && !widget.isFromHistory && !isSaved) {
      // Hapus file temporary jika user tidak menyimpan
      if (widget.imagePath != null && File(widget.imagePath!).existsSync()) {
        try {
          await File(widget.imagePath!).delete();
          print('File temporary dihapus: ${widget.imagePath}');
        } catch (e) {
          print('Gagal menghapus file temporary: $e');
        }
      }
    }
    return true;
  }

  Future<void> _handleBackButton() async {
    if (widget.fromCamera && !widget.isFromHistory && !isSaved) {
      // Hapus file temporary jika kembali tanpa menyimpan
      if (widget.imagePath != null && File(widget.imagePath!).existsSync()) {
        try {
          await File(widget.imagePath!).delete();
        } catch (e) {
          print('Gagal menghapus file temporary: $e');
        }
      }
    }

    if (widget.fromCamera) {
      Navigator.pop(context);
    } else if (widget.isFromHistory) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen(initialIndex: 1)),
        (route) => false,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final diseaseDetails = _getDiseaseDetails(widget.className);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Detail Deteksi',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff7864f6),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: _handleBackButton,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child:
                      widget.imageData != null
                          ? Image.memory(
                            widget.imageData!,
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          )
                          : (widget.imagePath != null &&
                              widget.imagePath!.isNotEmpty &&
                              File(widget.imagePath!).existsSync())
                          ? Image.file(
                            File(widget.imagePath!),
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          )
                          : const Icon(
                            Icons.eco,
                            size: 100,
                            color: Colors.grey,
                          ),
                ),
              ),
              const SizedBox(height: 24),

              _buildSection(
                title: 'Hasil Deteksi',
                children: [
                  _buildInfoRow('Penyakit', widget.className),
                  _buildInfoRow(
                    'Akurasi',
                    '${(widget.confidence * 100).toStringAsFixed(1)}%',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Detail Penyakit
              Column(
                children: [
                  for (var entry in diseaseDetails.entries)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              entry.value['icon'],
                              size: 20,
                              color: const Color(0xff7864f6),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff7864f6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildNumberedList(
                          List<String>.from(entry.value['content']),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            (!widget.isFromHistory && widget.className.isNotEmpty)
                ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton.icon(
                      onPressed: isSaved ? null : _saveResult,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Simpan Hasil',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor:
                            isSaved ? Colors.grey : const Color(0xff7864f6),
                      ),
                    ),
                  ),
                )
                : null,
      ),
    );
  }

  Widget _buildSection({
    required String title,
    IconData? icon,
    Color iconColor = const Color(0xff7864f6),
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) Icon(icon, size: 20, color: iconColor),
            if (icon != null) const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
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
                  backgroundColor: const Color(0xff7864f6),
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
}
