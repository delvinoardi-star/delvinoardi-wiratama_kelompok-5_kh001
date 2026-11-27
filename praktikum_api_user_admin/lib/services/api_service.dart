import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/user.dart';
import 'api_result.dart';
import 'http_helper.dart';

/// ApiService: semua operasi CRUD untuk data User.
///
/// | Method | Endpoint     | Fungsi              |
/// |--------|--------------|---------------------|
/// | GET    | /users       | getUsers()          |
/// | GET    | /users/{id}  | getUser(id)         |
/// | POST   | /users       | createUser(user)    |
/// | PUT    | /users/{id}  | updateUser(user)    |
/// | PATCH  | /users/{id}  | patchUserName(...)  |
/// | DELETE | /users/{id}  | deleteUser(id)      |
class ApiService {
  /// [client] bisa diganti MockClient saat unit test, sehingga test tidak
  /// perlu internet. Di aplikasi biasa dibiarkan kosong (pakai http.Client()).
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _uri([int? id]) => Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.userPath}${id == null ? '' : '/$id'}');

  // ---------------------------------------------------------------- GET
  /// GET /users -> daftar semua User.
  Future<List<User>> getUsers() async {
    final res = await sendRequest(() => _client.get(_uri()));
    ensureStatus(res, {200}, 'Gagal mengambil daftar User');

    final List<dynamic> list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((item) => User.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// GET /users/{id} -> lengkap dengan status code & body (untuk halaman uji).
  Future<ApiResult<User>> fetchUser(int id) async {
    final uri = _uri(id);
    final res = await sendRequest(() => _client.get(uri));
    ensureStatus(res, {200}, 'User dengan ID $id tidak ditemukan');

    return ApiResult(
      method: 'GET',
      url: uri.toString(),
      statusCode: res.statusCode,
      body: res.body,
      data: User.fromJson(jsonDecode(res.body) as Map<String, dynamic>),
    );
  }

  /// GET /users/{id} -> satu User (dipakai halaman detail).
  Future<User> getUser(int id) async => (await fetchUser(id)).data;

  // --------------------------------------------------------------- POST
  /// POST /users -> menambah User baru. Server membalas 201 Created.
  Future<ApiResult<User>> createUser(User user) async {
    final uri = _uri();
    final res = await sendRequest(() => _client.post(
          uri,
          headers: ApiConfig.jsonHeaders,
          body: jsonEncode(user.toJson()),
        ));
    ensureStatus(res, {200, 201}, 'Gagal menambah User');

    return ApiResult(
      method: 'POST',
      url: uri.toString(),
      statusCode: res.statusCode,
      body: res.body,
      data: User.fromJson(jsonDecode(res.body) as Map<String, dynamic>),
    );
  }

  // ---------------------------------------------------------------- PUT
  /// PUT /users/{id} -> mengganti data User SECARA UTUH (kirim semua field).
  Future<ApiResult<User>> updateUser(User user) async {
    final uri = _uri(user.id);
    final res = await sendRequest(() => _client.put(
          uri,
          headers: ApiConfig.jsonHeaders,
          body: jsonEncode(user.toJson()),
        ));
    ensureStatus(res, {200}, 'Gagal memperbarui User ${user.id} (PUT)');

    return ApiResult(
      method: 'PUT',
      url: uri.toString(),
      statusCode: res.statusCode,
      body: res.body,
      data: User.fromJson(jsonDecode(res.body) as Map<String, dynamic>),
    );
  }

  // -------------------------------------------------------------- PATCH
  /// PATCH /users/{id} -> mengubah SEBAGIAN field saja (di sini hanya `name`).
  Future<ApiResult<User>> patchUserName(int id, String newName) async {
    final uri = _uri(id);
    final res = await sendRequest(() => _client.patch(
          uri,
          headers: ApiConfig.jsonHeaders,
          body: jsonEncode({'name': newName}),
        ));
    ensureStatus(res, {200}, 'Gagal mengubah nama User $id (PATCH)');

    return ApiResult(
      method: 'PATCH',
      url: uri.toString(),
      statusCode: res.statusCode,
      body: res.body,
      data: User.fromJson(jsonDecode(res.body) as Map<String, dynamic>),
    );
  }

  // ------------------------------------------------------------- DELETE
  /// DELETE /users/{id} -> menghapus User. Sukses = 200 atau 204.
  Future<ApiResult<void>> deleteUser(int id) async {
    final uri = _uri(id);
    final res = await sendRequest(() => _client.delete(uri));
    ensureStatus(res, {200, 204}, 'Gagal menghapus User $id');

    return ApiResult(
      method: 'DELETE',
      url: uri.toString(),
      statusCode: res.statusCode,
      body: res.body,
      data: null,
    );
  }
}
