import 'package:categories/categories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/network.dart';

// Create mocks
class MockApiClient extends Mock implements ApiClient {}

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

class MockCategoriesBloc extends Mock implements CategoriesBloc {}

void main() {
  group('Service Locator Tests', () {
    late GetIt testLocator;
    late MockApiClient mockApiClient;

    setUp(() {
      testLocator = GetIt.instance;
      mockApiClient = MockApiClient();

      GetIt.I.registerSingleton<ApiClient>(mockApiClient);
    });

    tearDown(() {
      testLocator.reset();
    });

    test('registerLazySingleton registers new instance', () {
      final testInstance = MockCategoriesRepository();

      CategoryServiceLocator.registerLazySingleton<CategoriesRepository>(
        testLocator,
        () => testInstance,
      );

      expect(testLocator<CategoriesRepository>(), equals(testInstance));
    });

    test('registerLazySingleton replaces existing instance', () {
      final firstInstance = MockCategoriesRepository();
      final secondInstance = MockCategoriesRepository();

      CategoryServiceLocator.registerLazySingleton<CategoriesRepository>(
        testLocator,
        () => firstInstance,
      );
      CategoryServiceLocator.registerLazySingleton<CategoriesRepository>(
        testLocator,
        () => secondInstance,
      );

      expect(testLocator<CategoriesRepository>(), equals(secondInstance));
    });

    test('registerCachedFactory registers new instance', () {
      final testBloc = MockCategoriesBloc();

      CategoryServiceLocator.registerCachedFactory<CategoriesBloc>(
        testLocator,
        () => testBloc,
      );

      expect(testLocator<CategoriesBloc>(), equals(testBloc));
    });

    test('registerCachedFactory replaces existing instance', () {
      final firstBloc = MockCategoriesBloc();
      final secondBloc = MockCategoriesBloc();

      CategoryServiceLocator.registerCachedFactory<CategoriesBloc>(
        testLocator,
        () => firstBloc,
      );
      CategoryServiceLocator.registerCachedFactory<CategoriesBloc>(
        testLocator,
        () => secondBloc,
      );

      expect(testLocator<CategoriesBloc>(), equals(secondBloc));
    });

    test('setup registers all dependencies', () {
      CategoryServiceLocator.setup();

      expect(testLocator.isRegistered<CategoriesRepository>(), isTrue);
      expect(testLocator.isRegistered<CategoriesBloc>(), isTrue);
    });

    test('categoryLocator throws when accessing unregistered type', () {
      expect(() => categoryLocator<UnregisteredType>(), throwsA(isA<Error>()));
    });

    test('multiple calls to setupCategoriesLocator do not throw', () {
      CategoryServiceLocator.setup();
      CategoryServiceLocator.setup();

      expect(testLocator.isRegistered<CategoriesRepository>(), isTrue);
      expect(testLocator.isRegistered<CategoriesBloc>(), isTrue);
    });
  });
}

// Helper class for testing unregistered type
class UnregisteredType {}
