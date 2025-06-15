import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/network.dart';
import 'package:search_recommendation/search_recommendation.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockSearchRecommendationRepository extends Mock
    implements SearchRecommendationRepository {}

class MockSearchRecommendationBloc extends Mock
    implements SearchRecommendationBloc {}

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
      final testInstance = MockSearchRecommendationRepository();

      SearchRecommendationServiceLocator.registerLazySingleton<
          SearchRecommendationRepository>(
        testLocator,
        () => testInstance,
      );

      expect(
        testLocator<SearchRecommendationRepository>(),
        equals(testInstance),
      );
    });

    test('registerLazySingleton replaces existing instance', () {
      final firstInstance = MockSearchRecommendationRepository();
      final secondInstance = MockSearchRecommendationRepository();

      SearchRecommendationServiceLocator.registerLazySingleton<
          SearchRecommendationRepository>(
        testLocator,
        () => firstInstance,
      );
      SearchRecommendationServiceLocator.registerLazySingleton<
          SearchRecommendationRepository>(
        testLocator,
        () => secondInstance,
      );

      expect(
        testLocator<SearchRecommendationRepository>(),
        equals(secondInstance),
      );
    });

    test('registerCachedFactory registers new instance', () {
      final testBloc = MockSearchRecommendationBloc();

      SearchRecommendationServiceLocator.registerFactory<
          SearchRecommendationBloc>(
        testLocator,
        () => testBloc,
      );

      expect(testLocator<SearchRecommendationBloc>(), equals(testBloc));
    });

    test('registerCachedFactory replaces existing instance', () {
      final firstBloc = MockSearchRecommendationBloc();
      final secondBloc = MockSearchRecommendationBloc();

      SearchRecommendationServiceLocator.registerFactory<
          SearchRecommendationBloc>(
        testLocator,
        () => firstBloc,
      );
      SearchRecommendationServiceLocator.registerFactory<
          SearchRecommendationBloc>(
        testLocator,
        () => secondBloc,
      );

      expect(testLocator<SearchRecommendationBloc>(), equals(secondBloc));
    });

    test('setup registers all dependencies', () {
      SearchRecommendationServiceLocator.setup();

      expect(
        testLocator.isRegistered<SearchRecommendationRepository>(),
        isTrue,
      );
      expect(testLocator.isRegistered<SearchRecommendationBloc>(), isTrue);
    });

    test('categoryLocator throws when accessing unregistered type', () {
      expect(
        () => recommendationLocator<UnregisteredType>(),
        throwsA(isA<Error>()),
      );
    });

    test('multiple calls to setupCategoriesLocator do not throw', () {
      SearchRecommendationServiceLocator.setup();
      SearchRecommendationServiceLocator.setup();

      expect(
        testLocator.isRegistered<SearchRecommendationRepository>(),
        isTrue,
      );
      expect(testLocator.isRegistered<SearchRecommendationBloc>(), isTrue);
    });
  });
}

// Helper class for testing unregistered type
class UnregisteredType {}
