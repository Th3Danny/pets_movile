
import 'package:pets/auth/domain/adapters/auth_result.dart';

abstract class AuthRepository {
  Future<AuthResult> login(String email, String password);
  Future<AuthResult> register(String name, String email, String password);
 // Future<void> logout();
  Future<String?> getCurrentUserEmail();
  Future<bool> isAuthenticated();
} 