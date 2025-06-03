class User {
  final String id;
  final String email;
  final String name;

  const User({
    required this.id,
    required this.email,
    required this.name,
  });

  // Para JWT (como lo tenías)
  factory User.fromJwt(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? json['sub']?.toString() ?? 'Usuario',
    );
  }

  // NUEVO: Para datos que vienen del API (como en tu JSON de respuesta)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  // Para convertir a JSON al enviar datos
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