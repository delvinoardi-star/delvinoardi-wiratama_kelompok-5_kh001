import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../models/admin.dart';
import '../services/admin_service.dart';
import '../services/api_result.dart';
import '../widgets/common_widgets.dart';
import 'admin_detail_page.dart';

/// Halaman daftar Admin + hapus Admin (dengan konfirmasi).
class AdminListPage extends StatefulWidget {
  const AdminListPage({super.key, required this.service});

  final AdminService service;

  @override
  State<AdminListPage> createState() => _AdminListPageState();
}

class _AdminListPageState extends State<AdminListPage> {
  late Future<List<Admin>> _futureAdmins;
  Widget? _lastDeleteResult; // kartu hasil DELETE terakhir (untuk screenshot)

  @override
  void initState() {
    super.initState();
    _futureAdmins = widget.service.getAdmins();
  }

  void _reload() => setState(() {
        _lastDeleteResult = null;
        _futureAdmins = widget.service.getAdmins();
      });

  void _openDetail(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminDetailPage(id: id, service: widget.service),
      ),
    );
  }

  Future<void> _searchById() async {
    final id = await showIdDialog(context,
        title: 'Detail Admin berdasarkan ID', initialId: PraktikumIds.adminId);
    if (id != null) _openDetail(id);
  }

  Future<void> _deleteById() async {
    final id = await showIdDialog(context,
        title: 'Hapus Admin berdasarkan ID', initialId: PraktikumIds.adminId);
    if (id == null || !mounted) return;
    await _delete(id, null);
  }

  /// Hapus Admin: konfirmasi dulu -> DELETE -> tampilkan hasil.
  /// [admins] = list yang sedang tampil (null jika hapus lewat input ID).
  Future<void> _delete(int id, List<Admin>? admins) async {
    final ok = await showConfirmDelete(context, 'Admin dengan ID $id');
    if (!ok) return;

    final url = '${ApiConfig.baseUrl}${ApiConfig.adminPath}/$id';
    try {
      final ApiResult<void> r = await widget.service.deleteAdmin(id);
      setState(() {
        // Server demo tidak benar-benar menghapus, jadi kita hapus dari
        // tampilan (state lokal) agar user melihat efeknya.
        admins?.removeWhere((a) => a.id == id);
        _lastDeleteResult = ResultCard.fromResult(r,
            note: 'Admin $id berhasil dihapus (respons ${r.statusCode}). '
                'Catatan: JSONPlaceholder adalah fake API, data di server '
                'tidak benar-benar terhapus.');
      });
    } catch (e) {
      setState(() => _lastDeleteResult = ResultCard.fromError('DELETE', url, e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Admin'),
        actions: [
          IconButton(
            tooltip: 'Detail Admin berdasarkan ID',
            icon: const Icon(Icons.search),
            onPressed: _searchById,
          ),
          IconButton(
            tooltip: 'Hapus Admin berdasarkan ID',
            icon: const Icon(Icons.delete_forever),
            onPressed: _deleteById,
          ),
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          ),
        ],
      ),
      body: FutureBuilder<List<Admin>>(
        future: _futureAdmins,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorView(error: snapshot.error!, onRetry: _reload);
          }
          final admins = snapshot.data ?? [];
          return ListView(
            children: [
              const InfoBanner(
                  'Server demo tidak punya endpoint admin, jadi data Admin '
                  'diambil dari /users dan "department" = company.name.'),
              if (_lastDeleteResult != null) _lastDeleteResult!,
              for (final a in admins)
                ListTile(
                  leading: CircleAvatar(child: Text('${a.id}')),
                  title: Text(a.name),
                  subtitle: Text('${a.email}\nDepartemen: ${a.department}'),
                  isThreeLine: true,
                  onTap: () => _openDetail(a.id),
                  trailing: IconButton(
                    tooltip: 'Hapus Admin ${a.id}',
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _delete(a.id, admins),
                  ),
                ),
              if (admins.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('Semua Admin sudah dihapus')),
                ),
            ],
          );
        },
      ),
    );
  }
}
