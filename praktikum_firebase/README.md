# Praktikum 5 — Form Input Firebase (Form Presensi Praktikum)

Nama: Delvino Ardi Wiratama · NIM: 20250801116

## Isi
- `lib/main.dart`: form presensi (Nama, NIM, Lokasi, Mata Kuliah, dropdown Keterangan Kehadiran),
  fungsi `simpanData()` yang mengirim data ke collection `praktikum` di Cloud Firestore,
  validasi field wajib, notifikasi berhasil/gagal, dan pengosongan form setelah berhasil.
- `lib/firebase_options.dart`: CONTOH. Ganti dengan milik project Firebase kamu.

## Cara menjalankan
1. Pakai `firebase_options.dart` dari praktikum sebelumnya, atau jalankan
   `dart pub global run flutterfire_cli:flutterfire configure`.
2. `flutter pub get`
3. `flutter run -d chrome`

## Field yang tersimpan di Firestore (collection `praktikum`)
| Field | Isi |
|---|---|
| nama | dari TextFormField Nama |
| nim | dari TextFormField NIM |
| lokasi | dari TextFormField Lokasi |
| mata_kuliah | dari TextFormField Mata Kuliah |
| keterangan | Hadir / Izin / Sakit |
| waktu | waktu server (serverTimestamp) |

## Kalau muncul "TimeoutException"
Biasanya karena database Firestore belum dibuat atau rules menolak penulisan.
Buat database di Firebase Console, lalu pastikan rules mengizinkan tulis ke `praktikum`
(untuk praktikum boleh pakai test mode).
