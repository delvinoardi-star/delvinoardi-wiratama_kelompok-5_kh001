# Praktikum Pemrograman Mobile — REST API User & Admin (Flutter)

Delvino Ardi Wiratama — NIM 20250801116 (N = 116 → ID User **1116**, ID Admin **2116**)

Aplikasi Flutter untuk CRUD User (GET/POST/PUT/PATCH/DELETE) dan Admin (getAdmins, getAdmin, deleteAdmin)
memakai paket `http`, `FutureBuilder`, model `fromJson/toJson`, dan error handling (`statusCode` → `throw ApiException`).

## Cara menjalankan

```bash
flutter pub get
flutter run            # pilih emulator/HP Android, atau Chrome
flutter test           # 24 unit/widget test (tidak butuh internet, pakai MockClient)
flutter analyze
```

- Kalau muncul error versi paket di Flutter lama: hapus `pubspec.lock`, lalu `flutter pub get` lagi.
- Kalau folder `android/` error (versi Gradle/AGP beda dengan Flutter di laptop): jalankan `flutter create .`
  di folder ini untuk membuat ulang file platform (kode `lib/` dan `test/` tidak berubah).
  Setelah itu pastikan `<uses-permission android:name="android.permission.INTERNET" />` ada di
  `android/app/src/main/AndroidManifest.xml`.

## Ganti API

Semua alamat API ada di **satu file**: `lib/config/api_config.dart`.

| Konstanta | Default | Keterangan |
|---|---|---|
| `baseUrl` | `https://jsonplaceholder.typicode.com` | Ganti jika dosen memakai server lain |
| `userPath` | `/users` | Endpoint User |
| `adminPath` | `/users` | JSONPlaceholder tidak punya `/admins`; ganti bila server punya endpoint admin |

## Struktur

```
lib/
  config/api_config.dart        # base URL, endpoint, ID 1116/2116
  models/user.dart              # Model User (id, name, email, city)
  models/admin.dart             # Model Admin (id, name, email, department)
  services/api_service.dart     # ApiService: CRUD User
  services/admin_service.dart   # AdminService: getAdmins, getAdmin, deleteAdmin
  services/http_helper.dart     # sendRequest (error jaringan) + ensureStatus (cek status code)
  services/api_exception.dart   # Exception berisi statusCode & body
  services/api_result.dart      # Bungkus hasil: method, url, statusCode, body, data
  pages/                        # Daftar/detail User & Admin, halaman Uji CRUD
  widgets/common_widgets.dart   # ErrorView, ResultCard, dialog ID & konfirmasi hapus
test/                           # test model, service (MockClient), widget
screenshots/                    # contoh screenshot 1366x768 (data simulasi) — ganti dengan SS dari laptop sendiri
```

Dokumen: `LAPORAN.md` / `LAPORAN.pdf` (laporan), `PENJELASAN.md` (penjelasan kode + tanya-jawab).

## Catatan screenshot

Gambar di `screenshots/`, `LAPORAN.pdf`, dan `screenshots-output.pdf` masih **contoh**: diambil dari build web aplikasi ini dengan ukuran layar laptop (1366x768), tetapi respons API-nya disimulasikan karena JSONPlaceholder tidak bisa diakses dari lingkungan pembuat. Ada tulisan kecil "contoh" di pojok kanan bawah. Sebelum dikumpulkan, ganti dengan screenshot dari laptop sendiri (jalankan `flutter run -d chrome` atau di HP/emulator).
