import 'package:flutter/material.dart';
import 'package:reference/routing/app_router.dart';
import 'package:ui_components/ui_components.dart';

class ReferenceApp extends StatelessWidget {
  const ReferenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
    );
  }
}
