import 'package:flutter/material.dart';
import 'package:pets/pets/domain/adapters/pets.dart';
import 'package:pets/pets/ui/widgets/pet_management/info_chip.dart';


class PetCard extends StatelessWidget {
  final Pets pet;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PetCard({
    required this.pet,
    required this.onEdit,
    required this.onDelete,
  });

  String _getSpeciesIcon(String species) {
    switch (species.toLowerCase()) {
      case 'perro':
        return '🐕';
      case 'gato':
        return '🐱';
      case 'ave':
      case 'pájaro':
        return '🐦';
      case 'pez':
        return '🐠';
      case 'conejo':
        return '🐰';
      default:
        return '🐾';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _getSpeciesIcon(pet.species),
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${pet.breed} • ${pet.age} años',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit();
                        break;
                      case 'delete':
                        onDelete();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Eliminar', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                InfoChip(
                  icon: Icons.cake,
                  label: 'Nació: ${_formatDate(pet.birthDate)}',
                ),
                const SizedBox(width: 8),
                InfoChip(
                  icon: Icons.person,
                  label: 'Dueño: ${pet.owner.name}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}