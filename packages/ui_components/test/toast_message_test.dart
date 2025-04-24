import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  group('ToastMessage', () {
    late BuildContext testContext;

    setUp(() {});

    testWidgets('shows snackbar with correct message', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // Act
      ToastMessage.show(testContext, 'Test Message');
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Message'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
