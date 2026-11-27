/// Konfigurasi API di SATU tempat.
///
/// Kalau dosen/asisten memakai API lain, cukup ganti [baseUrl] (dan
/// [adminPath] bila server punya endpoint admin sendiri). File lain tidak
/// perlu diubah.
class ApiConfig {
  ApiConfig._(); // tidak perlu dibuat objeknya, cukup dipakai konstantanya

  /// Server REST API demo (fake API) yang dipakai di praktikum.
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Endpoint data User.
  static const String userPath = '/users';

  /// Endpoint data Admin.
  /// JSONPlaceholder TIDAK punya endpoint /admins, jadi Admin diambil dari
  /// /users dan `department` diisi dari `company.name`.
  /// Jika server dosen punya endpoint admin, ganti misalnya menjadi '/admins'.
  static const String adminPath = '/users';

  /// Batas waktu tunggu tiap request.
  static const Duration timeout = Duration(seconds: 15);

  /// Header standar untuk request yang mengirim body JSON.
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };
}

/// ID sesuai NIM 20250801116 -> N = 116.
class PraktikumIds {
  PraktikumIds._();

  static const int n = 116;
  static const int userId = 1000 + n; // 1116
  static const int adminId = 2000 + n; // 2116

  /// Teks yang ditambahkan ke nama saat PATCH.
  static const String patchSuffix = ' - Flutter Developer';
}
