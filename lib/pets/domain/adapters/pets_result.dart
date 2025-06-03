import 'package:pets/pets/domain/adapters/pets.dart';

class PetsResult {
  final List<Pets>? pets;
  final String? error;
  final bool isSuccess;

  const PetsResult({
    this.pets,
    this.error,
    required this.isSuccess,
  });

  factory PetsResult.success(List<Pets> pets) {
    return PetsResult(pets: pets, isSuccess: true);
  }

  factory PetsResult.failure(String error) {
    return PetsResult(error: error, isSuccess: false);
  }
}