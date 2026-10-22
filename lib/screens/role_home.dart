import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';
import '../widgets.dart';

/// Placeholder: akan diganti Beranda Siswa / Dapur / Admin.
class RoleHome extends StatelessWidget {
  final String role;
  const RoleHome({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.construction_rounded, size: 56, color: C.primary),
              const SizedBox(height: 16),
              Text('Beranda $role',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('Layar ini dibuat di langkah berikutnya.',
                  style: TextStyle(color: C.muted)),
              const SizedBox(height: 24),
              PrimaryButton('Keluar', onPressed: () => context.go('/login')),
            ],
          ),
        ),
      ),
    );
  }
}
