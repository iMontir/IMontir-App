import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'cabang_page.dart';


class NotifikasiPage extends StatefulWidget {
  @override
  _NotifikasiPageState createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  Map<String, Map<String, dynamic>> branchesData = {};
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    fetchBranchData();
  }

  void initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = 
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void fetchBranchData() async {
    CollectionReference branches = FirebaseFirestore.instance.collection('cabang');
    QuerySnapshot branchSnapshot = await branches.get();

    for (var doc in branchSnapshot.docs) {
      String branchName = doc['namaCabang'];
      String branchId = doc['idCabang'];
      branchesData[branchId] = {'branchName': branchName};
      fetchSensorData(branchName, branchId);
    }
  }

  void fetchSensorData(String branchName, String branchId) {
    final FirebaseDatabase database = FirebaseDatabase(
        databaseURL: 'https://imontir-3bed8-default-rtdb.asia-southeast1.firebasedatabase.app');
    DatabaseReference sensorRef = database.ref().child('sensor_$branchId');

    sensorRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        double ketinggianAir = double.parse(data['ketinggian_air'].toString());
        double batasKetinggianAir = double.parse(data['batas_ketinggian_air'].toString());

        setState(() {
          branchesData[branchId]!['ketinggianAir'] = ketinggianAir;
          branchesData[branchId]!['batasKetinggianAir'] = batasKetinggianAir;
        });

        if (ketinggianAir < batasKetinggianAir) {
          showNotification(branchName, ketinggianAir);
        }
      }
    });
  }

  Future<void> showNotification(String branchName, double ketinggianAir) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your_channel_id', 'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Alert from $branchName',
      'Ketinggian air: ${ketinggianAir.toStringAsFixed(1)} cm',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

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
          'Notifikasi',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      // backgroundColor: Color(0xFFF2F7FD),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20.0),
          ...branchesData.keys.map((branchId) {
            double ketinggianAir = branchesData[branchId]!['ketinggianAir'] ?? 0.0;
            double batasKetinggianAir = branchesData[branchId]!['batasKetinggianAir'] ?? 0.0;
            String branchName = branchesData[branchId]!['branchName'] ?? '';

            bool conditionMet = ketinggianAir < batasKetinggianAir;

            if (conditionMet) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CabangPage(cabangName: branchName, cabangId: branchId,)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFA4659),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        branchName,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        ketinggianAir.toStringAsFixed(1) + ' cm',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          }).toList(),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
