import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pets/pets/domain/adapters/pets.dart';
import 'package:pets/pets/ui/notifiers/pets_notifiers.dart';
import 'package:pets/core/router/domian/constants/router_constant.dart';
import 'package:pets/pets/ui/widgets/pet_detail/pet_image.dart';
import 'package:pets/pets/ui/widgets/pet_detail/pet_action_buttons.dart';
import 'package:pets/pets/ui/widgets/pet_detail/pet_health_info.dart';
import 'package:pets/pets/ui/widgets/pet_detail/pet_owner_info.dart';
import 'package:pets/pets/ui/widgets/pet_detail/pet_description.dart';
import 'package:pets/pets/ui/widgets/pet_detail/pet_error.dart';
import 'package:pets/pets/ui/widgets/pet_detail/pet_basic_info.dart';

class PetDetailScreen extends StatefulWidget {
  final Pets? pet;
  final int? petId;

  const PetDetailScreen({
    super.key,
    this.pet,
    this.petId,
  });

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  Pets? _currentPet;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializePet();
  }

  void _initializePet() {
    if (widget.pet != null) {
      _currentPet = widget.pet;
    } else if (widget.petId != null) {
      // Usar WidgetsBinding para ejecutar después del build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchPetById(widget.petId!);
      });
    }
  }

  Future<void> _fetchPetById(int id) async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      await context.read<PetsNotifier>().fetchPetById(id);
      
      if (!mounted) return;
      
      final petsNotifier = context.read<PetsNotifier>();
      
      if (petsNotifier.pets != null && petsNotifier.pets!.isNotEmpty) {
        final foundPet = petsNotifier.pets!.firstWhere(
          (pet) => pet.id == id,
          orElse: () => petsNotifier.pets!.first,
        );
        
        setState(() {
          _currentPet = foundPet;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = 'No se encontró la mascota';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _hasError = true;
        _errorMessage = 'Error al cargar los detalles de la mascota: ${e.toString()}';
        _isLoading = false;
      });
      
      _showErrorSnackBar(_errorMessage);
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Reintentar',
          textColor: Colors.white,
          onPressed: () {
            if (widget.petId != null) {
              _fetchPetById(widget.petId!);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(_currentPet?.name ?? 'Detalles de Mascota'),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.go(RouterConstants.home),
      ),
      actions: [
        if (_currentPet != null)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.go(
                RouterConstants.petsManagement,
                extra: _currentPet,
              );
            },
          ),
      ],
    );
  }

  Widget _buildBody() {
    // Estado de carga
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando información de la mascota...'),
          ],
        ),
      );
    }

    // Estado de error
    if (_hasError || _currentPet == null) {
      return PetErrorWidget(
        message: _errorMessage.isNotEmpty 
            ? _errorMessage 
            : 'No se pudo cargar la información de la mascota',
        onRetry: () {
          if (widget.petId != null) {
            _fetchPetById(widget.petId!);
          } else {
            context.go(RouterConstants.home);
          }
        },
      );
    }

    // Estado normal - mostrar detalles
    return RefreshIndicator(
      onRefresh: () async {
        if (widget.petId != null) {
          await _fetchPetById(widget.petId!);
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PetImageWidget(pet: _currentPet!),
            const SizedBox(height: 24),
            
            PetBasicInfoWidget(pet: _currentPet!),
            const SizedBox(height: 24),
            
            PetHealthInfoWidget(pet: _currentPet!),
            const SizedBox(height: 24),
            
            PetOwnerInfoWidget(pet: _currentPet!),
            const SizedBox(height: 24),
            
            PetDescriptionWidget(pet: _currentPet!),
            const SizedBox(height: 32),
            
            PetActionButtonsWidget(
              pet: _currentPet!,
              onEdit: () {
                context.go(
                  RouterConstants.petsManagement,
                  extra: _currentPet,
                );
              },
              onDelete: () => _handleDelete(),
            ),
            
            // Espacio adicional al final
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDelete() async {
    if (_currentPet?.id == null) return;
    
    final confirmed = await _showDeleteConfirmation();
    if (confirmed == true) {
      await _performDelete();
    }
  }

  Future<void> _performDelete() async {
    if (!mounted || _currentPet?.id == null) return;
    
    try {
      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      
      // Realizar eliminación (descomenta cuando esté implementado)
      // await context.read<PetsNotifier>().deletePet(_currentPet!.id!);
      
      // Simular delay para mostrar loading
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) return;
      
      // Cerrar dialog de loading
      Navigator.of(context).pop();
      
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mascota eliminada exitosamente'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Navegar de vuelta al home
      context.go(RouterConstants.home);
      
    } catch (e) {
      if (!mounted) return;
      
      // Cerrar dialog de loading si está abierto
      Navigator.of(context).pop();
      
      _showErrorSnackBar('Error al eliminar la mascota: ${e.toString()}');
    }
  }

  Future<bool?> _showDeleteConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 28,
              ),
              const SizedBox(width: 8),
              const Text('Confirmar eliminación'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Estás seguro de que quieres eliminar a ${_currentPet?.name}?',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Esta acción no se puede deshacer.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Limpiar recursos si es necesario
    super.dispose();
  }
}