# VineCare : Aplikasi deteksi penyakit daun tanaman angur

Aplikasi ini digunakan untuk mendeteksi penyakit daun tanaman anggur. Teknologi _computer vision_ digunakan pada pengembangan aplikasi berbasis mobile ini. Model YOLOv11 digunakan untuk melatih dataset untuk mengenali jenis-jenis penyakit daun tanaman anggur. Penyakit daun yang dapat dideteksi pada aplikasi ini antara lain _Black Rot, Leaf Blight, Esca, dan Downy Mildew_ serta kelas untuk daun sehat. Dataset diperoleh dari platform Roboflow.

```sh
https://universe.roboflow.com/graperesearch/vineyards-leaf-disease-detection-8cawq/browse?queryText=&pageSize=50&startingIndex=0&browseQuery=true
```

### Cara menjalankannya

#### 1. Clone repository

```sh
git clone https://github.com/auizadi/vine-m_app.git
```

#### 2. Masuk direktori

```sh
cd vine-m_app
```

#### 3. Masuk ke code editor (VSCode)

```sh
code .
```

#### 4. Install dependensi

```sh
flutter pub get
```

#### 5. Run project

> Pilih device yang akan digunakan untuk emulator

```sh
flutter run
```

<br>

---

<br>

# Screenshot tampilan aplikasi

#### 1. Splash Screen

![Splash screen](/screenshot_aplikasi/1.%20splash%20screen.jpeg "Splash screen")
<p>Tampilan pertama kali setelah aplikasi terinstall.</p>
<br>

#### 2. Introduction Screen

![Introduction screen](/screenshot_aplikasi/2.%20intro.jpeg "Introduction screen")
<p>Tampilan informasi aplikasi sebelum pengguna memakai fitur aplikasi.</p>
<br>

#### 3. Form

![Form screen](/screenshot_aplikasi/3.%20form.jpg "Form screen")
<p>Tampilan form yang berisi field nama dan unggah foto profile.</p>
<br>

#### 4. Home

![Home screen](/screenshot_aplikasi/4.%20home.jpg "Home screen")
<p>Tampilan Home menampilkan foto dan nama pengguna yang sebelumnya diunggah di form, selain itu terdapat tombol 'baca info' yang berisi informasi terkait aplikasi. Tombol untuk deteksi secara real-time dan unggah gambar tersedia dimenu ini. Card penyakit jika dipilih maka akan muncul informasi seperti nama, penyebab, penanganan, dll sesuai dengan card yang dipilih.</p>
<br>

#### 5. Deteksi Real-time

![Real-time screen](/screenshot_aplikasi/5.%20real-time.jpg "Real-time screen")
<p>Tampilan deteksi real-time memuat jumlah objek yang dideteksi, FPS, dan waktu. Fitur ini digunakan dengan mengarahkan kamera ke objek daun anggur, setelah muncul bounding box pengguna dapat menangkap gambar dengan menekan tombol kamera.</p>
<br>

#### 6. Deteksi Upload

![Upload screen](/screenshot_aplikasi/6.%20upload.jpeg "Upload screen")
<p>Tampilan deteksi unggah gambar dapat digunakan pengguna dengan menekan tombol "Upload Gambar dan Deteksi" setelah itu pengguna dapat memilih objek daun anggur yang akan dideteksi. Hasil dari deteksi ini adalah bounding box dan klasifikasi deteksi.</p>
<br>

#### 7. Hasil

![Hasil screen](/screenshot_aplikasi/7.%20hasil.jpeg "Hasil screen")
<p>Tampilan hasil menampilkan hasil deteksi seperti nama penyakit, akurasi, penyebab, gejala, pencegahan, penanganan, serta tombol simpan hasil.</p>
<br>

#### 8. Menu History

![History screen](/screenshot_aplikasi/8.%20shistory.jpg "History screen")
<p>Menu history menampilkan hasil deteksi yang pernah dilakukan pengguna. Hasil disimpan dalam bentuk card yang berisi nama penyakit, akurasi, waktu, dan tombol hapus untuk menghapus hasil deteksi.</p>
<br>

#### 9. Menu Guide

![Guide screen](/screenshot_aplikasi/9.%20guide.jpeg "Guide screen")
<p>Menu guide berisi tips dan tutorial mendeteksi objek daun anggur</p>
<br>

#### 10. Informasi

![Informasi screen](/screenshot_aplikasi/10.%20informasi.jpeg "Informasi screen")
<p>Tampilan ini muncul ketika card penyakit pada menu home dipilih.</p>
<br>

#### 11. Baca info

![Baca screen](/screenshot_aplikasi/11.info.jpeg "Baca screen")
<p>Tampilan ini berisi informasi seperti deskripsi aplikasi, penyakit yang dideteksi, fitur, dan kontak</p>
<br>

#### 12. Exit

![Exit screen](/screenshot_aplikasi/12.%20exit.jpeg "Exit screen")
<p>Pengguna dapat keluar aplikasi dengan menekan tombol "back" pada ponsel kemudian setelah itu aplikais akan memunculkan kotak dialog konfirmasi keluar aplikasi.</p>
<br>
