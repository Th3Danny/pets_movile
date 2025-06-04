class User {
  final int id;
  final String email;
  final String name;

  const User({
    required this.id,
    required this.email,
    required this.name,
  });

  factory User.fromJwt(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? json['sub']?.toString() ?? 'Usuario',
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, name: $name}';
  }
}
