import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kartu_mahasiswa/kartu_mahasiswa.dart';
import 'package:kartu_mahasiswa/main.dart';

void main() {
  testWidgets('Kartu menampilkan nama, NIM, dan prodi', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Delvino Ardi Wiratama'), findsOneWidget);
    expect(find.text('20250801116'), findsOneWidget);
    expect(find.text('Teknik Informatika'), findsOneWidget);
    expect(find.byType(Divider), findsNWidgets(3));
    final box = tester.widget<Container>(find.descendant(
        of: find.byType(KartuMahasiswa), matching: find.byType(Container)).first);
    expect(box.constraints?.maxWidth, 320.0);
  });
}
