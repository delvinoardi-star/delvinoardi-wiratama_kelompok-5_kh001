import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/admin.dart';
import 'api_result.dart';
import 'http_helper.dart';

/// AdminService: operasi untuk data Admin (terpisah dari ApiService User).
///
/// Catatan: JSONPlaceholder tidak punya endpoint admin, jadi
/// [ApiConfig.adminPath] = '/users'. Lihat LAPORAN.md bagian "fake API".
class AdminService {
  AdminService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _uri([int? id]) => Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.adminPath}${id == null ? '' : '/$id'}');

  /// GET /users -> daftar Admin.
  Future<List<Admin>> getAdmins() async {
    final res = await sendRequest(() => _client.get(_uri()));
    ensureStatus(res, {200}, 'Gagal mengambil daftar Admin');

    final List<dynamic> list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((item) => Admin.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// GET /users/{id} -> satu Admin berdasarkan ID.
  Future<Admin> getAdmin(int id) async {
    final res = await sendRequest(() => _client.get(_uri(id)));
    ensureStatus(res, {200}, 'Admin dengan ID $id tidak ditemukan');

    return Admin.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// DELETE /users/{id} -> menghapus Admin berdasarkan ID.
  Future<ApiResult<void>> deleteAdmin(int id) async {
    final uri = _uri(id);
    final res = await sendRequest(() => _client.delete(uri));
    ensureStatus(res, {200, 204}, 'Gagal menghapus Admin $id');

    return ApiResult(
      method: 'DELETE',
      url: uri.toString(),
      statusCode: res.statusCode,
      body: res.body,
      data: null,
    );
  }
}
