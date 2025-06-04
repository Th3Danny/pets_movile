import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pets/core/router/domian/constants/router_constant.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // Navegar a la pantalla de gestión de mascotas
          context.push(RouterConstants.petsManagement);
          
        },
        icon: const Icon(Icons.pets),
        label: const Text('Gestionar tus Mascotas'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}