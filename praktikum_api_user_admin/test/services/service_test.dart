import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:praktikum_api_user_admin/config/api_config.dart';
import 'package:praktikum_api_user_admin/models/user.dart';
import 'package:praktikum_api_user_admin/services/admin_service.dart';
import 'package:praktikum_api_user_admin/services/api_exception.dart';
import 'package:praktikum_api_user_admin/services/api_service.dart';

/// MockClient = server palsu di dalam test. Kita yang menentukan respons,
/// jadi test tidak butuh internet dan hasilnya selalu sama.
Map<String, dynamic> userJson(int id) => {
      'id': id,
      'name': 'User $id',
      'email': 'user$id@example.com',
      'address': {'city': 'Kota $id'},
      'company': {'name': 'Company $id'},
    };

void main() {
  const base = '${ApiConfig.baseUrl}${ApiConfig.userPath}';

  group('ApiService (User)', () {
    test('GET /users mengembalikan List<User>', () async {
      final client = MockClient((req) async {
        expect(req.method, 'GET');
        expect(req.url.toString(), base);
        return http.Response(jsonEncode([userJson(1), userJson(2)]), 200);
      });
      final users = await ApiService(client: client).getUsers();
      expect(users.length, 2);
      expect(users.first.name, 'User 1');
      expect(users.last.city, 'Kota 2');
    });

    test('GET /users/1 mengembalikan satu User', () async {
      final client = MockClient((req) async {
        expect(req.url.toString(), '$base/1');
        return http.Response(jsonEncode(userJson(1)), 200);
      });
      final u = await ApiService(client: client).getUser(1);
      expect(u.id, 1);
      expect(u.email, 'user1@example.com');
    });

    test('GET /users/1116 yang tidak ada -> ApiException 404', () async {
      final client = MockClient((req) async => http.Response('{}', 404));
      expect(
        () => ApiService(client: client).getUser(PraktikumIds.userId),
        throwsA(isA<ApiException>()
            .having((e) => e.statusCode, 'statusCode', 404)
            .having((e) => e.isNotFound, 'isNotFound', true)),
      );
    });

    test('POST /users mengirim User id 1116 dan menerima 201', () async {
      final client = MockClient((req) async {
        expect(req.method, 'POST');
        expect(req.url.toString(), base);
        expect(req.headers['Content-Type'], contains('application/json'));
        final sent = jsonDecode(req.body) as Map<String, dynamic>;
        expect(sent['id'], 1116);
        expect(sent['name'], 'Delvino');
        // JSONPlaceholder asli membalas dengan id buatan server (11)
        return http.Response(jsonEncode({...sent, 'id': 11}), 201);
      });
      const user = User(id: 1116, name: 'Delvino', email: 'd@example.com', city: 'Jakarta');
      final r = await ApiService(client: client).createUser(user);
      expect(r.statusCode, 201);
      expect(r.method, 'POST');
      expect(r.data.name, 'Delvino');
      expect(r.data.id, 11);
    });

    test('PUT /users/1116 mengirim data utuh (nama & email baru)', () async {
      final client = MockClient((req) async {
        expect(req.method, 'PUT');
        expect(req.url.toString(), '$base/1116');
        final sent = jsonDecode(req.body) as Map<String, dynamic>;
        expect(sent.keys, containsAll(['id', 'name', 'email', 'address']));
        return http.Response(req.body, 200);
      });
      const user = User(id: 1116, name: 'Nama Baru', email: 'baru@example.com', city: 'Jakarta');
      final r = await ApiService(client: client).updateUser(user);
      expect(r.statusCode, 200);
      expect(r.data.name, 'Nama Baru');
      expect(r.data.email, 'baru@example.com');
    });

    test('PATCH /users/1116 hanya mengirim field name + suffix', () async {
      final client = MockClient((req) async {
        expect(req.method, 'PATCH');
        expect(req.url.toString(), '$base/1116');
        final sent = jsonDecode(req.body) as Map<String, dynamic>;
        expect(sent.keys, ['name']);
        return http.Response(jsonEncode({'id': 1116, ...sent}), 200);
      });
      const newName = 'Delvino${PraktikumIds.patchSuffix}';
      final r = await ApiService(client: client).patchUserName(1116, newName);
      expect(r.statusCode, 200);
      expect(r.data.name, 'Delvino - Flutter Developer');
    });

    test('DELETE /users/1116 sukses dengan 200', () async {
      final client = MockClient((req) async {
        expect(req.method, 'DELETE');
        expect(req.url.toString(), '$base/1116');
        return http.Response('{}', 200);
      });
      final r = await ApiService(client: client).deleteUser(1116);
      expect(r.statusCode, 200);
    });

    test('status 500 dari server -> ApiException', () async {
      final client = MockClient((req) async => http.Response('error', 500));
      expect(() => ApiService(client: client).getUsers(),
          throwsA(isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500)));
    });

    test('gagal koneksi -> ApiException tanpa status code', () async {
      final client = MockClient((req) async => throw http.ClientException('offline'));
      expect(() => ApiService(client: client).getUsers(),
          throwsA(isA<ApiException>().having((e) => e.statusCode, 'statusCode', null)));
    });
  });

  group('AdminService', () {
    const adminBase = '${ApiConfig.baseUrl}${ApiConfig.adminPath}';

    test('getAdmins() mengubah data menjadi List<Admin>', () async {
      final client = MockClient((req) async {
        expect(req.url.toString(), adminBase);
        return http.Response(jsonEncode([userJson(1), userJson(2)]), 200);
      });
      final admins = await AdminService(client: client).getAdmins();
      expect(admins.length, 2);
      expect(admins.first.department, 'Company 1');
    });

    test('getAdmin(1) mengembalikan satu Admin', () async {
      final client = MockClient((req) async {
        expect(req.url.toString(), '$adminBase/1');
        return http.Response(jsonEncode(userJson(1)), 200);
      });
      final a = await AdminService(client: client).getAdmin(1);
      expect(a.id, 1);
      expect(a.name, 'User 1');
    });

    test('getAdmin(2116) yang tidak ada -> ApiException 404', () async {
      final client = MockClient((req) async => http.Response('{}', 404));
      expect(() => AdminService(client: client).getAdmin(PraktikumIds.adminId),
          throwsA(isA<ApiException>().having((e) => e.statusCode, 'statusCode', 404)));
    });

    test('deleteAdmin(2116) mengirim DELETE dan sukses 200', () async {
      final client = MockClient((req) async {
        expect(req.method, 'DELETE');
        expect(req.url.toString(), '$adminBase/2116');
        return http.Response('{}', 200);
      });
      final r = await AdminService(client: client).deleteAdmin(2116);
      expect(r.statusCode, 200);
    });
  });
}
