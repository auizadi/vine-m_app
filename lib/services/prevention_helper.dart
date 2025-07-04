import 'package:flutter/material.dart';
Map<String, Map<String, dynamic>> getDiseaseDetailsHelper(String className) {
  switch (className) {
    case 'Healthy':
      return {
        'Status': {
          'content': 'Daun dalam kondisi sehat',
          'icon': Icons.check_circle,
        },
        'Tips': {
          'content':
              '1. Lanjutkan perawatan rutin\n2. Pantau kesehatan tanaman secara berkala\n3. Jaga kebersihan kebun\n4. Berikan pupuk secara teratur',
          'icon': Icons.thumb_up,
        },
      };

    case 'Downey_mildew':
      return {
        'Penyebab': {'content': 'Plasmopara Viticola', 'icon': Icons.warning},
        'Gejala': {
          'content':
              '1. Bintik-bintik kuning berbentuk lingkaran\n2. Bagian daun muncul bintik-bintik putih berupa jamur',
          'icon': Icons.visibility,
        },
        'Dampak': {
          'content':
              '1. Daun yang terinfeksi parah berubah menjadi coklat dan gugur sebelum waktunya\n2. Jamur yang menginfeksi sampai ke buah akan menyebabkan busuk',
          'icon': Icons.pest_control,
        },
        'Pencegahan': {
          'content':
              '1. Membuat sirkulasi udara yang baik pada lahan\n2. Menjaga kelembaban tanah tetap rendah\n3.Drainase yang baik mencegah air menggenang terlalu lama\n4. Pemilihan varietas yang bagus',
          'icon': Icons.shield,
        },
        'Penanganan': {
          'content':
              '1. Memotong daun yang terinfeksi\n2. Pemberian campuran Bordeaux yang terdiri dari tembaga sulfat dan kapur yang dilarutkan dengan air',
          'icon': Icons.medical_services,
        },
      };
    case 'Black_rot':
      return {
        'Penyebab': {'content': 'Guignardian Bidwelli', 'icon': Icons.warning},
        'Gejala': {
          'content':
              '1. Terdapat bintik-bintik bulat hingga poligonal berwarna coklat kemerahan dengan tepi gelap\n2. Banyak bercak yang terisolasi atau menyatu dapat terbentuk dipermukaan daun',
          'icon': Icons.visibility,
        },
        'Dampak': {
          'content':
              '1. Buah membusuk yang diawali dengan warna coklat dan secara bertahap mengkerut',
          'icon': Icons.pest_control,
        },
        'Pencegahan': {
          'content':
              '1. Membuat sirkulasi udara yang baik pada lahan\n2. Perawatan tanaman lain disekitar lahan anggur agar tidak terinfekis penyakit dari tanaman lain',
          'icon': Icons.shield,
        },
        'Penanganan': {
          'content':
              '1. Memotong dan menghancurkan daun yang terinfeksi\n2. Pengaplikasian fungisida berupa campuran Bordeaux',
          'icon': Icons.medical_services,
        },
      };
    case 'Esca':
      return {
        'Penyebab': {
          'content': 'Jamur dari famili Phaemoniella dan Chlymydospora',
          'icon': Icons.warning,
        },
        'Gejala': {
          'content':
              '1. Daun berubah pucat dan kemudian menguning/memerah secara tidak teratur diantara urat daun dan kadang ditepi daun lama kelamaan daun akan mengering',
          'icon': Icons.visibility,
        },
        'Dampak': {
          'content':
              '1. Buah dapat membusuk yang ditandai dengan bintik-bintik biru kehitaman yang disebut campak (measles)',
          'icon': Icons.pest_control,
        },
        'Pencegahan': {
          'content':
              '1. Perendaman akar dengan air bersuhu 50°C selama 30 menit ketika pembibitan',
          'icon': Icons.shield,
        },
        'Penanganan': {
          'content':
              '1. Penaplikasian fungisida Benomyl, Prochloraz, Carbendazim + Flusilazole, dan Cyprodinil + Fludioxonil',
          'icon': Icons.medical_services,
        },
      };
    case 'Leaf_blight':
      return {
        'Penyebab': {
          'content': 'Bakteri Xylophilus Amplinus',
          'icon': Icons.warning,
        },
        'Gejala': {
          'content':
              '1. Daun yang terinfeksi akan membentuk lesi bersudut berwarna merah kecoklatan\n2. Sebagian daun berwarna kuning biasanya terjadi saat kelembapan tinggi',
          'icon': Icons.visibility,
        },
        'Dampak': {
          'content':
              '1. Jika bakteri menginfeksi hingga tunas akan menyebabkan tunas tampak kerdil dan mati',
          'icon': Icons.pest_control,
        },
        'Pencegahan': {
          'content':
              '1. Memastikan saat datang dan pergi ke kebun dalam keadaan bersih\n2. Memantau kehigienisan pengunjung yang masuk ke kebun\n3.Memilih pemasok bibit yang bereputasi baik sehingga bibit dapat terjamin kesehatannya',
          'icon': Icons.shield,
        },
        'Penanganan': {
          'content':
              '1. Pengaplikasian fungisida campuran Bordeaux\n2. Pengaplikasian fungisida Mancozeb\n3. Pengaplikasian fungisida Topsin - M\n4. Pengaplikasian fungisida Captan\n4. Pengaplikasian fungisida Ziram\n',
          'icon': Icons.medical_services,
        },
      };
    default:
      return {
        'Informasi': {
          'content': 'Penyakit tanaman belum teridentifikasi secara spesifik',
          'icon': Icons.help,
          'color': Colors.grey,
        },
        'Saran': {
          'content':
              '1. Konsultasikan dengan ahli tanaman\n2. Ambil sampel untuk pemeriksaan lebih lanjut\n3. Isolasi tanaman yang terinfeksi',
          'icon': Icons.lightbulb,
          'color': Colors.blue,
        },
      };
  }
}
