import 'package:flutter/material.dart';
import 'package:pets/pets/domain/adapters/pets.dart';
import 'package:intl/intl.dart';

class PetBasicInfoWidget extends StatelessWidget {
  final Pets pet;

  const PetBasicInfoWidget({
    super.key,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
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
                  Icons.info_outline,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Información Básica',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Nombre', pet.name, Icons.pets),
            const SizedBox(height: 12),
            _buildInfoRow('Edad', '${pet.age} años', Icons.cake),
            const SizedBox(height: 12),
            _buildInfoRow('Especie', pet.species, Icons.category),
            const SizedBox(height: 12),
            _buildInfoRow('Raza', pet.breed, Icons.fingerprint),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Fecha de Nacimiento', 
              DateFormat('dd/MM/yyyy').format(pet.birthDate),
              Icons.calendar_today,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
