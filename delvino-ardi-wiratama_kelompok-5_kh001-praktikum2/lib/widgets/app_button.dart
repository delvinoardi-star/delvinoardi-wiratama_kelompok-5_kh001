import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/colors.dart';

/// Tombol yang bisa dipakai ulang.
/// - Isi [url] untuk membuka alamat di aplikasi luar (browser).
/// - Isi [onPressed] untuk menjalankan aksi di dalam aplikasi.
class AppButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? url;
  final VoidCallback? onPressed;

  const AppButton({
    super.key,
    required this.label,
    required this.icon,
    this.url,
    this.onPressed,
  });

  Future<void> _tekan(BuildContext context) async {
    if (onPressed != null) {
      onPressed!();
      return;
    }
    if (url == null) return;

    final berhasil = await launchUrl(
      Uri.parse(url!),
      mode: LaunchMode.externalApplication,
    );
    if (!berhasil && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _tekan(context),
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
