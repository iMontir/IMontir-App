# IMontir

IMontir adalah sistem IoT yang terhubung dengan aplikasi Flutter untuk pemantauan dan pengelolaan distribusi air pada sistem irigasi. Sistem ini mendeteksi ketinggian air pada cabang irigasi dan mengontrol pompa air untuk mengalirkan air dari cabang irigasi yang lebih besar ke cabang yang membutuhkan.

## Fitur

- **Pemantauan Ketinggian Air:** Menggunakan sensor ultrasonik untuk mendeteksi ketinggian air pada cabang irigasi.
- **Kontrol Pompa Air:** Menghidupkan dan mematikan pompa air secara otomatis berdasarkan kebutuhan distribusi air.
- **Integrasi IoT:** Menggunakan ESP32 untuk mengirim data sensor ke Firebase.
- **Aplikasi Flutter:** Antarmuka pengguna untuk memantau ketinggian air dan status pompa air secara real-time.
- **Database Firebase:** Menyimpan data ketinggian air dan status pompa air.

## Arsitektur Sistem

1. **Sensor Ultrasonik:** Mengukur ketinggian air pada cabang irigasi.
2. **ESP32:** Mengintegrasikan sensor ultrasonik dengan Firebase.
3. **Firebase:** Menyimpan data ketinggian air dan status pompa.
4. **Aplikasi Flutter:** Antarmuka pengguna untuk pemantauan dan pengendalian.

## Instalasi

1. Clone repositori ini:
   ```bash
   https://github.com/iMontir/IMontir-App.git
