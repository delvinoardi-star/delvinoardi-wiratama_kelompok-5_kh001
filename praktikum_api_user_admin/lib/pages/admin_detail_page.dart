import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../models/admin.dart';
import '../services/admin_service.dart';
import '../widgets/common_widgets.dart';

/// Detail satu Admin berdasarkan ID (GET) + tombol hapus (DELETE).
class AdminDetailPage extends StatefulWidget {
  const AdminDetailPage({super.key, required this.id, required this.service});

  final int id;
  final AdminService service;

  @override
  State<AdminDetailPage> createState() => _AdminDetailPageState();
}

class _AdminDetailPageState extends State<AdminDetailPage> {
  late Future<Admin> _futureAdmin;
  Widget? _deleteResult;

  @override
  void initState() {
    super.initState();
    _futureAdmin = widget.service.getAdmin(widget.id);
  }

  Future<void> _delete() async {
    final ok = await showConfirmDelete(context, 'Admin dengan ID ${widget.id}');
    if (!ok) return;
    final url = '${ApiConfig.baseUrl}${ApiConfig.adminPath}/${widget.id}';
    try {
      final r = await widget.service.deleteAdmin(widget.id);
      setState(() => _deleteResult = ResultCard.fromResult(r,
          note: 'Berhasil dihapus. (Fake API: data di server tidak benar-benar hilang.)'));
    } catch (e) {
      setState(() => _deleteResult = ResultCard.fromError('DELETE', url, e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Admin #${widget.id}'),
        actions: [
          IconButton(
            tooltip: 'Hapus Admin ini',
            icon: const Icon(Icons.delete),
            onPressed: _delete,
          ),
        ],
      ),
      body: ListView(
        children: [
          FutureBuilder<Admin>(
            future: _futureAdmin,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return ErrorView(
                  error: snapshot.error!,
                  hint: 'Server demo hanya punya ID 1-10. Admin ${widget.id} '
                      'tidak tersimpan di server sehingga GET membalas 404. '
                      'DELETE tetap bisa diuji lewat tombol hapus di atas.',
                );
              }
              final a = snapshot.data!;
              return Card(
                margin: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    ListTile(
                        leading: const Icon(Icons.badge),
                        title: const Text('ID'),
                        subtitle: Text('${a.id}')),
                    ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Nama'),
                        subtitle: Text(a.name)),
                    ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('Email'),
                        subtitle: Text(a.email)),
                    ListTile(
                        leading: const Icon(Icons.apartment),
                        title: const Text('Departemen'),
                        subtitle: Text(a.department)),
                  ],
                ),
              );
            },
          ),
          if (_deleteResult != null) _deleteResult!,
        ],
      ),
    );
  }
}
