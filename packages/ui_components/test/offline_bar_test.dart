import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

void main() {
  group('OfflineBar', () {
    testWidgets('renders all basic components', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                OfflineBar(),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Positioned), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });
  });

  group('positioning tests', () {
    testWidgets('is positioned correctly at the top', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                OfflineBar(),
              ],
            ),
          ),
        ),
      );

      // Assert
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.top, equals(0));
      expect(positioned.left, equals(0));
      expect(positioned.right, equals(0));
    });
  });

  group('styling tests', () {
    testWidgets('container has correct color and padding', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                OfflineBar(),
              ],
            ),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.color, equals(Colors.orange.shade100));
      expect(
        container.padding,
        equals(const EdgeInsets.all(8)),
      );
    });

    testWidgets('icon has correct properties', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                OfflineBar(),
              ],
            ),
          ),
        ),
      );

      // Assert
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, equals(Icons.wifi_off));
      expect(icon.size, equals(20));
    });
  });
}
