import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../widgets/common_widgets.dart';

/// Halaman untuk menguji GET/POST/PUT/PATCH/DELETE User satu per satu dan
/// menampilkan status code + body respons (untuk screenshot laporan).
class CrudTestPage extends StatefulWidget {
  const CrudTestPage({super.key, required this.service});

  final ApiService service;

  @override
  State<CrudTestPage> createState() => _CrudTestPageState();
}

class _CrudTestPageState extends State<CrudTestPage> {
  final _idCtrl = TextEditingController(text: '${PraktikumIds.userId}');
  final _nameCtrl = TextEditingController(text: 'Delvino Ardi Wiratama');
  final _emailCtrl = TextEditingController(text: 'delvino.116@example.com');
  final _cityCtrl = TextEditingController(text: 'Jakarta');

  bool _loading = false;
  Widget? _result;

  @override
  void dispose() {
    _idCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  int get _id => int.tryParse(_idCtrl.text.trim()) ?? PraktikumIds.userId;
  String _url([int? id]) =>
      '${ApiConfig.baseUrl}${ApiConfig.userPath}${id == null ? '' : '/$id'}';

  /// Menjalankan satu aksi: tampilkan loading, lalu hasil/error.
  Future<void> _run(Future<Widget> Function() action) async {
    setState(() => _loading = true);
    final widgetResult = await action();
    if (!mounted) return;
    setState(() {
      _loading = false;
      _result = widgetResult;
    });
  }

  // ------------------------------------------------------------ GET
  Future<void> _get() => _run(() async {
        final id = _id;
        try {
          final r = await widget.service.fetchUser(id);
          return ResultCard.fromResult(r, note: 'Data User ${r.data.id}: ${r.data.name}');
        } catch (e) {
          return ResultCard.fromError('GET', _url(id), e,
              note: 'ID $id tidak ada di server demo (hanya 1-10). '
                  'Ganti ID ke 1 untuk melihat GET yang berhasil.');
        }
      });

  // ----------------------------------------------------------- POST
  Future<void> _post() => _run(() async {
        final newUser = User(
          id: PraktikumIds.userId, // 1116 sesuai soal
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          city: _cityCtrl.text.trim(),
        );
        try {
          final r = await widget.service.createUser(newUser);
          return ResultCard.fromResult(r,
              note: 'Dikirim dengan id ${PraktikumIds.userId}. Server membalas '
                  'id ${r.data.id}${r.data.id == PraktikumIds.userId ? '' : ' (fake API membuat id sendiri)'}. '
                  'Data tidak benar-benar tersimpan di server.');
        } catch (e) {
          return ResultCard.fromError('POST', _url(), e);
        }
      });

  // ------------------------------------------------------------ PUT
  Future<void> _put() => _run(() async {
        final id = _id;
        final updated = User(
          id: id,
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          city: _cityCtrl.text.trim(),
        );
        try {
          final r = await widget.service.updateUser(updated);
          return ResultCard.fromResult(r,
              note: 'Nama & email User $id diperbarui (PUT mengirim data utuh). '
                  'Fake API: perubahan tidak disimpan permanen.');
        } catch (e) {
          return ResultCard.fromError('PUT', _url(id), e,
              note: 'Jika error karena ID $id tidak ada di server demo, '
                  'coba ganti ID ke 1.');
        }
      });

  // ---------------------------------------------------------- PATCH
  Future<void> _patch() => _run(() async {
        final id = _id;
        // Ambil nama lama dulu; jika User tidak ada di server (404),
        // pakai nama dari form sebagai nama dasar.
        String baseName = _nameCtrl.text.trim();
        String source = 'nama dari form (GET $id gagal/404)';
        try {
          baseName = (await widget.service.getUser(id)).name;
          source = 'nama lama hasil GET';
        } catch (_) {}

        final newName = '$baseName${PraktikumIds.patchSuffix}';
        try {
          final r = await widget.service.patchUserName(id, newName);
          return ResultCard.fromResult(r,
              note: 'Nama dasar: $source.\nNama baru: "$newName".');
        } catch (e) {
          return ResultCard.fromError('PATCH', _url(id), e);
        }
      });

  // --------------------------------------------------------- DELETE
  Future<void> _delete() async {
    final id = _id;
    final ok = await showConfirmDelete(context, 'User dengan ID $id');
    if (!ok) return;
    await _run(() async {
      try {
        final r = await widget.service.deleteUser(id);
        return ResultCard.fromResult(r,
            note: 'User $id dihapus (respons ${r.statusCode}). Fake API: '
                'server membalas sukses walau data tidak benar-benar dihapus.');
      } catch (e) {
        return ResultCard.fromError('DELETE', _url(id), e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttons = <(String, IconData, VoidCallback)>[
      ('GET', Icons.download, _get),
      ('POST', Icons.add, _post),
      ('PUT', Icons.edit, _put),
      ('PATCH', Icons.edit_note, _patch),
      ('DELETE', Icons.delete, _delete),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Uji CRUD User')),
      body: ListView(
        children: [
          const InfoBanner(
              'ID User = ${PraktikumIds.userId}, ID Admin = ${PraktikumIds.adminId} '
              '(NIM 20250801116, N = ${PraktikumIds.n}). Server: JSONPlaceholder '
              '(fake API) - POST/PUT/PATCH/DELETE membalas sukses tetapi data '
              'tidak benar-benar berubah.'),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _idCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'ID target (GET/PUT/PATCH/DELETE)',
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Nama (POST/PUT)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Email (POST/PUT)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _cityCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Kota (POST/PUT)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final (label, icon, onTap) in buttons)
                      FilledButton.icon(
                        onPressed: _loading ? null : onTap,
                        icon: Icon(icon),
                        label: Text(label),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_result != null)
            _result!,
        ],
      ),
    );
  }
}
