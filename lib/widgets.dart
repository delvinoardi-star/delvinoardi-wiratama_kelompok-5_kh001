import 'package:flutter/material.dart';
import 'theme.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? trailing;
  const PrimaryButton(this.label, {super.key, this.onPressed, this.trailing});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: C.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              Icon(trailing, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class OutlineButton2 extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const OutlineButton2(this.label, {super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: C.ink,
          backgroundColor: Colors.white,
          side: const BorderSide(color: C.border, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        child: Text(label),
      ),
    );
  }
}

class AppField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool obscure;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  const AppField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.obscure = false,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: C.muted, fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF8A9890)),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: C.border, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: C.primary, width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: C.danger, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: C.danger, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }
}

/// Header putih dengan tombol kembali + judul (dipakai di banyak layar)
class SubPageHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  const SubPageHeader({super.key, required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
          16, MediaQuery.of(context).padding.top + 12, 16, 12),
      decoration: null,
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: C.bg, borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.chevron_left_rounded, size: 28),
            ),
          ),
          const SizedBox(width: 14),
          Text(title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class Decor extends StatelessWidget {
  final double size;
  final Color color;
  const Decor(this.size, this.color, {super.key});
  @override
  Widget build(BuildContext context) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color));
}

class LogoBox extends StatelessWidget {
  final double size;
  const LogoBox(this.size, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(size * 0.3)),
      child: Icon(Icons.eco_rounded, color: C.primary, size: size * 0.5),
    );
  }
}
