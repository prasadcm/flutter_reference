import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheService extends Mock implements CacheService {}

void main() {
  group('Service Locator Tests', () {
    late GetIt testLocator;
    late MockCacheService mockCacheService;

    setUp(() {
      testLocator = GetIt.instance;
      mockCacheService = MockCacheService();
    });

    tearDown(() {
      testLocator.reset();
    });

    test('registerLazySingleton registers new instance', () {
      const env = AppEnvironment.development;

      CoreServiceLocator.registerLazySingleton<AppEnvironment>(
        testLocator,
        () => env,
      );

      expect(testLocator<AppEnvironment>(), equals(env));
    });

    test('registerLazySingleton replaces existing instance', () {
      const dev = AppEnvironment.development;
      const staging = AppEnvironment.staging;

      CoreServiceLocator.registerLazySingleton<AppEnvironment>(
        testLocator,
        () => dev,
      );
      CoreServiceLocator.registerLazySingleton<AppEnvironment>(
        testLocator,
        () => staging,
      );
      expect(testLocator<AppEnvironment>(), equals(staging));
    });

    test('setup registers all dependencies', () async {
      when(() => mockCacheService.init()).thenAnswer((_) async {});
      await CoreServiceLocator.setup(cacheOverride: mockCacheService);

      expect(testLocator.isRegistered<AppEnvironment>(), isTrue);
      expect(testLocator.isRegistered<CacheService>(), isTrue);
    });

    test('coreLocator throws when accessing unregistered type', () {
      expect(() => coreLocator<UnregisteredType>(), throwsA(isA<Error>()));
    });

    test('multiple calls to setup do not throw', () async {
      when(() => mockCacheService.init()).thenAnswer((_) async {});

      // Should not throw
      await CoreServiceLocator.setup(cacheOverride: mockCacheService);
      await CoreServiceLocator.setup(cacheOverride: mockCacheService);

      expect(testLocator.isRegistered<AppEnvironment>(), isTrue);
      expect(testLocator.isRegistered<CacheService>(), isTrue);
    });
  });
}

// Helper class for testing unregistered type
class UnregisteredType {}
