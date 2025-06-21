String getPreventionSteps(String className) {
  switch (className.toLowerCase()) {
    case 'black rot':
      return '1. Buang daun yang terinfeksi\n2. Gunakan fungisida\n3. Jaga kebersihan\n4. Sirkulasi udara baik';
    case 'esca':
      return '1. Potong bagian yang terinfeksi\n2. Gunakan fungisida pencegah\n3. Hindari luka batang\n4. Varietas tahan penyakit';
    case 'leaf blight':
      return '1. Semprot fungisida tembaga\n2. Hindari penyiraman dari atas\n3. Jarak tanam cukup\n4. Rotasi tanaman';
    default:
      return '1. Isolasi tanaman sakit\n2. Gunakan pestisida organik\n3. Perbaiki drainase\n4. Konsultasikan ke ahli';
  }
}
