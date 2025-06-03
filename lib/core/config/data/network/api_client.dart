import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        // Importante para APIs con autenticación
        followRedirects: true,
        validateStatus: (status) => status! < 500,
      ),
    );

    // Configuración de interceptores mejorada
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Log de la petición
        print('Sending request to ${options.uri}');
        print('Headers: ${options.headers}');
        print('Data: ${options.data}');
        
        // Aquí podrías inyectar un token si tienes uno guardado
        // options.headers['Authorization'] = 'Bearer tu_token';
        
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Received response: ${response.statusCode}');
        print('Response data: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('Dio error occurred:');
        print('URL: ${e.requestOptions.uri}');
        print('Method: ${e.requestOptions.method}');
        print('Error: ${e.message}');
        print('Response: ${e.response?.data}');
        print('Status code: ${e.response?.statusCode}');
        
        return handler.next(e);
      },
    ));

    // Agregar logger para ver las peticiones en consola
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }
}