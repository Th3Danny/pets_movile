import 'package:pets/auth/domain/adapters/user.dart';
import 'package:pets/diet/domain/adapters/diet.dart';
import 'package:pets/medications/domain/adapters/medications.dart';
import 'package:pets/vaccines/domain/adapters/vaccines.dart';
class Pets {
  final int id;
  final String name;
  final int age;
  final String species;
  final String breed;
  final DateTime birthDate;
  final User owner;
  final Medication? petMedication;
  final Diet? petDiet;
  final Vaccine? petVaccines;

  Pets({
    required this.id,
    required this.name,
    required this.age,
    required this.species,
    required this.breed,
    required this.birthDate,
    required this.owner,
    this.petMedication,
    this.petDiet,
    this.petVaccines,
  });

  factory Pets.fromJson(Map<String, dynamic> json) {
    return Pets(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      species: json['species'],
      breed: json['breed'],
      birthDate: DateTime.parse(json['birthDate']),
      // CORRECCIÓN: Usar User.fromJson para datos del API
      owner: User.fromJson(json['idUser']),
      petMedication: json['petMedication'] != null
          ? Medication.fromJson(json['petMedication'])
          : null,
      petDiet: json['petDiet'] != null
          ? Diet.fromJson(json['petDiet'])
          : null,
      petVaccines: json['petVaccines'] != null
          ? Vaccine.fromJson(json['petVaccines'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
  
      'name': name,
      'age': age,
      'species': species,
      'breed': breed,
      'birthDate': birthDate.toIso8601String(),
      'userId': owner.id,
      // 'petMedication': petMedication?.toJson(),
      // 'petDiet': petDiet?.toJson(),
      // 'petVaccines': petVaccines?.toJson(),
    };
  }

  static List<Pets> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Pets.fromJson(json)).toList();
  }

  @override
  String toString() {
    return 'Pets{id: $id, name: $name, age: $age, species: $species, breed: $breed, birthDate: $birthDate, owner: $owner, petMedication: $petMedication, petDiet: $petDiet, petVaccines: $petVaccines}';
  }

  Pets copyWith({
  int? id,
  String? name,
  int? age,
  String? species,
  String? breed,
  DateTime? birthDate,
  User? owner,
  Medication? petMedication,
  Diet? petDiet,
  Vaccine? petVaccines,
}) {
  return Pets(
    id: id ?? this.id,
    name: name ?? this.name,
    age: age ?? this.age,
    species: species ?? this.species,
    breed: breed ?? this.breed,
    birthDate: birthDate ?? this.birthDate,
    owner: owner ?? this.owner,
    petMedication: petMedication ?? this.petMedication,
    petDiet: petDiet ?? this.petDiet,
    petVaccines: petVaccines ?? this.petVaccines,
  );
}
}


