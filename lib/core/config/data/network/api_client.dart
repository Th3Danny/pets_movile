import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_endpoints.dart';

class ApiClient {
  // Singleton pattern
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  late final Dio dio;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // No incluyas el Bearer aquí, se añadirá dinámicamente
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Interceptor para manejar tokens de forma dinámica
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Obtener token de tu almacenamiento seguro (ej: SecureStorage)
        final token = await _getAuthToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        if (kDebugMode) {
          debugPrint('🌎 [${options.method}] ${options.uri}');
          debugPrint('📦 Body: ${options.data}');
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (kDebugMode) {
          debugPrint('🔥 Error [${error.response?.statusCode}] ${error.requestOptions.uri}');
          debugPrint('📌 Message: ${error.message}');
        }

        // Manejo de errores 401 (No autorizado)
        if (error.response?.statusCode == 401) {
          // Puedes implementar un refresh token aquí
          return handler.reject(error);
        }

        return handler.next(error);
      },
    ));

    // Solo en desarrollo: Logger detallado
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (object) => debugPrint(object.toString()),
      ));
    }
  }

  Future<String?> _getAuthToken() async {
    // Implementa la lógica para obtener el token de tu almacenamiento
    // Ejemplo: return await SecureStorage().read('auth_token');
    return null;
  }

  // Método helper para manejar errores
  static dynamic handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data;
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Error ${response.statusCode}: ${response.statusMessage}',
      );
    }
  }
}