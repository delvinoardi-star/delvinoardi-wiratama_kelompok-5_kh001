import 'dart:async';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'api_exception.dart';

/// Menjalankan request HTTP dan mengubah error jaringan menjadi ApiException.
///
/// Contoh: tidak ada internet, server tidak bisa dihubungi, atau timeout.
/// Error karena status code (404, 500, dst.) dicek terpisah di [ensureStatus].
Future<http.Response> sendRequest(Future<http.Response> Function() request) async {
  try {
    return await request().timeout(ApiConfig.timeout);
  } on TimeoutException {
    throw const ApiException('Request timeout: server tidak merespons');
  } on http.ClientException catch (e) {
    throw ApiException('Gagal terhubung ke server: ${e.message}');
  }
}

/// Melempar ApiException jika status code TIDAK termasuk [okCodes].
void ensureStatus(http.Response response, Set<int> okCodes, String errorMessage) {
  if (!okCodes.contains(response.statusCode)) {
    throw ApiException(
      errorMessage,
      statusCode: response.statusCode,
      body: response.body,
    );
  }
}
