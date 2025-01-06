import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart'; // Perlu diimpor untuk menginisialisasi locale

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Memastikan bahwa WidgetsBinding sudah diinisialisasi

  // Menginisialisasi locale bahasa Indonesia
  await initializeDateFormatting('id', null);

  // Inisialisasi Firebase dengan penanganan error
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Menangani kesalahan inisialisasi Firebase jika terjadi
    print('Error during Firebase initialization: $e');
  }

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
        fontFamily: 'Poppins', // Menggunakan font khusus
      ),
      home: const LandingPage(), // Halaman utama aplikasi
    );
  }
}
