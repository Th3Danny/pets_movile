import 'package:flutter/material.dart';
import 'package:pets/pets/domain/adapters/pets.dart';
import 'package:pets/pets/domain/use_case/get_pets.dart';
import 'package:pets/pets/application/dependencies/pets_dependencies.dart';

class PetsNotifier extends ChangeNotifier {
  final GetPetsUseCase _getPetsUseCase = PetsDependencies.getGetPetsUseCase();

  bool _isLoading = false;
  String? _errorMessage;
  List<Pets>? _pets;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Pets>? get pets => _pets;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

 Future<void> fetchPets() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _getPetsUseCase.getAllPets(); // <- corregido

      if (result.isSuccess && result.pets != null) {
        _pets = result.pets;
      } else {
        _errorMessage = result.error ?? 'Ocurrió un error desconocido';
      }
    } catch (e) {
      _errorMessage = 'Error inesperado: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> fetchPetsByUserId(int userId) async {
    _setLoading(true);
    clearError();

    final result = await _getPetsUseCase.getPetByUserId(userId);

    _setLoading(false);

    if (result.isSuccess) {
      _pets = result.pets;
      notifyListeners();
    } else {
      _errorMessage = result.error ?? "Error desconocido";
      notifyListeners();
    }
  }

  Future<void> fetchPetById(int id) async {
    _setLoading(true);
    clearError();

    final result = await _getPetsUseCase.getPetById(id);

    _setLoading(false);

    if (result.isSuccess) {
      _pets = result.pets;
      notifyListeners();
    } else {
      _errorMessage = result.error ?? "Error desconocido";
      notifyListeners();
    }
  }

  Future<void> addPet(Pets pet) async {
    _setLoading(true);
    clearError();

    final result = await _getPetsUseCase.addPet(pet);

    _setLoading(false);

    if (result.isSuccess) {
      _pets?.addAll(result.pets ?? []);
      notifyListeners();
    } else {
      _errorMessage = result.error ?? "Error desconocido";
      notifyListeners();
    }
  }

  Future<void> updatePet(Pets pet) async {
    _setLoading(true);
    clearError();

    final result = await _getPetsUseCase.updatePet(pet);

    _setLoading(false);

    if (result.isSuccess) {
      final index = _pets?.indexWhere((p) => p.id == pet.id);
      if (index != null && index >= 0) {
        _pets?[index] = result.pets?.first ?? pet;
      }
      notifyListeners();
    } else {
      _errorMessage = result.error ?? "Error desconocido";
      notifyListeners();
    }
  }

  Future<void> deletePet(int id) async {
    _setLoading(true);
    clearError();

    final result = await _getPetsUseCase.deletePet(id);

    _setLoading(false);

    if (result.isSuccess) {
      _pets?.removeWhere((pet) => pet.id == id);
      notifyListeners();
    } else {
      _errorMessage = result.error ?? "Error desconocido";
      notifyListeners();
    }
  }
}
