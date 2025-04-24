import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  group('LoadingView', () {
    testWidgets('renders CircularProgressIndicator centered on screen',
        (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingView(),
        ),
      );

      // Assert
      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('progress indicator is centered within parent', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox(
            width: 200,
            height: 200,
            child: LoadingView(),
          ),
        ),
      );

      // Assert
      final center = tester.widget<Center>(find.byType(Center));
      expect(center.child, isA<CircularProgressIndicator>());
    });

    testWidgets('uses default progress indicator color from theme',
        (tester) async {
      // Arrange
      const primaryColor = Colors.blue;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            progressIndicatorTheme:
                const ProgressIndicatorThemeData(color: primaryColor),
          ),
          home: const LoadingView(),
        ),
      );

      // Assert
      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(progressIndicator.color, isNull); // Uses theme color
    });
  });
}
