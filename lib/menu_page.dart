import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notifikasi_page.dart';
import 'tambah_cabang.dart';
import 'cabang_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String _currentDate = '';
  String _currentTime = '';
  bool _isConnected = true;
  

  @override
  void initState() {
    super.initState();
    _getCurrentDateTime();
    _updateTime();
    _checkConnectivity();
  }

 //Cek internet untuk Notifikasi dan + Mesin
  Future<void> _checkInternetConnection(BuildContext context, VoidCallback onConnected) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Tidak ada koneksi internet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tidak ada koneksi internet. Hubungkan ke internet.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Ada koneksi internet
      onConnected();
    }
  }

  //Cek Internet untuk data cabang atau mesin
  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  void _getCurrentDateTime() {
    final now = DateTime.now();
    final DateFormat formatterDate = DateFormat('EEEE, dd MMMM yyyy', 'id');
    final DateFormat formatterTime = DateFormat('HH:mm');
    setState(() {
      _currentDate = formatterDate.format(now);
      _currentTime = formatterTime.format(now);
    });
  }

  void _updateTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final DateFormat formatterTime = DateFormat('HH:mm');
      setState(() {
        _currentTime = formatterTime.format(now);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Color(0xFF0D9D57),
          title: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              'Hai Petani',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: IconButton(
                onPressed: () {
                  _checkInternetConnection(context, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotifikasiPage()),
                    );
                  });
                },
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
          automaticallyImplyLeading: false,
          elevation: 0.3,
          shadowColor: Color(0xFF0D9D57),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 210,
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: Color(0xFF0D9D57),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                        )
                      ),
                    ),
                  ),
                  
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0),
                                  bottom: Radius.circular(20.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Teknologi Tepat Guna\nIrigasi Tepat Sasaran',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      TextButton(
                                        onPressed: () {
                                          _checkInternetConnection(context, () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TambahCabangPage()),
                                          );
                                        });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0D9D57)),
                                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                          shape: MaterialStateProperty.all<OutlinedBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                            EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                                          ),
                                        ),
                                        child: Text(
                                          '+  Mesin',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(height: 10.0),
                                        Image.asset(
                                          'assets/farmer.png',
                                          width: 100.0,
                                          height: 160.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  ],
                ),
              ),
                  ),
                ]
              ),
            ),


            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('cabang').orderBy('tanggal_waktu_pembuatan', descending: false).snapshots(),
              builder: (context, snapshot) {
                if (!_isConnected) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 60),
                        Image.asset(
                          'assets/no_sinyal.png',
                          width: 200,
                          height: 200,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Tidak ada koneksi internet',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasData) {
                  List<Map<String, dynamic>> daftarCabang =
                      snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

                  if (daftarCabang.isEmpty) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                      child: Column(
                        children: [
                          SizedBox(height: 90),
                          Image.asset(
                            'assets/not_data.png',
                            width: 200,
                            height: 200,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Tidak Ada Mesin\nYang Tersedia',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center, // Opsional: untuk meratakan teks di tengah
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Daftar Mesin',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: daftarCabang.length,
                            itemBuilder: (context, index) {
                              var cabang = daftarCabang[index];
                              // Mengakses Realtime Database dengan URL yang benar menggunakan FirebaseDatabase.instanceFor
                              final FirebaseDatabase database = FirebaseDatabase.instanceFor(
                                app: Firebase.app(), // Menggunakan instance Firebase yang sudah diinisialisasi
                                databaseURL: 'https://imontir-3bed8-default-rtdb.asia-southeast1.firebasedatabase.app',
                              );

                              // Mendapatkan referensi ke child node berdasarkan idCabang
                              DatabaseReference ref = database.ref().child('sensor_${cabang['idCabang']}');

                              return StreamBuilder(
                                stream: ref.onValue,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData && (snapshot.data! as DatabaseEvent).snapshot.value != null) {
                                    var data = (snapshot.data! as DatabaseEvent).snapshot.value as Map<dynamic, dynamic>;
                                    double ketinggianAir = (data['ketinggian_air'] ?? 0).toDouble();
                                    double batasKetinggianAir = double.tryParse(data['batas_ketinggian_air'] ?? '0') ?? 0;

                                    // Logika warna berdasarkan ketinggian air dan batas ketinggian air
                                    Color backgroundColor = ketinggianAir >= batasKetinggianAir
                                        ? Color(0xFF0D9D57)//0xFF03C988) // Hijau jika ketinggian air sama atau di atas batas
                                        : Color(0xFFFA4659); // Merah jika ketinggian air di bawah batas

                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                                      child: Container(
                                        constraints: BoxConstraints(minHeight: 150.0),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => CabangPage(
                                                  cabangName: cabang['namaCabang'],
                                                  cabangId: cabang['idCabang'],
                                                ),
                                              ),
                                            );
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20.0),
                                              ),
                                            ),
                                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                              EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${cabang['namaCabang']}',
                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                              ),
                                              SizedBox(height: 30),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  // Bagian Ketinggian Air
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Ketinggian Air',
                                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        '$ketinggianAir cm',
                                                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                                                      ),
                                                    ],
                                                  ),
                                                  // Bagian Status Pompa Air
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        'Pompa Air',
                                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                                      ),
                                                      SizedBox(height: 5),
                                                      StreamBuilder<QuerySnapshot>(
                                                        stream: FirebaseFirestore.instance
                                                            .collection('status_${cabang['namaCabang']}')
                                                            .orderBy('tanggal_waktu', descending: true)
                                                            .limit(1)
                                                            .snapshots(),
                                                        builder: (context, snapshot) {
                                                          if (snapshot.hasData) {
                                                            final statusData = snapshot.data!.docs;
                                                            bool lastStatus = statusData.isNotEmpty ? statusData.first['status_pompa_air'] : false;

                                                            // Menentukan status pompa berdasarkan data
                                                            return Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                              decoration: BoxDecoration(
                                                                color: lastStatus ? Colors.green.shade100 : Colors.red.shade100,
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              child: Text(
                                                                lastStatus ? 'Hidup' : 'Mati',
                                                                style: TextStyle(
                                                                  color: lastStatus ? Colors.green : Colors.red,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            return CircularProgressIndicator();
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              );
                            },
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    );
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
