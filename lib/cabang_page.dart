import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'riwayat_cabang_page.dart';
import 'package:firebase_core/firebase_core.dart';

typedef KetinggianAirCallback = void Function(double ketinggianAir);

class CabangPage extends StatefulWidget {
  final KetinggianAirCallback? onKetinggianAirChanged; // Callback function
  final String cabangName;
  final String cabangId;

  CabangPage({Key? key, required this.cabangName, required this.cabangId, this.onKetinggianAirChanged}) : super(key: key);

  @override
  _CabangPageState createState() => _CabangPageState();
}

class _CabangPageState extends State<CabangPage> {
  double ketinggian_air = 0.0;
  late DatabaseReference _sensorRef;
  late double currentKetinggianAir = 0.0; 
  // Misalkan nilai maksimum ketinggian air yang akan ditampilkan
  double maxKetinggianAir = 60.0; // dalam cm
  bool fiturOtomatis = false;
  bool? previousPompaStatus; // Variabel untuk menyimpan status pompa sebelumnya
  late DatabaseReference dbRef;

  DateTime? lastSentTimestamp; // Menyimpan waktu pengiriman terakhir
final Duration sendInterval = Duration(seconds: 2); // Interval waktu minimal untuk mengirim data (misalnya 2 detik)

  @override
  void initState() {
    super.initState();
    initFirebaseData();
    _loadAutomaticStatus(); // Muat status otomatis dari Firebase saat widget diinisialisasi

    dbRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://imontir-3bed8-default-rtdb.asia-southeast1.firebasedatabase.app',
    ).ref().child('sensor_${widget.cabangId}');

