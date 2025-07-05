import 'package:flutter/material.dart';

Map<String, Map<String, dynamic>> getDiseaseDetailsHelper(String className) {
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
            'Perawatan tanaman lain disekitar lahan anggur agar tidak terinfekis penyakit dari tanaman lain',
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
          'content': ['Penyakit tanaman belum teridentifikasi secara spesifik'],
          'icon': Icons.help,
          'color': Colors.grey,
        },
      };
  }
}
