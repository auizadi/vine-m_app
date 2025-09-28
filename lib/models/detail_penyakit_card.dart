import 'package:flutter/material.dart';

class DetailPenyakitCard extends StatelessWidget {
  final String nama;
  final String deskripsi;
  final List<String> penyebab;
  final List<String> gejala;
  final List<String> dampak;
  final List<String> pencegahan;
  final List<String> penanganan;

  const DetailPenyakitCard({
    super.key,
    required this.nama,
    required this.deskripsi,
    required this.penyebab,
    required this.gejala,
    required this.dampak,
    required this.pencegahan,
    required this.penanganan,
  });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nama, style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff7864f6),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // deskripsi
            _buildSection(
              title: 'Deskripsi',
              icon: Icons.info_outline,
              children: [
                Text(
                  deskripsi,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // penyebab
            _buildSection(
              title: 'Penyebab',
              icon: Icons.medical_information_outlined,
              children: [_buildNumberedList(penyebab)],
            ),
            const SizedBox(height: 24),
            //gejala
            _buildSection(
              title: 'Gejala',
              icon: Icons.pest_control_outlined,
              children: [_buildNumberedList(gejala)],
            ),
            const SizedBox(height: 24),
            // dampak
            _buildSection(
              title: 'Dampak',
              icon: Icons.warning_amber_outlined,
              children: [_buildNumberedList(dampak)],
            ),
            const SizedBox(height: 24),
            // pencegahan
            _buildSection(
              title: 'Pencegahan',
              icon: Icons.shield_outlined,
              children: [_buildNumberedList(pencegahan)],
            ),
            const SizedBox(height: 24),
            // penanganan
            _buildSection(
              title: 'Penanganan',
              icon: Icons.medical_information_outlined,
              children: [_buildNumberedList(penanganan)],
            ),
            const SizedBox(height: 24),
            //
          ],
        ),
      ),
    );
  }
}
