import 'package:flutter_test/flutter_test.dart';
import 'package:praktikum_api_user_admin/models/admin.dart';
import 'package:praktikum_api_user_admin/models/user.dart';

void main() {
  // Contoh JSON persis seperti bentuk data /users di JSONPlaceholder.
  final jsonUser = <String, dynamic>{
    'id': 1,
    'name': 'Leanne Graham',
    'username': 'Bret',
    'email': 'Sincere@april.biz',
    'address': {'street': 'Kulas Light', 'city': 'Gwenborough'},
    'company': {'name': 'Romaguera-Crona'},
  };

  group('User', () {
    test('fromJson membaca id, name, email, dan address.city', () {
      final u = User.fromJson(jsonUser);
      expect(u.id, 1);
      expect(u.name, 'Leanne Graham');
      expect(u.email, 'Sincere@april.biz');
      expect(u.city, 'Gwenborough');
    });

    test('fromJson tetap aman jika field tidak lengkap (respons PATCH)', () {
      final u = User.fromJson({'id': 1116, 'name': 'Delvino - Flutter Developer'});
      expect(u.id, 1116);
      expect(u.name, 'Delvino - Flutter Developer');
      expect(u.email, '');
      expect(u.city, '');
    });

    test('fromJson menerima city datar dan id berupa String', () {
      final u = User.fromJson({'id': '11', 'name': 'A', 'email': 'a@x.com', 'city': 'Bandung'});
      expect(u.id, 11);
      expect(u.city, 'Bandung');
    });

    test('toJson menghasilkan bentuk JSON yang sesuai API', () {
      const u = User(id: 1116, name: 'Delvino', email: 'd@example.com', city: 'Jakarta');
      expect(u.toJson(), {
        'id': 1116,
        'name': 'Delvino',
        'email': 'd@example.com',
        'address': {'city': 'Jakarta'},
      });
    });

    test('toJson lalu fromJson menghasilkan data yang sama (round trip)', () {
      const u = User(id: 1116, name: 'Delvino', email: 'd@example.com', city: 'Jakarta');
      final back = User.fromJson(u.toJson());
      expect(back.toJson(), u.toJson());
    });

    test('copyWith hanya mengganti field yang diberikan', () {
      const u = User(id: 1, name: 'Lama', email: 'lama@x.com', city: 'Kota');
      final baru = u.copyWith(name: 'Baru', email: 'baru@x.com');
      expect(baru.id, 1);
      expect(baru.name, 'Baru');
      expect(baru.email, 'baru@x.com');
      expect(baru.city, 'Kota');
    });
  });

  group('Admin', () {
    test('fromJson mengambil department dari company.name', () {
      final a = Admin.fromJson(jsonUser);
      expect(a.id, 1);
      expect(a.name, 'Leanne Graham');
      expect(a.email, 'Sincere@april.biz');
      expect(a.department, 'Romaguera-Crona');
    });

    test('fromJson memakai field department jika server mengirimnya', () {
      final a = Admin.fromJson({
        'id': 2116,
        'name': 'Admin 116',
        'email': 'admin116@example.com',
        'department': 'IT',
      });
      expect(a.id, 2116);
      expect(a.department, 'IT');
    });

    test('toJson menghasilkan id, name, email, department', () {
      const a = Admin(id: 2116, name: 'Admin 116', email: 'admin116@example.com', department: 'IT');
      expect(a.toJson(), {
        'id': 2116,
        'name': 'Admin 116',
        'email': 'admin116@example.com',
        'department': 'IT',
      });
      expect(Admin.fromJson(a.toJson()).toJson(), a.toJson());
    });
  });
}
