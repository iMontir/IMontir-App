import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class TambahCabangPage extends StatelessWidget {
  final TextEditingController namaCabangController = TextEditingController();
  final TextEditingController idCabangController = TextEditingController();
  final TextEditingController BatasKetinggianAirController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF0D9D57),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'Tambah Cabang',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings, color: Colors.transparent),
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Nama Mesin',
                    style: TextStyle(
                      color: Color(0xFF0D9D57),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: namaCabangController,
                  decoration: InputDecoration(
                    hintText: 'Masukan Nama Mesin',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13.0),
                      borderSide: BorderSide(
                        color: Color(0xFF0D9D57),
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13.0),
                      borderSide: BorderSide(
                        color: Color(0xFF0D9D57),
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13.0),
                      borderSide: BorderSide(
                        color: Color(0xFF0D9D57),
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Kode Mesin',
                    style: TextStyle(
                      color: Color(0xFF0D9D57),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: idCabangController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Masukan Kode Mesin',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13.0),
                      borderSide: BorderSide(
                        color: Color(0xFF0D9D57),
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13.0),
                      borderSide: BorderSide(
                        color: Color(0xFF0D9D57),
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13.0),
                      borderSide: BorderSide(
                        color: Color(0xFF0D9D57),
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Batas Ketinggian Air',
                    style: TextStyle(
                      color: Color(0xFF0D9D57),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    // TextField untuk input manual
                    Expanded(
                      child: TextField(
                        controller: BatasKetinggianAirController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Masukan Batas Ketinggian Air',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13.0),
                            borderSide: BorderSide(
                              color: Color(0xFF0D9D57),
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13.0),
                            borderSide: BorderSide(
                              color: Color(0xFF0D9D57),
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13.0),
                            borderSide: BorderSide(
                              color: Color(0xFF0D9D57),
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Button untuk menu dropdown
                    PopupMenuButton<int>(
                      onSelected: (value) {
                        // Update TextField dengan value + ' cm'
                        BatasKetinggianAirController.text = '$value cm';
                      },
                      itemBuilder: (BuildContext context) {
                        return List.generate(61, (index) {
                          return PopupMenuItem<int>(
                            value: index,
                            child: Text('$index cm'),
                          );
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFF0D9D57),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    tambahData(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0D9D57), // background color
                    foregroundColor: Colors.white, // foreground color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Tambah',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> tambahData(BuildContext context) async {
    String namaCabang = namaCabangController.text.trim();
    String idCabang = idCabangController.text.trim();
    String batasKetinggianAir = BatasKetinggianAirController.text.replaceAll(' cm', '');


    // Menghapus spasi dan karakter khusus dari nama cabang
    String cleanedNamaCabang = namaCabang.replaceAll(RegExp(r'[^\w\s]+'), '');

    // Mengkonversi batas ketinggian air ke integer
    int? cekbatasKetinggianAir= int.tryParse(batasKetinggianAir);

    if (cleanedNamaCabang.isEmpty || idCabang.isEmpty) {
      // Menampilkan pesan kesalahan jika nama atau id cabang kosong
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          // Menyimpan referensi ke context dialog
          BuildContext dialogContext = context;

          // Menutup dialog secara otomatis setelah 1 detik
          Future.delayed(Duration(seconds: 1), () {
            if (Navigator.canPop(dialogContext)) {
              Navigator.pop(dialogContext);
            }
          });

          return AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 64,
                ),
                SizedBox(height: 16),
                Text(
                  'Nama dan ID Mesin harus diisi!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else if (cekbatasKetinggianAir == null || cekbatasKetinggianAir > 60) {
    // Menampilkan pesan kesalahan jika batas ketinggian air tidak valid atau lebih dari 60 cm
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Menyimpan referensi ke context dialog
          BuildContext dialogContext = context;

          // Menutup dialog secara otomatis setelah 1 detik
          Future.delayed(Duration(seconds: 1), () {
            if (Navigator.canPop(dialogContext)) {
              Navigator.pop(dialogContext);
            }
          });

        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'Batas Ketinggian Air tidak boleh lebih dari 60 cm!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
    } else {
      try {
         // Mengambil instance Firestore
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        
        // Menggunakan FirebaseDatabase.instanceFor untuk URL database kustom
        final FirebaseDatabase realtimeDatabase = FirebaseDatabase.instanceFor(
          app: Firebase.app(), // Pastikan Firebase sudah diinisialisasi di main.dart
          databaseURL: 'https://imontir-3bed8-default-rtdb.asia-southeast1.firebasedatabase.app',
        );

        // Mendapatkan referensi ke root database
        DatabaseReference dbRef = realtimeDatabase.ref();

        // Check if namaCabang or idCabang already exists
        QuerySnapshot querySnapshot = await firestore.collection('cabang')
            .where('namaCabang', isEqualTo: cleanedNamaCabang)
            .get();

        QuerySnapshot idQuerySnapshot = await firestore.collection('cabang')
            .where('idCabang', isEqualTo: idCabang)
            .get();

        // Validasi panjang karakter namaCabang
        if (cleanedNamaCabang.length > 20) {
          // Menampilkan pesan kesalahan jika namaCabang lebih dari 20 karakter
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // Menyimpan referensi ke context dialog
              BuildContext dialogContext = context;

              // Menutup dialog secara otomatis setelah 1 detik
              Future.delayed(Duration(seconds: 1), () {
                if (Navigator.canPop(dialogContext)) {
                  Navigator.pop(dialogContext);
                }
              });

              return AlertDialog(
                backgroundColor: Colors.white,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Nama Mesin tidak boleh lebih dari 20 karakter!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
          return; // Menghentikan proses jika namaCabang lebih dari 20 karakter
        }
        
        if (querySnapshot.docs.isNotEmpty) {
          // Menampilkan pesan kesalahan jika nama cabang sudah ada
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // Menyimpan referensi ke context dialog
              BuildContext dialogContext = context;

              // Menutup dialog secara otomatis setelah 1 detik
              Future.delayed(Duration(seconds: 1), () {
                if (Navigator.canPop(dialogContext)) {
                  Navigator.pop(dialogContext);
                }
              });

              return AlertDialog(
                backgroundColor: Colors.white,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Nama Mesin sudah ada!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (idQuerySnapshot.docs.isNotEmpty) {
          // Menampilkan pesan kesalahan jika ID cabang sudah ada
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // Menyimpan referensi ke context dialog
              BuildContext dialogContext = context;

              // Menutup dialog secara otomatis setelah 1 detik
              Future.delayed(Duration(seconds: 1), () {
                if (Navigator.canPop(dialogContext)) {
                  Navigator.pop(dialogContext);
                }
              });

              return AlertDialog(
                backgroundColor: Colors.white,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Kode Mesin sudah ada!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          // Menambahkan data ke koleksi 'cabang' di Firestore
          DocumentReference cabangRef = await firestore.collection('cabang').add({
            'namaCabang': cleanedNamaCabang,
            'idCabang': idCabang,
            'tanggal_waktu_pembuatan': DateTime.now(),
          });

          // Membuat koleksi baru dengan nama yang sesuai dengan nama cabang di Firestore
          await firestore.collection('status_$cleanedNamaCabang').add({
            'tanggal_waktu': DateTime.now(),
            'status_pompa_air': false,
          });

          // Menambahkan data ke Realtime Database berdasarkan ID cabang
          await realtimeDatabase.ref().child('sensor_$idCabang').set({
            'ketinggian_air': 0,
            'batas_ketinggian_air' : batasKetinggianAir,
            'status_pompa' : false,
            'fiturOtomatis' : false,
          });

          // Menampilkan dialog berhasil
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              // Menyimpan referensi ke context dialog
              BuildContext dialogContext = context;

              // Menutup dialog secara otomatis setelah 1 detik
              Future.delayed(Duration(seconds: 1), () {
                if (Navigator.canPop(dialogContext)) {
                  Navigator.pop(dialogContext);
                }
              });

              return AlertDialog(
                backgroundColor: Colors.white,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Berhasil\nMenambahkan Mesin',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          );

          // Kembali ke halaman sebelumnya
          Navigator.pop(context);
        }
      } catch (e) {
        print('Error adding document: $e');
        // Menampilkan pesan kesalahan jika terjadi error lain
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // Menyimpan referensi ke context dialog
            BuildContext dialogContext = context;

            // Menutup dialog secara otomatis setelah 1 detik
            Future.delayed(Duration(seconds: 1), () {
              if (Navigator.canPop(dialogContext)) {
                Navigator.pop(dialogContext);
              }
            });
            
            return AlertDialog(
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Terjadi kesalahan saat menambahkan data',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    }
  }
}
