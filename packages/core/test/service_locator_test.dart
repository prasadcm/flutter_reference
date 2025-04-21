import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  group('Service Locator Tests', () {
    late GetIt testLocator;

    setUp(() {
      testLocator = GetIt.instance;
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

    test('setup registers all dependencies', () {
      CoreServiceLocator.setup();

      expect(testLocator.isRegistered<AppEnvironment>(), isTrue);
    });

    test('coreLocator throws when accessing unregistered type', () {
      expect(() => coreLocator<UnregisteredType>(), throwsA(isA<Error>()));
    });

    test('multiple calls to setup do not throw', () {
      // Should not throw
      CoreServiceLocator.setup();
      CoreServiceLocator.setup();

      expect(testLocator.isRegistered<AppEnvironment>(), isTrue);
    });
  });
}

// Helper class for testing unregistered type
class UnregisteredType {}
