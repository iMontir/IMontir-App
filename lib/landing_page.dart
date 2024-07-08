import 'package:flutter/material.dart';
import 'menu_page.dart'; // Import halaman menu yang akan ditampilkan setelah 2 detik

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key); // Pastikan constructor publik

  @override
  Widget build(BuildContext context) {
    // Navigasi ke halaman menu setelah 2 detik
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MenuPage()),
      );
    });

    return Scaffold(
      backgroundColor: Color(0xFF0D9D57),
      body: Center(
        child: Text(
          'IMontir',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 35.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}