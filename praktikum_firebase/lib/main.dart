import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Praktikum Firebase',
      debugShowCheckedModeBanner: false,
      home: FormPresensiPage(),
    );
  }
}

class FormPresensiPage extends StatefulWidget {
  /// Bisa diganti saat testing. Kalau null, pakai FirebaseFirestore.instance.
  final FirebaseFirestore? firestore;

  const FormPresensiPage({super.key, this.firestore});

  @override
  State<FormPresensiPage> createState() => _FormPresensiPageState();
}

class _FormPresensiPageState extends State<FormPresensiPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk mengambil nilai dari setiap TextFormField
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _mataKuliahController = TextEditingController();

  // Pilihan keterangan kehadiran
  final List<String> _pilihanKehadiran = ['Hadir', 'Izin', 'Sakit'];
  String? _keterangan;

  bool _loading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _lokasiController.dispose();
    _mataKuliahController.dispose();
    super.dispose();
  }

  // Validasi field wajib: tidak boleh kosong
  String? _wajibDiisi(String? value, String namaField) {
    if (value == null || value.trim().isEmpty) {
      return '$namaField wajib diisi';
    }
    return null;
  }

  // Mengambil nilai dari setiap field lalu mengirimnya ke collection "praktikum"
  Future<void> simpanData() async {
    // Hentikan kalau masih ada field wajib yang kosong
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final db = widget.firestore ?? FirebaseFirestore.instance;
      await db.collection('praktikum').add({
        'nama': _namaController.text.trim(),
        'nim': _nimController.text.trim(),
        'lokasi': _lokasiController.text.trim(),
        'mata_kuliah': _mataKuliahController.text.trim(),
        'keterangan': _keterangan,
        'waktu': FieldValue.serverTimestamp(),
      }).timeout(const Duration(seconds: 10));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data berhasil disimpan'),
          backgroundColor: Colors.green,
        ),
      );

      // Kosongkan kembali semua field
      _formKey.currentState!.reset();
      _namaController.clear();
      _nimController.clear();
      _lokasiController.clear();
      _mataKuliahController.clear();
      setState(() => _keterangan = null);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Form Presensi Praktikum',
                  style: TextStyle(fontSize: 26),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => _wajibDiisi(v, 'Nama'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nimController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'NIM',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => _wajibDiisi(v, 'NIM'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lokasiController,
                  decoration: const InputDecoration(
                    labelText: 'Lokasi',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => _wajibDiisi(v, 'Lokasi'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _mataKuliahController,
                  decoration: const InputDecoration(
                    labelText: 'Mata Kuliah',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => _wajibDiisi(v, 'Mata Kuliah'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _keterangan,
                  decoration: const InputDecoration(
                    labelText: 'Keterangan Kehadiran',
                    border: OutlineInputBorder(),
                  ),
                  items: _pilihanKehadiran
                      .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                      .toList(),
                  onChanged: (v) => setState(() => _keterangan = v),
                  validator: (v) =>
                      v == null ? 'Keterangan kehadiran wajib dipilih' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _loading ? null : simpanData,
                    child: _loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Simpan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
