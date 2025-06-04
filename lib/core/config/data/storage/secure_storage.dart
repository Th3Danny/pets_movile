import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    // iOptions: IOSOptions(
    //   accessibility: IOSAccessibility.first_unlock_this_device,
    // ),
  );
  
  // Claves para almacenamiento
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userEmailKey = 'user_email';
  static const String _userIdKey = 'user_id';
  
  // Métodos para tokens
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }
  
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
  
  static Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }
  
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }
  
  // Métodos para información del usuario
  static Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _userEmailKey, value: email);
  }
  
  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }
  
  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }
  
  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }
  
  // Métodos para limpiar datos
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
  
  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }
  
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
  
  // Método para verificar si hay datos almacenados
  static Future<bool> hasStoredCredentials() async {
    final token = await getToken();
    final email = await getUserEmail();
    return token != null && email != null;
  }
}