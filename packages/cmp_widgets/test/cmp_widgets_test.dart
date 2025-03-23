import 'package:cmp_widgets/cmp_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReferenceApp Tests', () {
    late int selectedTab;

    void onTabSelected(int index) {
      selectedTab = index;
    }

    setUp(() {
      selectedTab = 0;
    });
    testWidgets('should render CMPTabbarWidget with initial selected tab',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: CMPTabbarWidget(
                onTabSelected: onTabSelected, selectedTabIndex: 0),
          ),
        ),
      );

      // Verify the widget is rendered
      expect(find.byType(CMPTabbarWidget), findsOneWidget);

      // Verify initial tab is selected
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(selectedTab, equals(0));
    });

    testWidgets('should change selected tab when tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: CMPTabbarWidget(
              onTabSelected: onTabSelected,
              selectedTabIndex: 0,
            ),
          ),
        ),
      );

      // Tap on the second tab
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Verify the second tab is selected
      expect(selectedTab, equals(1));
    });
  });
}
