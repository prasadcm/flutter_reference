import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('IconCacheManager', () {
    test('should have correct key', () {
      // Assert
      expect(IconCacheManager.key, equals('IconCache'));
    });

    test('should have correct stale period', () {
      // Assert
      expect(IconCacheManager.stalePeriod, equals(const Duration(days: 30)));
    });

    test('should have correct max objects', () {
      // Assert
      expect(IconCacheManager.maxObjects, equals(500));
    });
  });

  group('ThumbnailImageCacheManager', () {
    test('should have correct key', () {
      // Assert
      expect(ThumbnailImageCacheManager.key, equals('ThumbnailImageCache'));
    });

    test('should have correct stale period', () {
      // Assert
      expect(
        ThumbnailImageCacheManager.stalePeriod,
        equals(const Duration(days: 7)),
      );
    });

    test('should have correct max objects', () {
      // Assert
      expect(ThumbnailImageCacheManager.maxObjects, equals(500));
    });
  });
}
