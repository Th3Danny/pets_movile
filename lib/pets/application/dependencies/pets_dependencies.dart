import 'package:pets/pets/data/api/pets_api.dart';
import 'package:pets/pets/domain/use_case/get_pets.dart';
//import 'package:pets/pets/domain/use_case/add_pet.dart';
//import 'package:pets/pets/domain/use_case/update_pet.dart'; 
//import 'package:pets/pets/domain/use_case/delete_pet.dart';

class PetsDependencies {
  static GetPetsUseCase getGetPetsUseCase() {
    final petsApi = PetsApi();
    return GetPetsUseCase(petsApi);
  }

  // ...
}
