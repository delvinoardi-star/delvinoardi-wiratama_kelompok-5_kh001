/// Bungkus hasil request: status code, body mentah, dan data yang sudah
/// diubah ke objek Dart. Dipakai halaman "Uji CRUD" agar status code dan
/// body respons bisa ditampilkan (mudah di-screenshot untuk laporan).
class ApiResult<T> {
  final String method; // GET / POST / PUT / PATCH / DELETE
  final String url;
  final int statusCode;
  final String body;
  final T data;

  const ApiResult({
    required this.method,
    required this.url,
    required this.statusCode,
    required this.body,
    required this.data,
  });
}
