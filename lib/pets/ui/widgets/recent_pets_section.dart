import 'package:flutter/material.dart';
import 'package:pets/pets/ui/notifiers/pets_notifiers.dart';
import 'package:pets/core/router/domian/constants/router_constant.dart';
import 'package:go_router/go_router.dart';
import 'package:pets/pets/ui/widgets/pet_preview_card.dart';
class RecentPetsSection extends StatelessWidget {
  final PetsNotifier petsNotifier;

  const RecentPetsSection({required this.petsNotifier});

  @override
  Widget build(BuildContext context) {
    if (petsNotifier.isLoading || petsNotifier.errorMessage != null) {
      return const SizedBox.shrink();
    }

    final pets = petsNotifier.pets ?? [];
    
    if (pets.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.pets,
                size: 60,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 12),
              Text(
                'No tienes mascotas registradas',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Comienza agregando tu primera mascota',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Mostrar hasta las 3 mascotas más recientes (o todas si son menos de 3)
    final recentPets = pets.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tus Mascotas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (pets.length > 3)
              TextButton(
                onPressed: () {
                  context.go(RouterConstants.petsList);
                },
                child: const Text('Ver todas'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...recentPets.map((pet) => PetPreviewCard(pet: pet)).toList(),
      ],
    );
  }
}