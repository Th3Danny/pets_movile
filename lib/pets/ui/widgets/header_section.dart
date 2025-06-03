import 'package:flutter/material.dart';
class HeaderSection extends StatelessWidget {
  const HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.pets,
          size: 80,
          color: Colors.blue,
        ),
        const SizedBox(height: 16),
        const Text(
          'Bienvenido a Pets App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Gestiona y cuida tus mascotas',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}