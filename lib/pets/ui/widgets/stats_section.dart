import 'package:flutter/material.dart';
import 'package:pets/pets/ui/notifiers/pets_notifiers.dart';
import 'package:pets/pets/domain/adapters/pets.dart';
import 'package:pets/pets/ui/widgets/stat_card.dart';

class StatsSection extends StatelessWidget {
  final PetsNotifier petsNotifier;

  const StatsSection({required this.petsNotifier});

  @override
  Widget build(BuildContext context) {
    if (petsNotifier.isLoading) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (petsNotifier.errorMessage != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.error_outline, color: Colors.red[300], size: 40),
              const SizedBox(height: 8),
              Text(
                'Error al cargar información',
                style: TextStyle(color: Colors.red[600]),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  petsNotifier.clearError();
                  petsNotifier.fetchPets();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final pets = petsNotifier.pets ?? [];
    final totalPets = pets.length;
    final speciesCount = _getSpeciesCount(pets);
    final avgAge = _getAverageAge(pets);

    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Icons.pets,
            title: 'Total Mascotas',
            value: totalPets.toString(),
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            icon: Icons.category,
            title: 'Especies',
            value: speciesCount.toString(),
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            icon: Icons.cake,
            title: 'Edad Promedio',
            value: avgAge,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  int _getSpeciesCount(List<Pets> pets) {
    final species = pets
        .where((pet) => pet.species != null && pet.species!.isNotEmpty)
        .map((pet) => pet.species!.toLowerCase())
        .toSet();
    return species.length;
  }

  String _getAverageAge(List<Pets> pets) {
    final petsWithAge = pets.where((pet) => pet.age != null).toList();
    if (petsWithAge.isEmpty) return '0';
    
    final totalAge = petsWithAge.fold<int>(0, (sum, pet) => sum + pet.age!);
    final average = totalAge / petsWithAge.length;
    return average.toStringAsFixed(1);
  }
}
