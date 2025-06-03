import 'package:pets/pets/domain/adapters/pets.dart';
import 'package:pets/pets/domain/repositories/pets_repositories.dart';
import 'package:pets/pets/domain/adapters/pets_result.dart';

class GetPetsUseCase {
  final PetsRepository repository;

  GetPetsUseCase(this.repository);

  Future<PetsResult> getAllPets() async {
    try {
      List<Pets> pets = await repository.getAllPets();
      return PetsResult.success(pets);
    } catch (e) {
      return PetsResult.failure(e.toString());
    }
  }

  Future<PetsResult> getPetByUserId(int userId) async {
    try {
      List<Pets> pets = await repository.getAllPets();
      List<Pets> userPets = pets.where((pet) => pet.owner.id == userId).toList();
      return PetsResult.success(userPets);
    } catch (e) {
      return PetsResult.failure(e.toString());
    }
  }

  Future<PetsResult> getPetById(int id) async {
    try {
      Pets pet = await repository.getPetById(id);
      return PetsResult.success([pet]);
    } catch (e) {
      return PetsResult.failure(e.toString());
    }
  }

  Future<PetsResult> addPet(Pets pet) async {
    try {
      Pets newPet = await repository.addPet(pet);
      return PetsResult.success([newPet]);
    } catch (e) {
      return PetsResult.failure(e.toString());
    }
  }

  Future<PetsResult> updatePet(Pets pet) async {
    try {
      Pets updatedPet = await repository.updatePet(pet);
      return PetsResult.success([updatedPet]);
    } catch (e) {
      return PetsResult.failure(e.toString());
    }
  }
  Future<PetsResult> deletePet(int id) async {
    try {
      await repository.deletePet(id);
      return PetsResult.success([]);
    } catch (e) {
      return PetsResult.failure(e.toString());
    }
  }

}