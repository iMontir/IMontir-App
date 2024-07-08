import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class TambahCabangPage extends StatelessWidget {
  final TextEditingController namaCabangController = TextEditingController();
  final TextEditingController idCabangController = TextEditingController();

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
                    'Nama Cabang',
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
                    hintText: 'Masukan Nama Cabang',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Color(0xFF0D9D57),
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Color(0xFF0D9D57),
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
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
                    'ID Cabang',
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
                    hintText: 'Masukan ID Cabang',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Color(0xFF0D9D57),
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Color(0xFF0D9D57),
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Color(0xFF0D9D57),
                        width: 2.0,
                      ),
                    ),
                  ),
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

    // Menghapus spasi dan karakter khusus dari nama cabang
    String cleanedNamaCabang = namaCabang.replaceAll(RegExp(r'[^\w\s]+'), '');

    if (cleanedNamaCabang.isEmpty || idCabang.isEmpty) {
      // Menampilkan pesan kesalahan jika nama atau id cabang kosong
      showDialog(
        context: context,
        builder: (BuildContext context) {
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
                  'Nama dan ID Cabang harus diisi!',
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
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DatabaseReference realtimeDatabase = FirebaseDatabase(
          databaseURL: 'https://imontir-3bed8-default-rtdb.asia-southeast1.firebasedatabase.app'
        ).reference();

        // Check if namaCabang or idCabang already exists
        QuerySnapshot querySnapshot = await firestore.collection('cabang')
            .where('namaCabang', isEqualTo: cleanedNamaCabang)
            .get();

        QuerySnapshot idQuerySnapshot = await firestore.collection('cabang')
            .where('idCabang', isEqualTo: idCabang)
            .get();

        if (querySnapshot.docs.isNotEmpty || idQuerySnapshot.docs.isNotEmpty) {
          // Menampilkan pesan kesalahan jika nama atau id cabang sudah ada
          showDialog(
            context: context,
            builder: (BuildContext context) {
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
                      'Nama atau ID Cabang sudah ada!',
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
          await realtimeDatabase.child('sensor_$idCabang').set({
            'debit_air': 0,
            'ketinggian_air': 0,
            'batas_ketinggian_air' : 10,
            'status_pompa' : false,
          });

          // Menampilkan dialog berhasil
          await showDialog(
            context: context,
            builder: (BuildContext context) {
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
                      'Berhasil\nMenambahkan Cabang',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
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
