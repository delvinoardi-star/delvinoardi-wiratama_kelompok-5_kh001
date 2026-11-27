// File ini CONTOH. Ganti dengan hasil perintah:
//   dart pub global run flutterfire_cli:flutterfire configure
// supaya terhubung ke project Firebase kamu (yang dipakai praktikum sebelumnya).
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => const FirebaseOptions(
        apiKey: 'GANTI_API_KEY',
        appId: 'GANTI_APP_ID',
        messagingSenderId: 'GANTI_SENDER_ID',
        projectId: 'GANTI_PROJECT_ID',
      );
}
