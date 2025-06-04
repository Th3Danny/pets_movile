import 'package:flutter/material.dart';
import 'package:pets/pets/domain/adapters/pets.dart';

class PetImageWidget extends StatelessWidget {
  final Pets pet;

  const PetImageWidget({
    super.key,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Placeholder image - you can replace with actual pet image
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[300],
              child: Icon(
                _getSpeciesIcon(pet.species),
                size: 80,
                color: Colors.grey[600],
              ),
            ),
            // Pet name overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Text(
                  pet.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSpeciesIcon(String species) {
    switch (species.toLowerCase()) {
      case 'perro':
      case 'dog':
        return Icons.pets;
      case 'gato':
      case 'cat':
        return Icons.pets;
      case 'ave':
      case 'bird':
        return Icons.flutter_dash;
      default:
        return Icons.pets;
    }
  }
}
