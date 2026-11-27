import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/api_service.dart';
import '../widgets/common_widgets.dart';

/// Detail satu User berdasarkan ID (GET /users/{id}).
class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key, required this.id, required this.service});

  final int id;
  final ApiService service;

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late Future<User> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = widget.service.getUser(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail User #${widget.id}')),
      body: FutureBuilder<User>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorView(
              error: snapshot.error!,
              hint: 'Server demo JSONPlaceholder hanya punya User ID 1-10. '
                  'ID ${widget.id} tidak tersimpan di server, jadi GET '
                  'membalas 404. Ini perilaku normal fake API.',
            );
          }
          final u = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Card(
                child: Column(
                  children: [
                    ListTile(
                        leading: const Icon(Icons.badge),
                        title: const Text('ID'),
                        subtitle: Text('${u.id}')),
                    ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Nama'),
                        subtitle: Text(u.name)),
                    ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('Email'),
                        subtitle: Text(u.email)),
                    ListTile(
                        leading: const Icon(Icons.location_city),
                        title: const Text('Kota (address.city)'),
                        subtitle: Text(u.city)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
