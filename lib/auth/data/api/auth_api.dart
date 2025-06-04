import 'package:dio/dio.dart';
import 'package:pets/core/config/data/network/api_client.dart';
import 'package:pets/core/config/data/network/api_endpoints.dart';
import 'package:pets/auth/domain/adapters/user.dart';
import 'package:pets/auth/domain/adapters/auth_result.dart';
import 'package:pets/auth/domain/repositories/auth_repository.dart';
import 'package:pets/core/config/data/storage/secure_storage.dart';
class AuthApi implements AuthRepository {
  final Dio _dio;

  // Inyectamos Dio para mejor testabilidad
  AuthApi({Dio? dio}) : _dio = dio ?? ApiClient().dio;

  // Mensajes de error como constantes
  static const _loginError = 'Error en el login';
  static const _registerError = 'Error en el registro';
  static const _serverError = 'Error en el servidor';
  static const _connectionError = 'Error de conexión';

  @override
  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.authenticate,
        data: {'email': email, 'password': password},
      );

      return _handleAuthResponse(response, _loginError);
    } on DioException catch (e) {
      return _handleDioError(e, _loginError);
    } catch (e) {
      return AuthResult.failure('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<AuthResult> register(String name, String email, String password) async {
    try {
      // Paso 1: Registrar el usuario
      final registerResponse = await _dio.post(
        '/users', // Tu endpoint de registro
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      
      // Verificar que el registro fue exitoso
      final registerData = registerResponse.data as Map<String, dynamic>;
      if (!(registerData['success'] as bool? ?? false)) {
        return AuthResult.failure(registerData['message']?.toString() ?? _registerError);
      }
      
      print('Usuario registrado exitosamente: ${registerData['message']}');
      
      // Paso 2: Hacer login automático después del registro exitoso
      return await login(email, password);
      
    } on DioException catch (e) {
      return _handleDioError(e, _registerError);
    } catch (e) {
      return AuthResult.failure('Error inesperado: ${e.toString()}');
    }
  }



  // Método para refrescar token
  Future<AuthResult> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/auth/refresh-token',
        data: {'refreshToken': refreshToken},
      );
      
      return _handleAuthResponse(response, 'Error al refrescar token');
    } on DioException catch (e) {
      return _handleDioError(e, 'Error al refrescar token');
    } catch (e) {
      return AuthResult.failure('Error inesperado: ${e.toString()}');
    }
  }

  // Método privado para manejar respuestas exitosas de autenticación
  AuthResult _handleAuthResponse(Response response, String defaultError) {
    final data = response.data as Map<String, dynamic>;
    
    if (!(data['success'] as bool? ?? false)) {
      return AuthResult.failure(data['message']?.toString() ?? defaultError);
    }
    
    final tokenData = data['data'] as Map<String, dynamic>?;
    if (tokenData == null) {
      return AuthResult.failure('No se recibieron datos de autenticación');
    }
    
    final accessToken = tokenData['access_token'] as String?;
    if (accessToken == null) {
      return AuthResult.failure('No se recibió access token');
    }
    
    final refreshToken = tokenData['refresh_token'] as String?;
    final userId = tokenData['id_user']; // Según tu backend
    
    // Decodificar información del usuario del token
    final userPayload = decodeUserFromToken(accessToken);
    if (userPayload == null) {
      return AuthResult.failure('Error al decodificar los datos del usuario');
    }
    
    final user = User.fromJson({
      'id': userId,
      'email': userPayload['email'],
      'name': userPayload['name'] ?? '', // Si el nombre no está en el token
    });
    
    // Guardar tokens de forma segura
    _saveTokensSecurely(accessToken, refreshToken, user.email);
    
    return AuthResult.success(user);
  }

  // Método para guardar tokens de forma segura
  Future<void> _saveTokensSecurely(String accessToken, String? refreshToken, String email) async {
    await SecureStorage.saveToken(accessToken);
    await SecureStorage.saveUserEmail(email);
    
    if (refreshToken != null) {
      await SecureStorage.saveRefreshToken(refreshToken);
    }
  }

  // Método privado para manejar errores de Dio
  AuthResult _handleDioError(DioException e, String defaultError) {
    if (e.response != null) {
      final responseData = e.response?.data;
      
      if (responseData is Map<String, dynamic>) {
        final errorMessage = responseData['message'] ?? defaultError;
        return AuthResult.failure(errorMessage.toString());
      } else {
        return AuthResult.failure('$_serverError: ${e.response?.statusCode}');
      }
    } else {
      return AuthResult.failure('$_connectionError: ${e.message}');
    }
  }

  // // Método para decodificar usuario del JWT
  // Map<String, dynamic>? decodeUserFromToken(String token) {
  //   try {
  //     // Aquí debes implementar la decodificación del JWT
  //     // Puedes usar la librería dart_jsonwebtoken o jwt_decode
      
  //     // Por ahora, un ejemplo básico (implementa según tu necesidad):
  //     final parts = token.split('.');
  //     if (parts.length != 3) return null;
      
  //     final payload = parts[1];
  //     // Decodificar base64 y parsear JSON
  //     // Esto es un ejemplo simplificado
      
  //     return {
  //       'id': 1, // Extraer del token
  //       'email': 'user@example.com', // Extraer del token
  //       'name': 'Usuario', // Si está disponible en el token
  //     };
  //   } catch (e) {
  //     print('Error decodificando token: $e');
  //     return null;
  //   }
  // }

  @override
  Future<String?> getCurrentUserEmail() async {
    return await SecureStorage.getUserEmail();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await SecureStorage.getToken();
    if (token == null) return false;
    
    // Aquí podrías validar si el token no ha expirado
    // Por ahora, solo verificamos que existe
    return true;
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    await SecureStorage.clearAll();
  }
}
