import 'package:flutter/material.dart';

import 'pages/admin_list_page.dart';
import 'pages/crud_test_page.dart';
import 'pages/user_list_page.dart';
import 'services/admin_service.dart';
import 'services/api_service.dart';

/// Praktikum Pemrograman Mobile - REST API User & Admin
/// Delvino Ardi Wiratama - NIM 20250801116 (N = 116)
void main() {
  runApp(MyApp(apiService: ApiService(), adminService: AdminService()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.apiService, required this.adminService});

  // Service dibuat sekali di sini lalu dioper ke halaman (mudah diganti
  // MockClient saat widget test).
  final ApiService apiService;
  final AdminService adminService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum API 116',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: HomePage(apiService: apiService, adminService: adminService),
    );
  }
}

/// Halaman utama dengan 3 tab: User, Admin, Uji CRUD.
class HomePage extends StatefulWidget {
  const HomePage(
      {super.key, required this.apiService, required this.adminService});

  final ApiService apiService;
  final AdminService adminService;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      UserListPage(service: widget.apiService),
      AdminListPage(service: widget.adminService),
      CrudTestPage(service: widget.apiService),
    ];

    return Scaffold(
      // IndexedStack: semua tab tetap hidup, jadi data tidak di-request ulang
      // setiap pindah tab.
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.people), label: 'User'),
          NavigationDestination(
              icon: Icon(Icons.admin_panel_settings), label: 'Admin'),
          NavigationDestination(icon: Icon(Icons.science), label: 'Uji CRUD'),
        ],
      ),
    );
  }
}
