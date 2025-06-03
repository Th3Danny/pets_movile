import 'package:pets/pets/domain/adapters/pets.dart';

abstract class PetsRepository {
  Future<List<Pets>> getAllPets();
  Future<Pets> getPetById(int id);
  Future<Pets> addPet(Pets pet);
  Future<Pets> updatePet(Pets pet);
  Future<void> deletePet(int id);
}