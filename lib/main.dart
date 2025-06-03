import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pets/auth/ui/notifiers/auth_notifier.dart';
import 'package:pets/pets/ui/notifiers/pets_notifiers.dart';
import 'pets_app.dart';void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthNotifier()), // Proveedor para la autenticación
        ChangeNotifierProvider(create: (_) => PetsNotifier()), // Proveedor para las mascotas
      ],
      child: const PetsApp(), // Tu aplicación ahora tiene acceso a los providers
    ),
  );
}