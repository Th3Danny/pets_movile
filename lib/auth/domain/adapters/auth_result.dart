import 'package:pets/auth/domain/adapters/user.dart';

class AuthResult {
  final User? user;
  final String? error;
  final bool isSuccess;

  const AuthResult({
    this.user,
    this.error,
    required this.isSuccess,
  });

  factory AuthResult.success(User user) {
    return AuthResult(user: user, isSuccess: true);
  }

  factory AuthResult.failure(String error) {
    return AuthResult(error: error, isSuccess: false);
  }
}