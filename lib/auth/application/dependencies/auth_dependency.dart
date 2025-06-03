import 'package:pets/auth/data/api/auth_api.dart';
import 'package:pets/auth/domain/use_case/auth_use_case.dart';

// En tu AuthDependencies
class AuthDependencies {
  static AuthUseCase getAuthUseCase() {
    final authRepo = AuthApi();  
    return AuthUseCase(authRepo);
  }
}


