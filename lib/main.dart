import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart'; // Perlu diimpor untuk menginisialisasi locale

void main() async {
  initializeDateFormatting('id', null); // Inisialisasi locale bahasa Indonesia
  WidgetsFlutterBinding.ensureInitialized(); // Memastikan bahwa WidgetsBinding sudah diinisialisasi
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Constructor publik
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMontir App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: const LandingPage(),
    );
  }
}