    // Mulai mendengarkan perubahan status_pompa
    _startMonitoringPumpStatus();
  }

  void initFirebaseData() {
    // Menggunakan FirebaseDatabase.instanceFor untuk URL database kustom
    final FirebaseDatabase database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),  // Pastikan Firebase sudah diinisialisasi di main.dart
      databaseURL: 'https://imontir-3bed8-default-rtdb.asia-southeast1.firebasedatabase.app',
    );

    // Mengacu pada referensi database untuk sensor berdasarkan cabangId
    _sensorRef = database.ref().child('sensor_${widget.cabangId}');

    // Mendengarkan perubahan pada data sensor di database
    _sensorRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        // Pastikan casting tipe data dari snapshot ke Map<String, dynamic>
        final data = Map<String, dynamic>.from(event.snapshot.value as Map<dynamic, dynamic>);

        setState(() {
          // Parsing data sensor dari database dan memperbarui tampilan (UI)
          ketinggian_air = double.parse(data['ketinggian_air'].toString());
          currentKetinggianAir = double.parse(data['batas_ketinggian_air'].toString());
        });
      }
    });
  }


  void _handleMenuItemClick(String value) {
    switch (value) {
      case 'Ubah Ketinggian Air':
        _showKetinggianAirDialog();
        break;
      case 'Hapus Mesin':
        _showDeleteConfirmationDialog();
        break;
    }
  }

  void _showKetinggianAirDialog() {
    int selectedValue = currentKetinggianAir.round(); // Nilai awal pilihan

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ubah Ketinggian Air', style: TextStyle(fontWeight: FontWeight.w500)),
          content: DropdownButtonFormField<int>(
            value: selectedValue,
            onChanged: (int? newValue) {
              if (newValue != null) {
                selectedValue = newValue;
              }
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0D9D57)),
              ),
            ),
            items: List.generate(61, (index) => DropdownMenuItem<int>(
              value: index,
              child: Text('$index cm'),
            )),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _updateKetinggianAir(selectedValue.toString()); // Konversi ke string
                Navigator.of(context).pop();
              },
              child: Text(
                'Ya',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }


  Future<void> _updateKetinggianAir(String newValue) async {
  try {
    await _sensorRef.update({'batas_ketinggian_air': newValue});
    print("Nilai batas_ketinggian_air diperbarui menjadi: $newValue");
  } catch (e) {
    print("Error updating batas_ketinggian_air: $e");
  }
}

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi', style: TextStyle(fontWeight: FontWeight.w600)),
          content: Text('Apakah kamu ingin menghapus mesin ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Tidak',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                ),
            ),
            TextButton(
              onPressed: () async {
                // Implement the delete action
                await _deleteBranchData();
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text(
                'Ya',
                style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteBranchData() async {
    try {
      // Menghapus data dari Cloud Firestore
      CollectionReference statusCollection = FirebaseFirestore.instance.collection('status_${widget.cabangName}');
      QuerySnapshot statusSnapshot = await statusCollection.get();
      for (DocumentSnapshot doc in statusSnapshot.docs) {
        await doc.reference.delete();
      }

      CollectionReference cabangCollection = FirebaseFirestore.instance.collection('cabang');
      QuerySnapshot cabangSnapshot = await cabangCollection.where('namaCabang', isEqualTo: widget.cabangName).get();
      for (DocumentSnapshot doc in cabangSnapshot.docs) {
        await doc.reference.delete();
      }

      // Menghapus data dari Firebase Realtime Database
      // Menggunakan FirebaseDatabase.instanceFor untuk URL database kustom
      final FirebaseDatabase database = FirebaseDatabase.instanceFor(
        app: Firebase.app(), // Menggunakan instance Firebase yang sudah diinisialisasi
        databaseURL: 'https://imontir-3bed8-default-rtdb.asia-southeast1.firebasedatabase.app',
      );
      DatabaseReference sensorRef = database.ref().child('sensor_${widget.cabangId}');
      
      // Menghapus data sensor di Realtime Database
      await sensorRef.remove();

      print("Branch data deleted successfully.");
    } catch (e) {
      print("Error deleting branch data: $e");
    }
  }

  // Fungsi untuk memuat status otomatis dari Realtime Database
  void _loadAutomaticStatus() {
    final FirebaseDatabase database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://imontir-3bed8-default-rtdb.asia-southeast1.firebasedatabase.app',
    );

    DatabaseReference dbRef = database.ref('sensor_${widget.cabangId}/fiturOtomatis');
    
    dbRef.once().then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        // Jika data ada, baca nilai dan ubah status 'fiturOtomatis'
        setState(() {
          fiturOtomatis = snapshot.snapshot.value as bool;
        });
      } else {
        // Jika tidak ada data, set nilai default
        setState(() {
          fiturOtomatis = false;
        });
      }
    });
  }


  // Fungsi untuk menyimpan status otomatis ke Realtime Database
  void _saveAutomaticStatus(bool value) async {
    final FirebaseDatabase database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://imontir-3bed8-default-rtdb.asia-southeast1.firebasedatabase.app',
    );

    DatabaseReference dbRef = database.ref('sensor_${widget.cabangId}/fiturOtomatis');
    await dbRef.set(value); // Menyimpan nilai status
  }

  // Fungsi untuk memonitor status pompa dan mengirimkan data ke Firestore
  void _startMonitoringPumpStatus() {
    dbRef.child('status_pompa').onValue.listen((event) async {
      if (event.snapshot.exists) {
        bool statusPompaRealtime = event.snapshot.value as bool;

        // Ambil status terakhir dari Firestore
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('status_${widget.cabangName}')
            .orderBy('tanggal_waktu', descending: true)
            .limit(1) // Hanya ambil data terakhir
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Ambil status terakhir dari Firestore
          bool lastStatusPompaFirestore = querySnapshot.docs.first['status_pompa_air'];

          // Cek apakah cukup waktu telah berlalu sejak pengiriman terakhir
          if (lastSentTimestamp == null ||
              DateTime.now().difference(lastSentTimestamp!) >= sendInterval) {
            
            // Kirim data jika ada perubahan status yang valid
            if ((lastStatusPompaFirestore == true && statusPompaRealtime == false) ||
                (lastStatusPompaFirestore == false && statusPompaRealtime == true)) {
              
              // Perbarui status sebelumnya dan waktu terakhir data dikirim
              previousPompaStatus = statusPompaRealtime;
              lastSentTimestamp = DateTime.now(); // Update waktu pengiriman terakhir

              // Menambahkan data ke Firestore
              FirebaseFirestore.instance.collection('status_${widget.cabangName}').add({
                'tanggal_waktu': DateTime.now(),
                'status_pompa_air': statusPompaRealtime,
              }).then((_) {
                print("Data berhasil ditambahkan ke Firestore");
              }).catchError((error) {
                print("Gagal menambahkan data ke Firestore: $error");
              });
            }
          } else {
            print("Data tidak dikirim, interval waktu belum tercapai.");
          }
        }
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //Color(0xFFF2F7FD),
      appBar: AppBar(
        backgroundColor: Color(0xFF0D9D57),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          widget.cabangName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding (
            padding : const EdgeInsets.only(right: 14.0),
            child : PopupMenuButton<String>(
              onSelected: _handleMenuItemClick,
              icon: Icon(Icons.settings, color: Colors.white),
              itemBuilder: (BuildContext context) {
                return {'Ubah Ketinggian Air', 'Hapus Mesin'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice,
                      style: TextStyle(
                        color: choice == 'Hapus Mesin' ? Colors.red : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList();
              },
              color: const Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )
            ),
          ),
        ],
      ),

      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Diagram Air
          // Meteran Air
          SizedBox(
            height: 250.0, // Atur tinggi sesuai keinginan Anda
            child: Container(
              padding: EdgeInsets.only(top: 30.0, bottom: 20.0, left: 50.0, right: 50.0),
              // color: Colors.red,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        7,
                        (index) => Container(
                          height: 16.0,
                          alignment: Alignment.center,
                          child: Text(
                            '${(6 - index) * 10} cm',
                            style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue[200],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: (ketinggian_air / maxKetinggianAir) * 190,
                            decoration: BoxDecoration(
                              color: Colors.blue[800],
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Ketinggian Air: $ketinggian_air cm',
                            style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            child: Text(
              'Batas Ketinggian Air : $currentKetinggianAir cm',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 18,),

          // History
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Riwayat Pompa Air',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RiwayatPompaAir(cabangName: widget.cabangName),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Color(0xFF0D9D57), // Warna hijau untuk latar belakang
                              borderRadius: BorderRadius.circular(12), // Sudut membulat
                            ),
                            child: Text(
                              'Selengkapnya',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white, // Warna teks putih agar kontras
                              ),
                              textAlign: TextAlign.center, // Mengatur teks agar berada di tengah
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('status_${widget.cabangName}')
                        .orderBy('tanggal_waktu', descending: true)
                        .limit(3) // Batasi berapa card yang ingin ditampilkan  
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!.docs;
                        List<Map<String, dynamic>> cardData = [
                          for (var doc in data)
                            {
                              'tanggal': DateFormat('dd MMMM yyyy', 'id').format((doc['tanggal_waktu'] as Timestamp).toDate()),
                              'waktu': DateFormat('HH:mm', 'id').format((doc['tanggal_waktu'] as Timestamp).toDate()) + ' WIB',
                              'status': (doc['status_pompa_air'] == true) ? 'Hidup' : 'Mati',
                            },
                        ];
                      
                      // Membalik urutan agar data terbaru berada di bagian bawah
                      cardData = cardData.reversed.toList();

                        return Column(
                          children: cardData.map((item) => _buildCard(item)).toList(),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Switch untuk "Pompa Air Otomatis"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pompa Air Otomatis',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: fiturOtomatis,
                  activeColor: Color(0xFF0D9D57),
                  onChanged: (value) {
                    setState(() {
                      fiturOtomatis = value;
                      _saveAutomaticStatus(value);
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),

            // Baris untuk "Status Pompa Air"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status Pompa Air',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('status_${widget.cabangName}')
                      .orderBy('tanggal_waktu', descending: true)
                      .limit(1)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!.docs;
                      bool lastStatus = data.isNotEmpty ? data.first['status_pompa_air'] : false;

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
            SizedBox(height: 20),

            // Button Hidupkan/Matikan Pompa Air
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('status_${widget.cabangName}')
                  .orderBy('tanggal_waktu', descending: true)
                  .limit(1)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!.docs;
                  bool lastStatus = data.isNotEmpty ? data.first['status_pompa_air'] : false;
                  DateTime lastDateTime = data.isNotEmpty ? (data.first['tanggal_waktu'] as Timestamp).toDate() : DateTime.now();
                  Duration difference = DateTime.now().difference(lastDateTime);

                  Color buttonColor = fiturOtomatis ? Colors.grey : (lastStatus && difference.inHours < 24) ? Color(0xFFFA4659) : Color(0xFF0D9D57);
                  String buttonText = fiturOtomatis ? 'Pompa Air Otomatis Aktif' : (lastStatus && difference.inHours < 24) ? 'Matikan Pompa Air' : 'Hidupkan Pompa Air';

                  return ElevatedButton(
                    onPressed: fiturOtomatis ? null : () async {
                      FirebaseFirestore.instance.collection('status_${widget.cabangName}').add({
                        'tanggal_waktu': DateTime.now(),
                        'status_pompa_air': !lastStatus,
                      });

                      await dbRef.update({
                        'status_pompa': !lastStatus,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Container(
                      height: 50,
                      child: Center(
                        child: Text(
                          buttonText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item) {
    bool isActive = item['status'] == 'Hidup';
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Date Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    SizedBox(width: 5),
                    Text(
                      'Tanggal',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Text(
                  item['tanggal'],
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            SizedBox(width: 40), // Spacer for consistent spacing
            // Time Column left-aligned
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(
                          'Waktu',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    Text(
                      item['waktu'],
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20), // Spacer for consistent spacing
            // Status Column
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isActive ? 'Hidup' : 'Mati',
                style: TextStyle(
                  color: isActive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
