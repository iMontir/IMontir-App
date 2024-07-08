import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'riwayat_cabang_page.dart';

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
  bool isPompaAirOn = false;
  double ketinggian_air = 0.0;
  late DatabaseReference _sensorRef;
  late double currentKetinggianAir = 0.0; 

  @override
  void initState() {
    super.initState();
    initFirebaseData();
  }

  void initFirebaseData() {
    // Update the database URL to the correct one for your region
    final FirebaseDatabase database = FirebaseDatabase(databaseURL: 'https://imontir-3bed8-default-rtdb.asia-southeast1.firebasedatabase.app');
    _sensorRef = database.ref().child('sensor_${widget.cabangId}');

    _sensorRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        setState(() {
          ketinggian_air = double.parse(data['ketinggian_air'].toString());
          currentKetinggianAir = double.parse(data['batas_ketinggian_air'].toString());
        });
      }
    });
  }

  void _handleMenuItemClick(String value) {
    switch (value) {
      case 'Batas Ketinggian Air':
        _showKetinggianAirDialog();
        break;
      case 'Hapus Cabang':
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
          title: Text('Batas Ketinggian Air', style: TextStyle(fontWeight: FontWeight.w500)),
          content: DropdownButtonFormField<int>(
            value: selectedValue,
            onChanged: (int? newValue) {
              if (newValue != null) {
                selectedValue = newValue;
              }
            },
            decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey), // Atur warna garis ungu
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF0D9D57)), // Atur warna garis ungu saat dipilih
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
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _updateKetinggianAir(selectedValue);
                Navigator.of(context).pop(); // Tutup dialog
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


  Future<void> _updateKetinggianAir(int newValue) async {
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
          content: Text('Apakah kamu ingin menghapus cabang ini?'),
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
      // Delete data from Cloud Firestore
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

      // Delete data from Firebase Realtime Database
      final FirebaseDatabase database = FirebaseDatabase(databaseURL: 'https://imontir-3bed8-default-rtdb.asia-southeast1.firebasedatabase.app');
      DatabaseReference sensorRef = database.ref().child('sensor_${widget.cabangId}');
      await sensorRef.remove();

      print("Branch data deleted successfully.");
    } catch (e) {
      print("Error deleting branch data: $e");
    }
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
                return {'Batas Ketinggian Air', 'Hapus Cabang'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice,
                      style: TextStyle(
                        color: choice == 'Hapus Cabang' ? Colors.red : Colors.black,
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
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 45.0, horizontal: 50.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 60.0,
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        7,
                        (index) => Container(
                          height: 18.0,
                          alignment: Alignment.center,
                          child: Text(
                            '${(6 - index) * 10} cm',
                            style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w600),
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
                            height: ketinggian_air * 4.2,
                            decoration: BoxDecoration(
                              color: Colors.blue[800],
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0), // Ubah radius sesuai kebutuhan
                                bottomRight: Radius.circular(10.0), // Ubah radius sesuai kebutuhan
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Ketinggian Air: $ketinggian_air cm',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // History
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                              MaterialPageRoute(builder: (context) => RiwayatPompaAir(cabangName: widget.cabangName)),
                            );
                          },
                          child: Text(
                            'Selengkapnya',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              // fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.right,
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
                              'tanggal': DateFormat('dd MMMM yyyy').format((doc['tanggal_waktu'] as Timestamp).toDate()),
                              'waktu': DateFormat('HH:mm wib').format((doc['tanggal_waktu'] as Timestamp).toDate()),
                              'status': (doc['status_pompa_air'] == true) ? 'Hidup' : 'Mati',
                            },
                        ];
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('status_${widget.cabangName}').orderBy('tanggal_waktu', descending: true).limit(1).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!.docs;
              bool lastStatus = data.isNotEmpty ? data.first['status_pompa_air'] : false;
              DateTime lastDateTime = data.isNotEmpty ? (data.first['tanggal_waktu'] as Timestamp).toDate() : DateTime.now();

              Duration difference = DateTime.now().difference(lastDateTime);

              Color buttonColor;
              String buttonText;

              if (lastStatus && difference.inHours < 24) {
                buttonColor = Color(0xFFFA4659);
                buttonText = 'Matikan Pompa Air';
              } else {
                buttonColor = Color(0xFF0D9D57);
                buttonText = 'Hidupkan Pompa Air';
              }

              return ElevatedButton(
                onPressed: () async {
                  FirebaseFirestore.instance.collection('status_${widget.cabangName}').add({
                    'tanggal_waktu': DateTime.now(),
                    'status_pompa_air': !lastStatus,
                  });

                  // Update Realtime Database dengan URL yang diberikan
                  DatabaseReference dbRef = FirebaseDatabase(
                    databaseURL: "https://imontir-3bed8-default-rtdb.asia-southeast1.firebasedatabase.app/"
                  ).reference().child('sensor_${widget.cabangId}');
                  
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
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            SizedBox(width: 50), // Spacer for consistent spacing
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
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
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
