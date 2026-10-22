import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';
import '../widgets.dart';

// ───────────────────────── SPLASH ─────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _t;
  @override
  void initState() {
    super.initState();
    _t = Timer(const Duration(milliseconds: 2800), () {
      if (mounted) context.go('/onboarding');
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1D8052), Color(0xFF0F3D2B)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
                top: -120, left: -120, child: Decor(360, Color(0x1FFFFFFF))),
            const Positioned(
                bottom: -80, right: -150, child: Decor(420, Color(0x33A5A53A))),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LogoBox(110),
                  const SizedBox(height: 28),
                  const Text('Makan Bergizi Gratis',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text('Integrated School Meal Program',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75), fontSize: 15)),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 130,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 2600),
                      builder: (_, v, __) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: v,
                          minHeight: 6,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation(C.amber),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 36,
              left: 0,
              right: 0,
              child: Text('Versi 1.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── ONBOARDING ─────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  static const _pages = [
    (
      Icons.qr_code_scanner_rounded,
      'Klaim makan cukup dengan scan QR',
      'Scan QR di meja dapur, lalu tunjukkan layar hijau ke petugas. Tanpa antre kartu, tanpa kertas.'
    ),
    (
      Icons.health_and_safety_rounded,
      'Aman untuk alergimu',
      'Isi profil alergi sekali saja. Dapur otomatis menyiapkan porsi pengganti bila menu mengandung alergenmu.'
    ),
    (
      Icons.star_rounded,
      'Suaramu menentukan menu',
      'Beri rating dan ulasan setiap hari agar menu makin enak dan bergizi.'
    ),
  ];

  void _next() {
    if (_page < _pages.length - 1) {
      _ctrl.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Lewati',
                    style: TextStyle(
                        color: C.muted,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) {
                  final p = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFFCBE6D0), Color(0xFFF8E5AE)],
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: Icon(p.$1, size: 64, color: C.primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(p.$2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                height: 1.2)),
                        const SizedBox(height: 12),
                        Text(p.$3,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: C.muted, fontSize: 15, height: 1.5)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _page ? 26 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _page ? C.primary : const Color(0xFFC9D6CE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: PrimaryButton(
                _page == _pages.length - 1 ? 'Mulai' : 'Lanjut',
                trailing: Icons.chevron_right_rounded,
                onPressed: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── LOGIN ─────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _user = TextEditingController();
  final _pass = TextEditingController();

  @override
  void dispose() {
    _user.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _login() {
    if (!_form.currentState!.validate()) return;
    final u = _user.text.trim().toLowerCase();
    // Dummy: tentukan peran dari username (sementara, belum ada backend)
    if (u.contains('admin')) {
      context.go('/admin');
    } else if (u.contains('katering') || u.contains('dapur')) {
      context.go('/dapur');
    } else {
      context.go('/siswa');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                    24, MediaQuery.of(context).padding.top + 40, 24, 36),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1D8052), Color(0xFF0F3D2B)],
                  ),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(40)),
                ),
                child: const Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                        top: -150,
                        right: -90,
                        child: Decor(280, Color(0x33A5A53A))),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LogoBox(68),
                        SizedBox(height: 22),
                        Text('Selamat datang',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w800)),
                        SizedBox(height: 6),
                        Text('Masuk untuk melanjutkan ke MBG',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 15)),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      AppField(
                        label: 'Username',
                        hint: 'Masukkan username',
                        controller: _user,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Username wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      AppField(
                        label: 'Password',
                        hint: 'Masukkan password',
                        controller: _pass,
                        obscure: true,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Password wajib diisi'
                            : null,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context.push('/forgot'),
                          child: const Text('Lupa password?',
                              style: TextStyle(
                                  color: C.primary,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                      PrimaryButton('Masuk', onPressed: _login),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Belum punya akun siswa? ',
                              style: TextStyle(color: C.muted)),
                          GestureDetector(
                            onTap: () => context.push('/register'),
                            child: const Text('Daftar',
                                style: TextStyle(
                                    color: C.primary,
                                    fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 56),
                      const Text('Prototype · masuk sesuai peran',
                          style: TextStyle(
                              color: C.muted,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              child: OutlineButton2('Siswa',
                                  onPressed: () => context.go('/siswa'))),
                          const SizedBox(width: 10),
                          Expanded(
                              child: OutlineButton2('Dapur',
                                  onPressed: () => context.go('/dapur'))),
                          const SizedBox(width: 10),
                          Expanded(
                              child: OutlineButton2('Admin',
                                  onPressed: () => context.go('/admin'))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── DAFTAR ─────────────────────────
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _nisn = TextEditingController();
  final _kelas = TextEditingController();
  final _user = TextEditingController();
  final _pass = TextEditingController();
  final _pass2 = TextEditingController();
  bool _agree = false;
  bool _agreeError = false;

  @override
  void dispose() {
    for (final c in [_name, _nisn, _kelas, _user, _pass, _pass2]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _req(String? v, String msg) =>
      (v == null || v.trim().isEmpty) ? msg : null;

  void _submit() {
    final ok = _form.currentState!.validate();
    setState(() => _agreeError = !_agree);
    if (!ok || !_agree) return;
    context.go('/register-done',
        extra: {'name': _name.text.trim(), 'nisn': _nisn.text.trim()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SubPageHeader(title: 'Buat Akun Siswa', onBack: () => context.pop()),
          const Divider(height: 1, color: C.border),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: C.soft,
                          borderRadius: BorderRadius.circular(18)),
                      child: const Text(
                        'Pendaftaran khusus Siswa / Orang Tua. Akun aktif setelah diverifikasi Admin Sekolah.',
                        style: TextStyle(
                            color: C.dark,
                            fontWeight: FontWeight.w600,
                            height: 1.4),
                      ),
                    ),
                    const SizedBox(height: 18),
                    AppField(
                      label: 'Nama lengkap',
                      hint: 'Nama sesuai data sekolah',
                      controller: _name,
                      validator: (v) => _req(v, 'Nama wajib diisi'),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: AppField(
                            label: 'NISN',
                            hint: '10 digit',
                            controller: _nisn,
                            keyboardType: TextInputType.number,
                            validator: (v) =>
                                (v == null || !RegExp(r'^\d{10}$').hasMatch(v))
                                    ? 'NISN harus 10 digit'
                                    : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 4,
                          child: AppField(
                            label: 'Kelas',
                            hint: 'X-A',
                            controller: _kelas,
                            validator: (v) => _req(v, 'Wajib'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    AppField(
                      label: 'Username',
                      hint: 'Pilih username',
                      controller: _user,
                      validator: (v) => _req(v, 'Username wajib diisi'),
                    ),
                    const SizedBox(height: 14),
                    AppField(
                      label: 'Password',
                      hint: 'Minimal 8 karakter',
                      controller: _pass,
                      obscure: true,
                      validator: (v) => (v == null || v.length < 8)
                          ? 'Minimal 8 karakter'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    AppField(
                      label: 'Konfirmasi password',
                      hint: 'Ulangi password',
                      controller: _pass2,
                      obscure: true,
                      validator: (v) =>
                          v != _pass.text ? 'Password tidak sama' : null,
                    ),
                    const SizedBox(height: 14),
                    InkWell(
                      onTap: () => setState(() {
                        _agree = !_agree;
                        _agreeError = false;
                      }),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _agree,
                            activeColor: C.primary,
                            onChanged: (v) => setState(() {
                              _agree = v ?? false;
                              _agreeError = false;
                            }),
                          ),
                          Expanded(
                            child: Text('Saya menyetujui syarat & ketentuan',
                                style: TextStyle(
                                    color: _agreeError ? C.danger : C.muted)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton('Daftar', onPressed: _submit),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Sudah punya akun? ',
                            style: TextStyle(color: C.muted)),
                        GestureDetector(
                          onTap: () => context.go('/login'),
                          child: const Text('Masuk',
                              style: TextStyle(
                                  color: C.primary,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── PENDAFTARAN TERKIRIM ─────────────────────────
class RegisterDoneScreen extends StatelessWidget {
  final String name;
  final String nisn;
  const RegisterDoneScreen({super.key, required this.name, required this.nisn});

  Widget _row(String k, Widget v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(k, style: const TextStyle(color: C.muted, fontSize: 15)),
            v,
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 104,
                height: 104,
                decoration:
                    const BoxDecoration(color: C.soft, shape: BoxShape.circle),
                child: Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                        color: C.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.check_rounded,
                        color: Colors.white, size: 44),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text('Pendaftaran Terkirim',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              const Text(
                'Akun kamu sedang menunggu verifikasi Admin Sekolah. Kamu bisa masuk setelah akun disetujui.',
                textAlign: TextAlign.center,
                style: TextStyle(color: C.muted, fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: C.border),
                ),
                child: Column(
                  children: [
                    _row(
                      'Status',
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                            color: const Color(0xFFFFF0D0),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text('Menunggu verifikasi',
                            style: TextStyle(
                                color: Color(0xFF8A5A00),
                                fontWeight: FontWeight.w800,
                                fontSize: 12.5)),
                      ),
                    ),
                    _row('Nama',
                        Text(name, style: const TextStyle(fontWeight: FontWeight.w800))),
                    _row('NISN',
                        Text(nisn, style: const TextStyle(fontWeight: FontWeight.w800))),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              PrimaryButton('Ke Halaman Masuk',
                  onPressed: () => context.go('/login')),
              const SizedBox(height: 18),
              const Text(
                'Kamu akan dapat notifikasi saat akun disetujui atau ditolak.',
                textAlign: TextAlign.center,
                style: TextStyle(color: C.muted, fontSize: 13.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── LUPA PASSWORD ─────────────────────────
class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});
  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _form = GlobalKey<FormState>();
  final _id = TextEditingController();

  @override
  void dispose() {
    _id.dispose();
    super.dispose();
  }

  void _send() {
    if (!_form.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Permintaan reset dikirim ke Admin Sekolah')));
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SubPageHeader(title: 'Lupa Password', onBack: () => context.pop()),
          const Divider(height: 1, color: C.border),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                          color: C.soft,
                          borderRadius: BorderRadius.circular(22)),
                      child: const Icon(Icons.lock_outline_rounded,
                          color: C.primary, size: 30),
                    ),
                    const SizedBox(height: 20),
                    const Text('Reset password',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    const Text(
                        'Masukkan username atau NISN. Permintaan reset akan dikirim ke Admin Sekolah.',
                        style: TextStyle(color: C.muted, fontSize: 15, height: 1.5)),
                    const SizedBox(height: 20),
                    AppField(
                      label: 'Username / NISN',
                      hint: 'Masukkan username atau NISN',
                      controller: _id,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton('Kirim Permintaan Reset', onPressed: _send),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: () => context.pop(),
                        child: const Text('Kembali ke Masuk',
                            style: TextStyle(
                                color: C.primary, fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
