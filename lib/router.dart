import 'package:go_router/go_router.dart';
import 'screens/auth.dart';
import 'screens/role_home.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(
      path: '/register-done',
      builder: (_, state) {
        final data = (state.extra as Map<String, String>?) ?? {};
        return RegisterDoneScreen(
          name: data['name'] ?? 'Aisyah Putri',
          nisn: data['nisn'] ?? '0051234567',
        );
      },
    ),
    GoRoute(path: '/forgot', builder: (_, __) => const ForgotScreen()),
    // Sementara placeholder, diganti layar asli di langkah berikutnya
    GoRoute(path: '/siswa', builder: (_, __) => const RoleHome(role: 'Siswa')),
    GoRoute(path: '/dapur', builder: (_, __) => const RoleHome(role: 'Dapur')),
    GoRoute(path: '/admin', builder: (_, __) => const RoleHome(role: 'Admin')),
  ],
);
