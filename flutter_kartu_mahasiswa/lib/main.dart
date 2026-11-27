import 'package:flutter/material.dart';

import 'kartu_mahasiswa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Kartu Mahasiswa',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFE3F2FD), // biru pastel
        body: Center(
          child: KartuMahasiswa(
            nama: 'Delvino Ardi Wiratama',
            nim: '20250801116',
            programStudi: 'Teknik Informatika',
          ),
        ),
      ),
    );
  }
}
