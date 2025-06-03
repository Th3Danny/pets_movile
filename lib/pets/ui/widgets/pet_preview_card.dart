import 'package:flutter/material.dart';
import 'package:pets/pets/domain/adapters/pets.dart';
import 'package:pets/core/router/domian/constants/router_constant.dart';
import 'package:go_router/go_router.dart';
class PetPreviewCard extends StatelessWidget {
  final Pets pet;

  const PetPreviewCard({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(
            Icons.pets,
            color: Colors.blue[700],
          ),
        ),
        title: Text(
          pet.name ?? 'Sin nombre',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '${pet.species ?? 'Especie no definida'}${pet.age != null ? ' • ${pet.age} años' : ''}',
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          context.go(RouterConstants.petsList);
        },
      ),
    );
  }
}

