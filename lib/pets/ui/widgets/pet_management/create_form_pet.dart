import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pets/pets/ui/notifiers/pets_notifiers.dart';
import 'package:pets/pets/domain/adapters/pets.dart';
import 'package:pets/auth/domain/adapters/user.dart';
import 'package:pets/auth/ui/notifiers/auth_notifier.dart';

class AddEditPetDialog extends StatefulWidget {
  final Pets? pet;

  const AddEditPetDialog({this.pet});

  @override
  State<AddEditPetDialog> createState() => AddEditPetDialogState();
}

class AddEditPetDialogState extends State<AddEditPetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _breedController = TextEditingController();

  String _selectedSpecies = 'Gato';
  DateTime _selectedBirthDate = DateTime.now();
  bool _isLoading = false;

  final List<String> _speciesOptions = [
    'Gato',
    'Perro',
    'Ave',
    'Pez',
    'Conejo',
    'Otro',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.pet != null) {
      _nameController.text = widget.pet!.name;
      _ageController.text = widget.pet!.age.toString();
      _breedController.text = widget.pet!.breed;
      _selectedSpecies = widget.pet!.species;
      _selectedBirthDate = widget.pet!.birthDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.pet == null ? 'Agregar Mascota' : 'Editar Mascota',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Nombre
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.pets),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'El nombre es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Especie
                DropdownButtonFormField<String>(
                  value: _selectedSpecies,
                  decoration: const InputDecoration(
                    labelText: 'Especie *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items:
                      _speciesOptions.map((species) {
                        return DropdownMenuItem(
                          value: species,
                          child: Text(species),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSpecies = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Raza
                TextFormField(
                  controller: _breedController,
                  decoration: const InputDecoration(
                    labelText: 'Raza *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.info),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'La raza es requerida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Edad
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Edad (años) *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'La edad es requerida';
                    }
                    final age = int.tryParse(value!);
                    if (age == null || age < 0 || age > 50) {
                      return 'Ingresa una edad válida (0-50)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Fecha de nacimiento
                InkWell(
                  onTap: () => _selectBirthDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.cake),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Fecha de nacimiento',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '${_selectedBirthDate.day}/${_selectedBirthDate.month}/${_selectedBirthDate.year}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _savePet,
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                widget.pet == null ? 'Agregar' : 'Guardar',
                              ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  Future<void> _savePet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final petsNotifier = context.read<PetsNotifier>();

      // Usuario temporal - en una app real, obtendrías esto del contexto de autenticación
      final authNotifier = context.read<AuthNotifier>();
      final currentUser = authNotifier.user;

      if (currentUser == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Debes iniciar sesión para agregar o editar una mascota.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final pet = Pets(
        id: widget.pet?.id ?? 0,
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text),
        species: _selectedSpecies,
        breed: _breedController.text.trim(),
        birthDate: _selectedBirthDate,
        owner: currentUser,
      );

      if (widget.pet == null) {
        await petsNotifier.addPet(pet);
      } else {
        await petsNotifier.updatePet(pet);
      }

      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.pet == null
                  ? '${pet.name} ha sido agregado correctamente'
                  : '${pet.name} ha sido actualizado correctamente',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
