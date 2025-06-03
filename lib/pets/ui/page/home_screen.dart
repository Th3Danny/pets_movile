import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pets/core/router/domian/constants/router_constant.dart';
import 'package:pets/pets/ui/notifiers/pets_notifiers.dart';
import 'package:pets/pets/ui/widgets/header_section.dart';
import 'package:pets/pets/ui/widgets/recent_pets_section.dart';
import 'package:pets/pets/ui/widgets/stats_section.dart';
import 'package:provider/provider.dart';
import 'package:pets/pets/ui/widgets/action_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar las mascotas al inicializar el home
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetsNotifier>().fetchPets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pets App'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.go(RouterConstants.login);
            },
          ),
        ],
      ),
      body: Consumer<PetsNotifier>(
        builder: (context, petsNotifier, child) {
          return RefreshIndicator(
            onRefresh: () => petsNotifier.fetchPets(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header Section
                  const HeaderSection(),
                  const SizedBox(height: 30),
                  
                  // Stats Cards
                  StatsSection(petsNotifier: petsNotifier),
                  const SizedBox(height: 20),
                  
                  // Recent Pets Section
                  RecentPetsSection(petsNotifier: petsNotifier),
                  const SizedBox(height: 30),
                  
                  // Action Button
                  ActionButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}