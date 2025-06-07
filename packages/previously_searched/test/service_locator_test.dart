import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/network.dart';
import 'package:previously_searched/previously_searched.dart';
import 'package:previously_searched/src/data/previously_searched_repository.dart';

// Create mocks
class MockApiClient extends Mock implements ApiClient {}

class MockPreviouslySearchedRepository extends Mock
    implements PreviouslySearchedRepository {}

class MockPreviouslySearchedBloc extends Mock
    implements PreviouslySearchedBloc {}

class MockCacheService extends Mock implements CacheService {}

void main() {
  group('Service Locator Tests', () {
    late GetIt testLocator;
    late MockApiClient mockApiClient;
    late MockCacheService mockCacheService;

    setUp(() {
      testLocator = GetIt.instance;
      mockApiClient = MockApiClient();
      mockCacheService = MockCacheService();

      GetIt.I.registerSingleton<ApiClient>(mockApiClient);
      GetIt.I.registerSingleton<CacheService>(mockCacheService);
    });

    tearDown(() {
      testLocator.reset();
    });

    test('registerLazySingleton registers new instance', () {
      final testInstance = MockPreviouslySearchedRepository();

      PreviouslySearchedServiceLocator.registerLazySingleton<
        PreviouslySearchedRepository
      >(testLocator, () => testInstance);

      expect(testLocator<PreviouslySearchedRepository>(), equals(testInstance));
    });

    test('registerLazySingleton replaces existing instance', () {
      final firstInstance = MockPreviouslySearchedRepository();
      final secondInstance = MockPreviouslySearchedRepository();

      PreviouslySearchedServiceLocator.registerLazySingleton<
        PreviouslySearchedRepository
      >(testLocator, () => firstInstance);
      PreviouslySearchedServiceLocator.registerLazySingleton<
        PreviouslySearchedRepository
      >(testLocator, () => secondInstance);

      expect(
        testLocator<PreviouslySearchedRepository>(),
        equals(secondInstance),
      );
    });

    test('registerCachedFactory registers new instance', () {
      final testBloc = MockPreviouslySearchedBloc();

      PreviouslySearchedServiceLocator.registerFactory<PreviouslySearchedBloc>(
        testLocator,
        () => testBloc,
      );

      expect(testLocator<PreviouslySearchedBloc>(), equals(testBloc));
    });

    test('registerCachedFactory replaces existing instance', () {
      final firstBloc = MockPreviouslySearchedBloc();
      final secondBloc = MockPreviouslySearchedBloc();

      PreviouslySearchedServiceLocator.registerFactory<PreviouslySearchedBloc>(
        testLocator,
        () => firstBloc,
      );
      PreviouslySearchedServiceLocator.registerFactory<PreviouslySearchedBloc>(
        testLocator,
        () => secondBloc,
      );

      expect(testLocator<PreviouslySearchedBloc>(), equals(secondBloc));
    });

    test('setup registers all dependencies', () {
      PreviouslySearchedServiceLocator.setup();

      expect(testLocator.isRegistered<PreviouslySearchedRepository>(), isTrue);
      expect(testLocator.isRegistered<PreviouslySearchedBloc>(), isTrue);
    });

    test('Service Locator throws when accessing unregistered type', () {
      expect(() => testLocator<UnregisteredType>(), throwsA(isA<Error>()));
    });

    test('multiple calls to setupPreviouslySearchedLocator do not throw', () {
      PreviouslySearchedServiceLocator.setup();
      PreviouslySearchedServiceLocator.setup();

      expect(testLocator.isRegistered<PreviouslySearchedRepository>(), isTrue);
      expect(testLocator.isRegistered<PreviouslySearchedBloc>(), isTrue);
    });
  });
}

// Helper class for testing unregistered type
class UnregisteredType {}
