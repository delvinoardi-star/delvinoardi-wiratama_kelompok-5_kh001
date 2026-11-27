# Praktikum 2 – Pemrograman Mobile

Nama: Delvino Ardi Wiratama · NIM: 20250801116 · Kelompok 5 · KH001

Praktikum ini menerapkan pemisahan komponen, pengaturan tema, reusable widget, dan
integrasi URL eksternal dengan `url_launcher`.

## Implementasi

1. **Pengelolaan warna** (`lib/constants/colors.dart`): `primary`, `background`, `card`,
   `textPrimary`, dan `textSecondary` dikumpulkan di satu kelas `AppColors`.
2. **AppTheme** (`lib/theme/app_theme.dart`): `ThemeData` Material 3 dengan
   `ColorScheme.fromSeed` mode gelap, warna latar dari `AppColors.background`, dan gaya AppBar.
3. **Reusable AppButton** (`lib/widgets/app_button.dart`): parameter `label`, `icon`, `url`,
   dan `onPressed`. Kalau `onPressed` diisi, tombol menjalankan aksi internal; kalau `url`
   diisi, tombol membuka alamat di aplikasi luar.
4. **url_launcher**: tombol "Buka GitHub Saya" membuka https://github.com/delvinoardi-star.
   Kalau gagal dibuka, muncul SnackBar "Gagal membuka URL".
5. **main.dart**: AppBar "Demo Aplikasi Delvino", kartu identitas (nama dan NIM), deskripsi,
   tombol GitHub, dan tombol "Tes Tombol" yang menampilkan SnackBar.

## Struktur File

```text
lib/
├── main.dart
├── constants/
│   └── colors.dart
├── theme/
│   └── app_theme.dart
└── widgets/
    └── app_button.dart
```

## Menjalankan

```
flutter pub get
flutter run -d chrome
```
