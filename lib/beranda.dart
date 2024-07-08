// import 'package:flutter/material.dart';
// import 'cabang_page.dart'; // Import halaman tujuan untuk Cabang 1
// import 'notifikasi_page.dart';
// import 'tambah_cabang.dart';


// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Halaman Flutter'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications),
//             onPressed: () {
//               // Aksi ketika tombol notifikasi ditekan
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.all(20.0),
//               color: Colors.white,
//               child: Text(
//                 'Keterangan Lokasi',
//                 style: TextStyle(fontSize: 20.0),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.all(20.0),
//               color: Colors.green,
//               child: Text(
//                 'Keterangan Waktu',
//                 style: TextStyle(fontSize: 20.0),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.all(20.0),
//               color: Colors.green,
//               child: Text(
//                 'Keterangan Waktu Lainnya',
//                 style: TextStyle(fontSize: 20.0),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Row(
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       // Aksi ketika tombol ditekan
//                     },
//                     child: Text('Tambah Button'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Aksi ketika tombol tambah ditekan
//         },
//         tooltip: 'Tambah',
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
