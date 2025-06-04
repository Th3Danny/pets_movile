import 'package:flutter/material.dart';
import 'package:pets/pets/domain/adapters/pets.dart';

class PetDescriptionWidget extends StatelessWidget {
  final Pets pet;

  const PetDescriptionWidget({
    super.key,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    // Generate a description based on pet data
    String description = _generatePetDescription();
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.description,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Descripción',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _generatePetDescription() {
    return '${pet.name} es un${pet.species.toLowerCase() == 'gato' ? 'a' : ''} ${pet.species.toLowerCase()} '
           'de raza ${pet.breed} de ${pet.age} años de edad. '
           '${_getPersonalityTraits()} '
           '${_getHealthStatus()} '
           'Su propietario es ${pet.owner.name}, quien se encarga de brindarle todo el cuidado y amor que necesita.';
  }

  String _getPersonalityTraits() {
    switch (pet.species.toLowerCase()) {
      case 'perro':
      case 'dog':
        return 'Es una mascota leal y cariñosa que disfruta de la compañía de su familia.';
      case 'gato':
      case 'cat':
        return 'Es una mascota independiente y elegante con personalidad única.';
      default:
        return 'Es una mascota especial con características únicas de su especie.';
    }
  }

  String _getHealthStatus() {
    List<String> healthAspects = [];
    
    if (pet.petMedication != null) {
      healthAspects.add('medicación controlada');
    }
    
    if (pet.petDiet != null) {
      healthAspects.add('dieta especializada');
    }
    
    if (pet.petVaccines != null) {
      healthAspects.add('vacunación al día');
    }
    
    if (healthAspects.isEmpty) {
      return 'Actualmente no tiene asignados planes específicos de salud.';
    } else {
      return 'Cuenta con ${healthAspects.join(', ')}.';
    }
  }
}