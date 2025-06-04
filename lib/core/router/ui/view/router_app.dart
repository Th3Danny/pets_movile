import 'package:go_router/go_router.dart';
import '../../domian/constants/router_constant.dart';
import 'package:flutter/material.dart';
import 'package:pets/auth/ui/page/login_screen.dart';
import 'package:pets/auth/ui/page/register_screen.dart';
import 'package:pets/pets/ui/page/home_screen.dart';
import 'package:pets/pets/ui/page/pets_management_screen.dart';
//import 'package:pets/pets/ui/page/pets_list_screen.dart';
//import '../../../../screens/pets_list_screen.dart';
//import '../../../../screens/pet_detail_screen.dart';
//import '../../../../models/pet.dart';

class RouterApp {
  static final router = GoRouter(
    initialLocation: RouterConstants.login,
    routes: [
      // Ruta de Login
      GoRoute(
        path: RouterConstants.login,
        builder: (ctx, state) => const LoginScreen(),
      ),
      
      // Ruta de Register
      GoRoute(
        path: RouterConstants.register,
        builder: (ctx, state) => const RegisterScreen(),
      ),
      
      // Ruta principal - Home
      GoRoute(
        path: RouterConstants.home,
        builder: (ctx, state) => const HomeScreen(),
      ),

      // Ruta de gestión de mascotas
      GoRoute(
        path: RouterConstants.petsManagement,
        builder: (ctx, state) => const PetsManagementScreen(),
      ),
      
      // Ruta de lista de mascotas
      // GoRoute(
      //   path: RouterConstants.petsList,
      //   builder: (ctx, state) => const PetsListScreen(),
      // ),
      
      // Ruta de detalle de mascota con parámetro ID
      // GoRoute(
      //   path: "${RouterConstants.petDetail}/:id",
      //   builder: (context, state) {
      //     final id = state.pathParameters['id'] ?? '';
      //     final pet = state.extra as Pet?;
      //     return PetDetailScreen(
      //       pet: pet,
      //       petId: int.tryParse(id),
      //     );
      //   },
      // ),
    ],
    
    // Manejo de errores de navegación
    errorBuilder: (context, state) => ErrorScreen(
      error: state.error.toString(),
    ),
  );
}

// Pantalla de error personalizada
class ErrorScreen extends StatelessWidget {
  final String error;
  
  const ErrorScreen({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Ups! Algo salió mal',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}

// Extensión para navegación fácil
extension RouterExtension on GoRouter {
  // Navegar a home
  void goHome() => go('/');
  
  // Navegar a lista de mascotas
  void goPetsList() => go('/pets');

  // Navegar a gestión de mascotas
  void goPetsManagement() => go(RouterConstants.petsManagement);
  
  // Navegar a detalle de mascota
  //void goPetDetail(Pet pet) => go('/pet-detail', extra: pet);
}