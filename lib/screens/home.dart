import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:yolo_grapevine/services/camera_inference_screen.dart';
import 'package:yolo_grapevine/services/single_image_screen.dart';
import 'package:yolo_grapevine/screens/info.dart';
import 'package:yolo_grapevine/screens/carousel.dart';
import 'package:yolo_grapevine/models/detail_penyakit_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final List<DetailPenyakitCard> daftarPenyakit = [
    DetailPenyakitCard(
      nama: 'Downy Mildew',
      deskripsi: '(Bulai Berbulu Halus)',
      penyebab: ['Plasmopara Viticola'],
      gejala: [
        'Bintik-bintik kuning berbentuk lingkaran',
        'Bagian daun muncul bintik-bintik putih berupa jamur',
      ],
      dampak: [
        'Daun yang terinfeksi parah berubah menjadi coklat dan gugur sebelum waktunya',
        'Jamur yang menginfeksi sampai ke buah akan menyebabkan busuk',
      ],
      pencegahan: [
        'Membuat sirkulasi udara yang baik pada lahan',
        'Menjaga kelembaban tanah tetap rendah',
        'Drainase yang baik mencegah air menggenang terlalu lama',
        'Pemilihan varietas yang bagus',
      ],
      penanganan: [
        'Memotong daun yang terinfeksi',
        'Pemberian campuran Bordeaux yang terdiri dari tembaga sulfat dan kapur yang dilarutkan dengan air',
      ],
    ),

    DetailPenyakitCard(
      nama: 'Black Rot',
      deskripsi: '(Busuk Hitam)',
      penyebab: ['Guignardian Bidwelli'],
      gejala: [
        'Terdapat bintik-bintik bulat hingga poligonal berwarna coklat kemerahan dengan tepi gelap',
        'Banyak bercak yang terisolasi atau menyatu dapat terbentuk dipermukaan daun',
      ],
      dampak: [
        'Buah membusuk yang diawali dengan warna coklat dan secara bertahap mengkerut',
      ],
      pencegahan: [
        'Membuat sirkulasi udara yang baik pada lahan',
        'Perawatan tanaman lain disekitar lahan anggur agar tidak terinfekis penyakit dari tanaman lain',
      ],
      penanganan: [
        'Memotong dan menghancurkan daun yang terinfeksi',
        'Pengaplikasian fungisida berupa campuran Bordeaux',
      ],
    ),
    DetailPenyakitCard(
      nama: 'Esca',
      deskripsi: '(Campak Hitam)',
      penyebab: ['Jamur dari famili Phaemoniella dan Chlymydospora'],
      gejala: [
        'Daun berubah pucat dan kemudian menguning/memerah secara tidak teratur diantara urat daun dan kadang ditepi daun lama kelamaan daun akan mengering',
      ],
      dampak: [
        'Buah dapat membusuk yang ditandai dengan bintik-bintik biru kehitaman yang disebut campak (measles)',
      ],
      pencegahan: [
        'Perendaman akar dengan air bersuhu 50°C selama 30 menit ketika pembibitan',
      ],
      penanganan: [
        'Pengaplikasian fungisida Benomyl, Prochloraz, Carbendazim + Flusilazole, dan Cyprodinil + Fludioxonil',
      ],
    ),
    DetailPenyakitCard(
      nama: 'Leaf Blight',
      deskripsi: '(Hawar Daun)',
      penyebab: ['Bakteri Xylophilus Amplinus'],
      gejala: [
        'Daun yang terinfeksi akan membentuk lesi bersudut berwarna merah kecoklatan',
        'Sebagian daun berwarna kuning biasanya terjadi saat kelembapan tinggi',
      ],
      dampak: [
        'Jika bakteri menginfeksi hingga tunas akan menyebabkan tunas tampak kerdil dan mati',
      ],
      pencegahan: [
        'Memastikan saat datang dan pergi ke kebun dalam keadaan bersih',
        'Memantau kehigienisan pengunjung yang masuk ke kebun',
        'Memilih pemasok bibit yang bereputasi baik sehingga bibit dapat terjamin kesehatannya',
      ],
      penanganan: [
        'Pengaplikasian fungisida campuran Bordeaux',
        'Pengaplikasian fungisida Mancozeb',
        'Pengaplikasian fungisida Topsin - M',
        'Pengaplikasian fungisida Captan',
        'Pengaplikasian fungisida Ziram',
      ],
    ),
  ];

  late AnimationController _controller;

  String _nama = 'Pengguna';
  String _imagePath = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final profileBox = await Hive.openBox('userProfile');
      setState(() {
        _nama = profileBox.get('nama', defaultValue: 'Pengguna');
        _imagePath = profileBox.get('imagePath', defaultValue: '');
      });
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: const [
            Icon(Icons.eco, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'VineCare',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xff7864f6),
        actions: [
          Row(
            children: [
              FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                  CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
                ),
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Baca Info!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.info, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const InfoScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            // Profile Section
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        _imagePath.isNotEmpty
                            ? FileImage(File(_imagePath))
                            : const AssetImage('assets/default_profile.png')
                                as ImageProvider,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Selamat Datang,',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        _nama.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 17),
            // carousel
            const ComplicatedImageDemo(),
            const SizedBox(height: 35),
            // button
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        /// The above Dart code is creating a MaterialPageRoute that navigates to the
                        /// CameraDetectionScreen widget when triggered.
                        MaterialPageRoute(
                          builder: (_) => const CameraDetectionScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff7864f6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Real-Time',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SingleImageScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff7864f6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Upload',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                child: Text(
                  'Penyakit Daun',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    daftarPenyakit.map((penyakit) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => DetailPenyakitCard(
                                    nama: penyakit.nama,
                                    deskripsi: penyakit.deskripsi,
                                    penyebab: penyakit.penyebab,
                                    gejala: penyakit.gejala,
                                    dampak: penyakit.dampak,
                                    pencegahan: penyakit.pencegahan,
                                    penanganan: penyakit.penanganan,
                                  ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'android/app/src/main/assets/images/${penyakit.nama.toLowerCase().replaceAll(' ', '_')}.jpg',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey,
                                            size: 36,
                                          ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      penyakit.nama,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      penyakit.deskripsi,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                size: 24,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
