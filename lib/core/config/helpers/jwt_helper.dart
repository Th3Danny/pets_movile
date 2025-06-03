import 'package:jwt_decode/jwt_decode.dart';

Map<String, dynamic>? decodeUserFromToken(String token) {
  try {
    return Jwt.parseJwt(token);
  } catch (e) {
    print('Error al decodificar el token: $e');
    return null;
  }
}