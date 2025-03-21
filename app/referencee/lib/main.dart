import 'package:flutter/material.dart';

import 'routing/app_router.dart';

// Example Usage
class ReferenceApp extends StatelessWidget {
  const ReferenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}

void main() => runApp(
      ReferenceApp(),
    );
