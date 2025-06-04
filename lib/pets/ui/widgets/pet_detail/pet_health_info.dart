import 'package:flutter/material.dart';
import 'package:pets/pets/domain/adapters/pets.dart';

class PetHealthInfoWidget extends StatelessWidget {
  final Pets pet;

  const PetHealthInfoWidget({
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
                  Icons.health_and_safety,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Información de Salud',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Medications
            _buildHealthSection(
              'Medicamentos',
              pet.petMedication?.name ?? 'No asignado',
              pet.petMedication != null,
              Icons.medication,
              Colors.red,
            ),
            const SizedBox(height: 12),
            
            // Diet
            _buildHealthSection(
              'Dieta',
              pet.petDiet?.mealName ?? 'No asignada',
              pet.petDiet != null,
              Icons.restaurant,
              Colors.green,
            ),
            const SizedBox(height: 12),
            
            // Vaccines
            _buildHealthSection(
              'Vacunas',
              pet.petVaccines?.vetName ?? 'No asignadas',
              pet.petVaccines != null,
              Icons.vaccines,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthSection(
    String title,
    String value,
    bool hasValue,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: hasValue ? Colors.black87 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (hasValue)
            Icon(
              Icons.check_circle,
              color: color,
              size: 20,
            )
          else
            Icon(
              Icons.info_outline,
              color: Colors.grey,
              size: 20,
            ),
        ],
      ),
    );
  }
}