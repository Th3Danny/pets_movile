import 'package:flutter/material.dart';
import 'core/ui/app_theme.dart';
import 'core/router/ui/view/router_app.dart';

class PetsApp extends StatelessWidget {
  const PetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pets App',
      theme: AppTheme.lightTheme,
      routerConfig: RouterApp.router,
      debugShowCheckedModeBanner: false,
    );
  }
}