import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:reference/app.dart';
import 'package:reference/routing/app_router.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  testWidgets('ReferenceApp creates MaterialApp with router config',
      (WidgetTester tester) async {
    // Create a simple GoRouter for testing
    final testRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SizedBox(),
        ),
      ],
    );

    // Replace the app router with our test router
    AppRouter.router = testRouter;

    // Build the app
    await tester.pumpWidget(const ReferenceApp());

    // Find MaterialApp
    final materialApp = tester.widget<MaterialApp>(
      find.byType(MaterialApp),
    );

    // Verify properties
    expect(materialApp.routerConfig, equals(testRouter));
    expect(materialApp.theme, equals(AppThemes.lightTheme));
    expect(materialApp.darkTheme, equals(AppThemes.darkTheme));
  });
}
