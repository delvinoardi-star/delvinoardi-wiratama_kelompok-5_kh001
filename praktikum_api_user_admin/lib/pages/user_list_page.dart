import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../widgets/common_widgets.dart';
import 'user_detail_page.dart';

/// Halaman daftar User (GET /users) memakai FutureBuilder.
class UserListPage extends StatefulWidget {
  const UserListPage({super.key, required this.service});

  final ApiService service;

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  // Future disimpan di state agar request TIDAK diulang setiap build().
  late Future<List<User>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _futureUsers = widget.service.getUsers();
  }

  void _reload() => setState(() => _futureUsers = widget.service.getUsers());

  void _openDetail(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserDetailPage(id: id, service: widget.service),
      ),
    );
  }

  Future<void> _searchById() async {
    final id = await showIdDialog(context,
        title: 'Detail User berdasarkan ID', initialId: PraktikumIds.userId);
    if (id != null) _openDetail(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar User'),
        actions: [
          IconButton(
            tooltip: 'Detail User berdasarkan ID',
            icon: const Icon(Icons.search),
            onPressed: _searchById,
          ),
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: _futureUsers,
        builder: (context, snapshot) {
          // 1) Masih menunggu respons
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2) Gagal (ApiException dari service)
          if (snapshot.hasError) {
            return ErrorView(error: snapshot.error!, onRetry: _reload);
          }
          // 3) Berhasil
          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return const Center(child: Text('Belum ada data User'));
          }
          return ListView.separated(
            itemCount: users.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final u = users[i];
              return ListTile(
                leading: CircleAvatar(child: Text('${u.id}')),
                title: Text(u.name),
                subtitle: Text('${u.email}\n${u.city}'),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openDetail(u.id),
              );
            },
          );
        },
      ),
    );
  }
}
