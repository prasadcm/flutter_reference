import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/network.dart';

class MockDio extends Mock implements Dio {}

class MockApiClient extends Mock implements ApiClient {}

void main() {
  group('Service Locator Tests', () {
    late GetIt testLocator;

    setUp(() {
      testLocator = GetIt.instance;
      GetIt.I.registerSingleton<AppEnvironment>(AppEnvironment.development);
    });

    tearDown(() {
      testLocator.reset();
    });

    test('setup registers all dependencies', () {
      NetworkServiceLocator.setup();

      expect(testLocator.isRegistered<Dio>(), isTrue);
      expect(testLocator.isRegistered<ApiClient>(), isTrue);
    });

    test('registerLazySingleton registers new instance', () {
      final dioInstance = MockDio();
      final apiInstance = MockApiClient();

      NetworkServiceLocator.registerLazySingleton<Dio>(
        testLocator,
        () => dioInstance,
      );

      expect(testLocator<Dio>(), equals(dioInstance));

      NetworkServiceLocator.registerLazySingleton<ApiClient>(
        testLocator,
        () => apiInstance,
      );

      expect(testLocator<ApiClient>(), equals(apiInstance));
    });

    test('coreLocator throws when accessing unregistered type', () {
      expect(() => networkLocator<UnregisteredType>(), throwsA(isA<Error>()));
    });

    test('multiple calls to setup do not throw', () {
      NetworkServiceLocator.setup();
      NetworkServiceLocator.setup();

      expect(testLocator.isRegistered<ApiClient>(), isTrue);
    });
  });
}

// Helper class for testing unregistered type
class UnregisteredType {}
