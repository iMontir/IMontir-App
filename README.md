# IMontir

IMontir adalah sebuah proyek Internet of Things (IoT) yang terhubung dengan aplikasi Flutter untuk memantau dan mengendalikan distribusi air pada sistem irigasi. Aplikasi ini mampu mendeteksi ketinggian air pada suatu cabang irigasi dan menghidupkan pompa air untuk mengaliri air dari cabang irigasi yang lebih besar. Data disimpan dan dikelola menggunakan Firebase.

## Fitur Utama

1. **Deteksi Ketinggian Air:** Menggunakan sensor ultrasonik yang terintegrasi dengan ESP32 untuk mendeteksi ketinggian air di cabang irigasi.
2. **Kendali Pompa Air:** Menghidupkan dan mematikan pompa air berdasarkan data ketinggian air yang terdeteksi.
3. **Pengelolaan Cabang:** Menambahkan dan mengelola cabang irigasi melalui aplikasi.
4. **Notifikasi:** Memberikan notifikasi real-time terkait status ketinggian air dan operasi pompa.
5. **Riwayat Pompa:** Menyimpan dan menampilkan riwayat hidup dan matinya pompa air.

## Struktur Aplikasi

1. **Splash Screen:** Tampilan awal saat pertama kali membuka aplikasi.
2. **Beranda:** Tiga fitur utama:
   - **Tambah Cabang:** Menambahkan cabang irigasi baru.
   - **Cabang No.:** Melihat diagram ketinggian air dan mengontrol pompa air untuk setiap cabang.
   - **Notifikasi:** Melihat notifikasi dari alat dan membuka Tampilan Cabang No.
3. **Tampilan Notifikasi:** Menampilkan notifikasi dari alat untuk ketinggian air pada cabang irigasi yang kurang dari permintaan.
4. **Tampilan Cabang No.:** Menampilkan diagram ketinggian air dan mengontrol pompa air untuk cabang irigasi tersebut, serta melihat riwayat hidup dan matinya pompa air.

## Teknologi yang Digunakan

- **Flutter:** Framework untuk pengembangan aplikasi mobile.
- **ESP32:** Mikrokontroler untuk mengintegrasikan sensor ultrasonik dan terhubung dengan Firebase.
- **Firebase:** Database untuk menyimpan dan mengelola data ketinggian air dan status pompa.
- **Sensor Ultrasonik:** Untuk mendeteksi ketinggian air di cabang irigasi.

## Instalasi

1. Clone repositori ini:
   ```bash
   https://github.com/iMontir/IMontir-App.git
