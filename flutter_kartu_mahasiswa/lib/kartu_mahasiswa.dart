import 'package:flutter/material.dart';

/// Kartu identitas mahasiswa (StatelessWidget).
/// Data diterima lewat constructor dan tidak berubah selama ditampilkan.
class KartuMahasiswa extends StatelessWidget {
  final String nama;
  final String nim;
  final String programStudi;

  const KartuMahasiswa({
    super.key,
    required this.nama,
    required this.nim,
    required this.programStudi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.0,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'KARTU MAHASISWA',
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.indigo,
            ),
          ),
          const Divider(),
          _baris('Nama', nama),
          const Divider(),
          _baris('NIM', nim),
          const Divider(),
          _baris('Program Studi', programStudi),
        ],
      ),
    );
  }

  // Satu baris label + isi, dipakai berulang supaya kode tidak duplikat.
  Widget _baris(String label, String isi) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12.0, color: Colors.grey)),
          const SizedBox(height: 2.0),
          Text(isi, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
