import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:praktikum_firebase/main.dart';

void main() {
  testWidgets('Tidak bisa simpan kalau field wajib kosong', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: FormPresensiPage()));

    expect(find.text('Form Presensi Praktikum'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));

    await tester.tap(find.text('Simpan'));
    await tester.pump();

    expect(find.text('Nama wajib diisi'), findsOneWidget);
    expect(find.text('NIM wajib diisi'), findsOneWidget);
    expect(find.text('Lokasi wajib diisi'), findsOneWidget);
    expect(find.text('Mata Kuliah wajib diisi'), findsOneWidget);
    expect(find.text('Keterangan kehadiran wajib dipilih'), findsOneWidget);
  });

  testWidgets('Dropdown punya pilihan Hadir, Izin, Sakit', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: FormPresensiPage()));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    expect(find.text('Hadir'), findsWidgets);
    expect(find.text('Izin'), findsWidgets);
    expect(find.text('Sakit'), findsWidgets);
  });
}
