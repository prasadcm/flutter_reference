import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  group('InitialView', () {
    testWidgets('renders Center widget', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: InitialView(),
        ),
      );

      // Assert
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('maintains center alignment in different screen sizes',
        (tester) async {
      // Arrange
      const widget = MaterialApp(
        home: InitialView(),
      );

      // Test on phone size
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(widget);
      expect(find.byType(Center), findsOneWidget);

      // Test on tablet size
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(widget);
      expect(find.byType(Center), findsOneWidget);
    });
  });
}
