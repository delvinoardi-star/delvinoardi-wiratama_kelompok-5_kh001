/// Model data Admin: id, name, email, department.
///
/// Karena JSONPlaceholder tidak punya data admin, `department` diambil dari
/// `company.name` pada data /users. Jika server lain mengirim field
/// `department` langsung, field itu yang dipakai lebih dulu.
class Admin {
  final int id;
  final String name;
  final String email;
  final String department;

  const Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    final company = json['company'];
    final String department = json['department'] != null
        ? json['department'].toString()
        : (company is Map && company['name'] != null)
            ? company['name'].toString()
            : '';

    final rawId = json['id'];
    return Admin(
      id: rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '') ?? 0,
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      department: department,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'department': department,
      };

  @override
  String toString() =>
      'Admin(id: $id, name: $name, email: $email, department: $department)';
}
