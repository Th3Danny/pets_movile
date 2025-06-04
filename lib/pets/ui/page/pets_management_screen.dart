import 'package:flutter/material.dart';
import 'package:pets/core/router/domian/constants/router_constant.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:pets/pets/ui/notifiers/pets_notifiers.dart';
import 'package:pets/pets/domain/adapters/pets.dart';
import 'package:pets/pets/ui/widgets/pet_management/pet_card.dart';
import 'package:pets/pets/ui/widgets/pet_management/create_form_pet.dart';

class PetsManagementScreen extends StatefulWidget {
  const PetsManagementScreen({super.key});

  @override
  State<PetsManagementScreen> createState() => PetsManagementScreenState();
}

class PetsManagementScreenState extends State<PetsManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetsNotifier>().fetchPets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Mascotas'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouterConstants.home);
            }
          },
        ),
      ),
      body: Consumer<PetsNotifier>(
        builder: (context, petsNotifier, child) {
          if (petsNotifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (petsNotifier.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar mascotas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    petsNotifier.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red.shade500),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => petsNotifier.fetchPets(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final pets = petsNotifier.pets ?? [];

          return RefreshIndicator(
            onRefresh: () => petsNotifier.fetchPets(),
            child:
                pets.isEmpty
                    ? _buildEmptyState(context)
                    : _buildPetsList(context, pets, petsNotifier),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPetDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets_outlined, size: 100, color: Colors.grey.shade400),
            const SizedBox(height: 24),
            Text(
              'No tienes mascotas registradas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Agrega tu primera mascota para comenzar',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showAddPetDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Agregar Primera Mascota'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetsList(
    BuildContext context,
    List<Pets> pets,
    PetsNotifier notifier,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        return PetCard(
          pet: pet,
          onEdit: () => _showEditPetDialog(context, pet),
          onDelete: () => _showDeleteConfirmation(context, pet, notifier),
        );
      },
    );
  }

  void _showAddPetDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => AddEditPetDialog());
  }

  void _showEditPetDialog(BuildContext context, Pets pet) {
    showDialog(
      context: context,
      builder: (context) => AddEditPetDialog(pet: pet),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Pets pet,
    PetsNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar Mascota'),
            content: Text(
              '¿Estás seguro de que quieres eliminar a ${pet.name}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await notifier.deletePet(pet.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${pet.name} ha sido eliminado'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
  }
}
