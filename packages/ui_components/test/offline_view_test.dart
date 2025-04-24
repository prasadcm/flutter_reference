import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  group('OfflineView', () {
    testWidgets('renders all basic components', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OfflineView(),
          ),
        ),
      );

      // Assert
      expect(find.byType(Center), findsNWidgets(2));
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(2));
    });

    group('icon tests', () {
      testWidgets('renders wifi_off icon with correct properties',
          (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: OfflineView(),
          ),
        );

        // Assert
        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.icon, equals(Icons.wifi_off));
        expect(icon.size, equals(64));
        expect(icon.color, equals(Colors.grey));
      });
    });

    group('text tests', () {
      testWidgets('renders correct text content', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: OfflineView(),
          ),
        );

        // Assert
        expect(find.text('You are offline!'), findsOneWidget);
        expect(
          find.text('Please check your internet connection'),
          findsOneWidget,
        );
      });

      testWidgets('primary text has correct style', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: OfflineView(),
          ),
        );

        // Assert
        final primaryText = tester.widget<Text>(
          find.text('You are offline!'),
        );
        expect(primaryText.style?.fontSize, equals(20));
        expect(primaryText.style?.fontWeight, equals(FontWeight.bold));
        expect(primaryText.textAlign, equals(TextAlign.center));
      });

      testWidgets('secondary text has correct style', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: OfflineView(),
          ),
        );

        // Assert
        final secondaryText = tester.widget<Text>(
          find.text('Please check your internet connection'),
        );
        expect(secondaryText.style?.fontSize, equals(16));
        expect(secondaryText.style?.color, equals(Colors.black54));
        expect(secondaryText.textAlign, equals(TextAlign.center));
      });
    });

    group('layout tests', () {
      testWidgets('column has correct alignment', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: OfflineView(),
          ),
        );

        // Assert
        final column = tester.widget<Column>(find.byType(Column));
        expect(
          column.mainAxisAlignment,
          equals(MainAxisAlignment.center),
        );
      });

      testWidgets('adapts to different screen sizes', (tester) async {
        // Arrange
        const widget = MaterialApp(
          home: OfflineView(),
        );

        // Test on phone size
        await tester.binding.setSurfaceSize(const Size(400, 800));
        await tester.pumpWidget(widget);
        expect(find.byType(OfflineView), findsOneWidget);

        // Test on tablet size
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(widget);
        expect(find.byType(OfflineView), findsOneWidget);
      });
    });

    group('theme integration', () {
      testWidgets('respects text theme', (tester) async {
        // Arrange
        const textTheme = TextTheme(
          bodyLarge: TextStyle(fontSize: 24), // Different from default
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(textTheme: textTheme),
            home: const OfflineView(),
          ),
        );

        // Assert
        // Note: The widget uses explicit text styles, so theme shouldn't affect it
        final primaryText = tester.widget<Text>(
          find.text('You are offline!'),
        );
        expect(primaryText.style?.fontSize, equals(20));
      });
    });
  });
}
