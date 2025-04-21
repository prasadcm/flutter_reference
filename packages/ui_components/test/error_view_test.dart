import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  group('ErrorView', () {
    testWidgets('renders with required title only', (tester) async {
      const title = 'Error Title';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(title: title),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('renders with title and subtitle', (tester) async {
      // Arrange
      const title = 'Error Title';
      const subtitle = 'Error Subtitle';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(
              title: title,
              subtitle: subtitle,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('does not render subtitle when empty', (tester) async {
      // Arrange
      const title = 'Error Title';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(
              title: title,
            ),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(
        find.byType(Text),
        findsOneWidget,
      );
    });

    testWidgets('applies correct text styles', (tester) async {
      // Arrange
      const title = 'Error Title';
      const subtitle = 'Error Subtitle';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(),
          home: const Scaffold(
            body: ErrorView(
              title: title,
              subtitle: subtitle,
            ),
          ),
        ),
      );

      // Assert
      final titleWidget = tester.widget<Text>(
        find.text(title),
      );
      final subtitleWidget = tester.widget<Text>(
        find.text(subtitle),
      );

      expect(titleWidget.style?.fontWeight, equals(FontWeight.bold));
      expect(titleWidget.style?.color, equals(Colors.black87));
      expect(subtitleWidget.style?.color, equals(Colors.black54));
    });

    testWidgets('centers content vertically and horizontally', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(title: 'Error'),
          ),
        ),
      );

      expect(find.byType(Center), findsAtLeast(1));
      final column = tester.widget<Column>(find.byType(Column));
      expect(
        column.mainAxisAlignment,
        equals(MainAxisAlignment.center),
      );
    });

    testWidgets('icon has correct size and color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(title: 'Error'),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, equals(64));
      expect(icon.color, equals(Colors.grey));
    });

    testWidgets('text alignment is centered', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(
              title: 'Error',
              subtitle: 'Subtitle',
            ),
          ),
        ),
      );

      final titleText = tester.widget<Text>(
        find.text('Error'),
      );
      final subtitleText = tester.widget<Text>(
        find.text('Subtitle'),
      );

      expect(titleText.textAlign, equals(TextAlign.center));
      expect(subtitleText.textAlign, equals(TextAlign.center));
    });

    testWidgets('handles long text properly', (tester) async {
      // Arrange
      const longTitle =
          'Very long error title that might wrap to multiple lines';
      const longSubtitle = 'This is a very long subtitle text that should wrap '
          'properly and not overflow the screen width';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(
              title: longTitle,
              subtitle: longSubtitle,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(longTitle), findsOneWidget);
      expect(find.text(longSubtitle), findsOneWidget);
    });

    testWidgets('respects theme text styles', (tester) async {
      // Arrange
      final testTheme = ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: testTheme,
          home: const Scaffold(
            body: ErrorView(
              title: 'Error',
              subtitle: 'Subtitle',
            ),
          ),
        ),
      );

      // Assert
      final titleText = tester.widget<Text>(find.text('Error'));
      final subtitleText = tester.widget<Text>(find.text('Subtitle'));

      expect(titleText.style?.fontSize, equals(24));
      expect(subtitleText.style?.fontSize, equals(16));
    });

    group('accessibility', () {
      testWidgets('has sufficient contrast ratio', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ErrorView(
                title: 'Error',
                subtitle: 'Subtitle',
              ),
            ),
          ),
        );

        // Assert
        final titleText = tester.widget<Text>(find.text('Error'));
        final subtitleText = tester.widget<Text>(find.text('Subtitle'));

        expect(titleText.style?.color, equals(Colors.black87));
        expect(subtitleText.style?.color, equals(Colors.black54));
      });
    });

    group('layout tests', () {
      testWidgets('maintains proper spacing', (tester) async {
        // Act
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ErrorView(
                title: 'Error',
                subtitle: 'Subtitle',
              ),
            ),
          ),
        );

        // Assert
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes.first.height, equals(64));
        expect(sizedBoxes.last.height, equals(8));
      });

      testWidgets('adapts to different screen sizes', (tester) async {
        // Arrange
        const widget = MaterialApp(
          home: Scaffold(
            body: ErrorView(
              title: 'Error',
              subtitle: 'Subtitle',
            ),
          ),
        );

        // Test on phone size
        await tester.binding.setSurfaceSize(const Size(400, 800));
        await tester.pumpWidget(widget);
        expect(find.byType(ErrorView), findsOneWidget);

        // Test on tablet size
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(widget);
        expect(find.byType(ErrorView), findsOneWidget);
      });
    });
  });
}
