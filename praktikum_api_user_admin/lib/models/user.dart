/// Model data User: id, name, email, city.
///
/// Di JSONPlaceholder, `city` tidak ada di level atas, tetapi berada di
/// dalam objek `address`:  { "address": { "city": "Gwenborough" } }
class User {
  final int id;
  final String name;
  final String email;
  final String city;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.city,
  });

  /// Mengubah Map hasil jsonDecode menjadi objek User.
  ///
  /// Dibuat "toleran": jika suatu field tidak ada (misal respons PATCH yang
  /// hanya berisi `name`), nilainya diisi default agar aplikasi tidak crash.
  factory User.fromJson(Map<String, dynamic> json) {
    final address = json['address'];
    final String city = (address is Map && address['city'] != null)
        ? address['city'].toString()
        : (json['city'] ?? '').toString(); // cadangan bila API memakai field datar

    return User(
      id: _toInt(json['id']),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      city: city,
    );
  }

  /// Mengubah objek User menjadi Map agar bisa di-jsonEncode lalu dikirim
  /// sebagai body POST/PUT. Bentuknya mengikuti struktur JSONPlaceholder.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'address': {'city': city},
      };

  /// Membuat salinan User dengan beberapa field diganti (dipakai untuk PUT).
  User copyWith({int? id, String? name, String? email, String? city}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      city: city ?? this.city,
    );
  }

  @override
  String toString() => 'User(id: $id, name: $name, email: $email, city: $city)';
}

/// id dari server kadang int, kadang String (mis. "11"). Disamakan jadi int.
int _toInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
