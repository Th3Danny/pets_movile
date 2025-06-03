import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pets/auth/ui/notifiers/auth_notifier.dart';
import 'pets_app.dart';void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthNotifier()), // ✅ Provee AuthNotifier
        // Añade otros providers aquí si los necesitas
      ],
      child: const PetsApp(), // Tu aplicación ahora tiene acceso a los providers
    ),
  );
}