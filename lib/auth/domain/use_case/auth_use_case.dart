import 'package:pets/auth/domain/repositories/auth_repository.dart';
import 'package:pets/auth/domain/adapters/auth_result.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<AuthResult> login(String email, String password) async {
    try {
      AuthResult result = await repository.login(email, password);
      if (result.isSuccess) {
        return result;
      } else {
        return AuthResult.failure(result.error ?? "Error al iniciar sesión");
      }
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  Future<AuthResult> register(String name, String email, String password) async {
    try {
      AuthResult result = await repository.register(name, email, password);
      if (result.isSuccess) {
        return result;
      } else {
        return AuthResult.failure(result.error ?? "Error al registrarse");
      }
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  // Future<void> logout() async {
  //   await repository.logout();
  // }

  Future<bool> isAuthenticated() async {
    return await repository.isAuthenticated();
  }
}



  