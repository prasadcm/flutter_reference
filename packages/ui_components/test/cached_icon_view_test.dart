import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/src/presentation/cached_icon_view.dart';

void main() {
  setUp(() {});

  Widget buildTestWidget({
    required String iconUrl,
    required IconCategory defaultIcon,
    double size = 48,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: CachedIconView(
          iconUrl: iconUrl,
          defaultIcon: defaultIcon,
          size: size,
        ),
      ),
    );
  }

  group('CachedIconView', () {
    testWidgets('should show default icon when URL is empty',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        buildTestWidget(
          iconUrl: '',
          defaultIcon: IconCategory.search,
        ),
      );

      // Assert
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsNothing);

      // Get the Icon widget and verify its properties
      final iconWidget = tester.widget<Icon>(find.byType(Icon));
      expect(iconWidget.icon, equals(Icons.schedule));
      expect(iconWidget.size, equals(48));
    });

    testWidgets('should show CachedNetworkImage when URL is not empty',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        buildTestWidget(
          iconUrl: 'https://example.com/icon.png',
          defaultIcon: IconCategory.search,
        ),
      );

      // Assert
      expect(find.byType(CachedNetworkImage), findsOneWidget);

      // Get the CachedNetworkImage widget and verify its properties
      final imageWidget =
          tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
      expect(imageWidget.imageUrl, equals('https://example.com/icon.png'));
      expect(imageWidget.width, equals(48));
      expect(imageWidget.height, equals(48));
    });

    testWidgets('should use correct size for both icon and image',
        (WidgetTester tester) async {
      // Arrange - Test with custom size
      const customSize = 64.0;

      // Act - First test with empty URL to get Icon
      await tester.pumpWidget(
        buildTestWidget(
          iconUrl: '',
          defaultIcon: IconCategory.search,
          size: customSize,
        ),
      );

      // Assert - Check Icon size
      final iconWidget = tester.widget<Icon>(find.byType(Icon));
      expect(iconWidget.size, equals(customSize));

      // Act - Now test with URL to get CachedNetworkImage
      await tester.pumpWidget(
        buildTestWidget(
          iconUrl: 'https://example.com/icon.png',
          defaultIcon: IconCategory.search,
          size: customSize,
        ),
      );

      // Assert - Check CachedNetworkImage size
      final imageWidget =
          tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
      expect(imageWidget.width, equals(customSize));
      expect(imageWidget.height, equals(customSize));
    });

    testWidgets('should show error icon for error category',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        buildTestWidget(
          iconUrl: '',
          defaultIcon: IconCategory.error,
        ),
      );

      // Assert
      expect(find.byType(Icon), findsOneWidget);

      // Get the Icon widget and verify its icon data
      final iconWidget = tester.widget<Icon>(find.byType(Icon));
      expect(iconWidget.icon, equals(Icons.error));
    });
  });
}
