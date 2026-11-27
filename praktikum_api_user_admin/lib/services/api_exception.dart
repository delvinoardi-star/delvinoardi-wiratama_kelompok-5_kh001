/// Exception khusus untuk kegagalan request API.
///
/// Tetap sebuah `Exception` (implements Exception), tetapi membawa
/// [statusCode] dan [body] supaya UI bisa menampilkan detail error,
/// misalnya "404 - User tidak ditemukan".
class ApiException implements Exception {
  final String message;
  final int? statusCode; // null = gagal sebelum dapat respons (offline, timeout)
  final String? body;

  const ApiException(this.message, {this.statusCode, this.body});

  bool get isNotFound => statusCode == 404;

  @override
  String toString() =>
      statusCode == null ? message : '$message (status code: $statusCode)';
}
