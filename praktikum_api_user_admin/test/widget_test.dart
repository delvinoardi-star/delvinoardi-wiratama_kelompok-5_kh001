import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:praktikum_api_user_admin/main.dart';
import 'package:praktikum_api_user_admin/services/admin_service.dart';
import 'package:praktikum_api_user_admin/services/api_service.dart';

void main() {
  final client = MockClient((req) async {
    if (req.method == 'DELETE') return http.Response('{}', 200);
    return http.Response(
        jsonEncode([
          {
            'id': 1,
            'name': 'Leanne Graham',
            'email': 'Sincere@april.biz',
            'address': {'city': 'Gwenborough'},
            'company': {'name': 'Romaguera-Crona'},
          }
        ]),
        200);
  });

  Widget app() => MyApp(
        apiService: ApiService(client: client),
        adminService: AdminService(client: client),
      );

  testWidgets('Tab User menampilkan daftar dari API', (tester) async {
    await tester.pumpWidget(app());
    expect(find.byType(CircularProgressIndicator), findsWidgets);
    await tester.pumpAndSettle();
    expect(find.text('Daftar User'), findsOneWidget);
    expect(find.text('Leanne Graham'), findsWidgets);
  });

  testWidgets('Hapus Admin memakai dialog konfirmasi', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Admin'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Hapus Admin 1'));
    await tester.pumpAndSettle();
    expect(find.text('Konfirmasi hapus'), findsOneWidget);
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Status code: 200'), findsOneWidget);
    expect(find.text('Semua Admin sudah dihapus'), findsOneWidget);
  });
}
