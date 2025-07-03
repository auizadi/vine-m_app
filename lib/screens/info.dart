import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Informasi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.purple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              '''Aplikasi VineCare adalah aplikasi deteksi penyakit daun tanaman anggur yang dapat mendeteksi daun tanaman yang sehat dan terserang penyakit. Aplikasi ini dapat mendeteksi 4 penyakit daun yakni black rot, downy mildew, leaf blight, dan esca.''',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ),
          DiseaseExpansionTile(
            diseaseName: 'Black Rot',
            prevention:
                '1. Buang daun yang terinfeksi\n2. Gunakan fungisida secara berkala\n3. Jaga sirkulasi udara di kebun',
            treatment:
                '1. Semprotkan fungisida berbasis tembaga\n2. Pangkas daun yang terinfeksi\n3. Hindari kelembaban tinggi',
          ),
          DiseaseExpansionTile(
            diseaseName: 'Black Rot',
            prevention:
                '1. Buang daun yang terinfeksi\n2. Gunakan fungisida secara berkala\n3. Jaga sirkulasi udara di kebun',
            treatment:
                '1. Semprotkan fungisida berbasis tembaga\n2. Pangkas daun yang terinfeksi\n3. Hindari kelembaban tinggi',
          ),
          DiseaseExpansionTile(
            diseaseName: 'Black Rot',
            prevention:
                '1. Buang daun yang terinfeksi\n2. Gunakan fungisida secara berkala\n3. Jaga sirkulasi udara di kebun',
            treatment:
                '1. Semprotkan fungisida berbasis tembaga\n2. Pangkas daun yang terinfeksi\n3. Hindari kelembaban tinggi',
          ),
          DiseaseExpansionTile(
            diseaseName: 'Black Rot',
            prevention:
                '1. Buang daun yang terinfeksi\n2. Gunakan fungisida secara berkala\n3. Jaga sirkulasi udara di kebun',
            treatment:
                '1. Semprotkan fungisida berbasis tembaga\n2. Pangkas daun yang terinfeksi\n3. Hindari kelembaban tinggi',
          ),
        ],
      ),
    );
  }
}

class DiseaseExpansionTile extends StatelessWidget {
  final String diseaseName;
  final String prevention;
  final String treatment;

  const DiseaseExpansionTile({
    super.key,
    required this.diseaseName,
    required this.prevention,
    required this.treatment,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        diseaseName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        ListTile(title: const Text('Pencegahan'), subtitle: Text(prevention)),
        ListTile(title: const Text('Penanganan'), subtitle: Text(treatment)),
        const Divider(),
      ],
    );
  }
}
