import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:ui_components/src/presentation/cached_image_view.dart';

void main() {
  late GetIt testLocator;

  setUp(() {
    testLocator = GetIt.instance;
  });

  Widget buildTestWidget({required String url}) {
    return MaterialApp(
      home: Scaffold(
        body: CachedImageView(
          url: url,
        ),
      ),
    );
  }

  group('CachedImageView', () {
    testWidgets('should show default image when URL is empty',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildTestWidget(url: ''));

      // Assert
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsNothing);

      // Verify the asset path
      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(
        (imageWidget.image as AssetImage).assetName,
        equals('packages/ui_components/assets/placeholder/thumbnail.jpg'),
      );
    });

    testWidgets('should show CachedNetworkImage when URL is not empty',
        (WidgetTester tester) async {
      // Arrange
      const dev = AppEnvironment.development;
      CoreServiceLocator.registerLazySingleton<AppEnvironment>(
        testLocator,
        () => dev,
      );
      const testUrl = 'images/thumbnail.jpg';
      await tester.pumpWidget(buildTestWidget(url: testUrl));

      // Assert
      expect(find.byType(CachedNetworkImage), findsOneWidget);

      // Get the CachedNetworkImage widget and verify its properties
      final imageWidget =
          tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
      expect(
        imageWidget.imageUrl,
        equals('http://localhost:3000/images/thumbnail.jpg'),
      );
      expect(imageWidget.fit, equals(BoxFit.cover));
    });

    testWidgets('should use correct base URL from environment',
        (WidgetTester tester) async {
      // Arrange - Use staging environment
      const staging = AppEnvironment.staging;
      CoreServiceLocator.registerLazySingleton<AppEnvironment>(
        testLocator,
        () => staging,
      );
      const testUrl = 'images/thumbnail.jpg';
      await tester.pumpWidget(
        buildTestWidget(
          url: testUrl,
        ),
      );

      // Assert
      final imageWidget =
          tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
      expect(
        imageWidget.imageUrl,
        equals('https://stage.api.example.com/images/thumbnail.jpg'),
      );
    });
  });
}
