import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:referencee/features/categories/screens/categories_screen.dart';
import 'package:referencee/features/profile/widgets/profile_screen.dart';
import 'package:referencee/main.dart';
import 'package:referencee/routing/main_screen.dart';

void main() {
  group('ReferenceApp Tests', () {
    setUp(() {});

    testWidgets('should render ReferenceApp with initial route',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ReferenceApp(),
      );

      // Verify initial route is loaded
      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets('should show Profile page', (WidgetTester tester) async {
      await tester.pumpWidget(
        ReferenceApp(),
      );

      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Verify initial route is loaded
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('should show Categories page', (WidgetTester tester) async {
      await tester.pumpWidget(
        ReferenceApp(),
      );

      await tester.tap(find.byIcon(Icons.category));
      await tester.pumpAndSettle();

      // Verify initial route is loaded
      expect(find.byType(CategoriesScreen), findsOneWidget);
    });
  });
}
