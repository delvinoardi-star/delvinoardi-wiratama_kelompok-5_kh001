import 'package:flutter_test/flutter_test.dart';

import 'package:praktikum2_delvino/main.dart';

void main() {
  testWidgets('Menampilkan identitas dan dua tombol', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Demo Aplikasi Delvino'), findsOneWidget);
    expect(find.text('Delvino Ardi Wiratama'), findsOneWidget);
    expect(find.text('NIM 20250801116'), findsOneWidget);
    expect(find.text('Buka GitHub Saya'), findsOneWidget);
    expect(find.text('Tes Tombol'), findsOneWidget);
  });

  testWidgets('Tes Tombol menampilkan SnackBar', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Tes Tombol'));
    await tester.pump();
    expect(find.text('Tombol berhasil ditekan!'), findsOneWidget);
  });
}
