import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:pets/core/config/data/network/api_client.dart';
import 'package:pets/core/config/data/network/api_endpoints.dart';
import 'package:pets/pets/domain/repositories/pets_repositories.dart';
import 'package:pets/pets/domain/adapters/pets.dart';

class PetsApi implements PetsRepository {
  final Dio _dio;

  // Inyectamos Dio para mejor testabilidad
  PetsApi({Dio? dio}) : _dio = dio ?? ApiClient().dio;

  // Mensajes de error como constantes
  static const _fetchError = 'Error al obtener mascotas';
  static const _addError = 'Error al agregar mascota';
  static const _updateError = 'Error al actualizar mascota';
  static const _deleteError = 'Error al eliminar mascota';

  @override
  Future<List<Pets>> getAllPets() async {
    try {
      final response = await _dio.get(ApiEndpoints.pets);
      
      // CORRECCIÓN: Parsear la estructura completa de respuesta
      final Map<String, dynamic> responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> petsJson = responseData['data'];
        return Pets.fromJsonList(petsJson);
      } else {
        throw Exception(responseData['message'] ?? 'Error desconocido');
      }
    } on DioException catch (e) {
      throw Exception(_fetchError + ': ${e.message}');
    } catch (e) {
      throw Exception(_fetchError + ': $e');
    }
  }

  @override
  Future<Pets> getPetById(int id) async {
    try {
      final response = await _dio.get('${ApiEndpoints.pets}/$id');
      
      final Map<String, dynamic> responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        return Pets.fromJson(responseData['data']);
      } else {
        throw Exception(responseData['message'] ?? 'Error desconocido');
      }
    } on DioException catch (e) {
      throw Exception(_fetchError + ': ${e.message}');
    } catch (e) {
      throw Exception(_fetchError + ': $e');
    }
  }

  Future<List<Pets>> getPetByUserId(int userId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.pets, 
        queryParameters: {'userId': userId}
      );
      
      final Map<String, dynamic> responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> petsJson = responseData['data'];
        return Pets.fromJsonList(petsJson);
      } else {
        throw Exception(responseData['message'] ?? 'Error desconocido');
      }
    } on DioException catch (e) {
      throw Exception(_fetchError + ': ${e.message}');
    } catch (e) {
      throw Exception(_fetchError + ': $e');
    }
  }

 @override
Future<Pets> addPet(Pets pet) async {
  try {
    print('Enviando datos: ${pet.toJson()}'); 
    
    final response = await _dio.post(
      ApiEndpoints.pets, 
      data: pet.toJson(),
      options: Options(
        receiveTimeout: const Duration(seconds: 5),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    print('Respuesta recibida - status: ${response.statusCode}');
    print('Respuesta recibida - data: ${response.data}');

    
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data == null || response.data.toString().isEmpty) {
       
        return pet; 
      }

      dynamic responseData = response.data;
      
      
      if (responseData is String) {
        try {
          responseData = jsonDecode(responseData);
        } catch (e) {
       
          if (responseData.contains('{') && responseData.contains('}')) {
            
            return _parsePartialResponse(responseData, pet);
          }
          return pet;
        }
      }

      
      if (responseData is Map<String, dynamic>) {
        if (responseData['data'] != null) {
          return Pets.fromJson(responseData['data']);
        }
        return Pets.fromJson(responseData);
      }

      return pet; 
    } else {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
  } on DioException catch (e) {
    throw Exception('Error al agregar mascota: ${e.response?.data ?? e.message}');
  } catch (e) {
    throw Exception('Error inesperado al agregar mascota: $e');
  }
}

// Método auxiliar para parsear respuestas parciales
Pets _parsePartialResponse(String response, Pets originalPet) {
  try {
    // Intenta extraer campos específicos
    final idMatch = RegExp(r'"id":\s*(\d+)').firstMatch(response);
    final nameMatch = RegExp(r'"name":\s*"([^"]+)"').firstMatch(response);
    
    return originalPet.copyWith(
      id: idMatch != null ? int.parse(idMatch.group(1)!) : originalPet.id,
      name: nameMatch?.group(1) ?? originalPet.name,
    );
  } catch (e) {
    return originalPet;
  }
}

  @override
  Future<Pets> updatePet(Pets pet) async {
    try {
      final response = await _dio.patch(
        '${ApiEndpoints.pets}/${pet.id}',
        data: pet.toJson(),
      );

      final Map<String, dynamic> responseData = response.data;
      
      if (responseData['success'] == true && responseData['data'] != null) {
        return Pets.fromJson(responseData['data']);
      } else {
        throw Exception(responseData['message'] ?? 'Error desconocido');
      }
    } on DioException catch (e) {
      throw Exception(_updateError + ': ${e.message}');
    } catch (e) {
      throw Exception(_updateError + ': $e');
    }
  }

  @override
  Future<void> deletePet(int id) async {
    try {
      final response = await _dio.delete('${ApiEndpoints.pets}/$id');
      
      final Map<String, dynamic> responseData = response.data;
      
      if (responseData['success'] != true) {
        throw Exception(responseData['message'] ?? 'Error al eliminar');
      }
    } on DioException catch (e) {
      throw Exception(_deleteError + ': ${e.message}');
    } catch (e) {
      throw Exception(_deleteError + ': $e');
    }
  }
}