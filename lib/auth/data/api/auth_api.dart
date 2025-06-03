import 'package:dio/dio.dart';
import 'package:pets/core/config/data/network/api_client.dart';
import 'package:pets/core/config/data/network/api_endpoints.dart';
import 'package:pets/auth/domain/adapters/user.dart';
import 'package:pets/auth/domain/adapters/auth_result.dart';
import 'package:pets/auth/domain/repositories/auth_repository.dart';
import 'package:pets/core/config/helpers/jwt_helper.dart';
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
      final response = await _dio.post(
        ApiEndpoints.users,
        data: {'name': name, 'email': email, 'password': password},
      );

      return _handleAuthResponse(response, _registerError);
    } on DioException catch (e) {
      return _handleDioError(e, _registerError);
    } catch (e) {
      return AuthResult.failure('Error inesperado: ${e.toString()}');
    }
  }

  // Método privado para manejar respuestas exitosas
  AuthResult _handleAuthResponse(Response response, String defaultError) {
  final data = response.data as Map<String, dynamic>;

  if (!(data['success'] as bool? ?? false)) {
    return AuthResult.failure(data['message']?.toString() ?? defaultError);
  }

  final tokenData = data['data'] as Map<String, dynamic>?;
  if (tokenData == null) {
    return AuthResult.failure('No se recibieron tokens de autenticación');
  }

  final accessToken = tokenData['access_token'] as String?;
  if (accessToken == null) {
    return AuthResult.failure('No se recibió access token');
  }

  final userPayload = decodeUserFromToken(accessToken);
  if (userPayload == null) {
    return AuthResult.failure('Error al decodificar los datos del usuario');
  }

  final user = User.fromJwt(userPayload);

  // Aquí podrías guardar el token
  // await TokenStorage.saveAccessToken(accessToken);
  // await TokenStorage.saveRefreshToken(tokenData['refresh_token']);

  return AuthResult.success(user);
}


  // Método privado para manejar errores de Dio
  AuthResult _handleDioError(DioException e, String defaultError) {
    if (e.response != null) {
      final errorMessage = e.response?.data['message'] ?? _serverError;
      return AuthResult.failure(errorMessage);
    } else {
      return AuthResult.failure('$_connectionError: ${e.message}');
    }
  }

  @override
  Future<String?> getCurrentUserEmail() async {
    // Implementación real con TokenStorage
    // return await TokenStorage.getUserEmail();
    return null;
  }

  @override
  Future<bool> isAuthenticated() async {
    // Implementación real con TokenStorage
    // final token = await TokenStorage.getToken();
    // return token != null;
    return false;
  }
}