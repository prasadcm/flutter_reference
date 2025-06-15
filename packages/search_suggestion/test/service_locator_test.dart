import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/network.dart';
import 'package:search_suggestion/search_suggestion.dart';
import 'package:search_suggestion/src/data/search_suggestion_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockSearchSuggestionRepository extends Mock
    implements SearchSuggestionRepository {}

class MockSearchSuggestionBloc extends Mock implements SearchSuggestionBloc {}

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
      final testInstance = MockSearchSuggestionRepository();

      SearchSuggestionServiceLocator.registerLazySingleton<
        SearchSuggestionRepository
      >(testLocator, () => testInstance);

      expect(testLocator<SearchSuggestionRepository>(), equals(testInstance));
    });

    test('registerLazySingleton replaces existing instance', () {
      final firstInstance = MockSearchSuggestionRepository();
      final secondInstance = MockSearchSuggestionRepository();

      SearchSuggestionServiceLocator.registerLazySingleton<
        SearchSuggestionRepository
      >(testLocator, () => firstInstance);
      SearchSuggestionServiceLocator.registerLazySingleton<
        SearchSuggestionRepository
      >(testLocator, () => secondInstance);

      expect(testLocator<SearchSuggestionRepository>(), equals(secondInstance));
    });

    test('registerCachedFactory registers new instance', () {
      final testBloc = MockSearchSuggestionBloc();

      SearchSuggestionServiceLocator.registerFactory<SearchSuggestionBloc>(
        testLocator,
        () => testBloc,
      );

      expect(testLocator<SearchSuggestionBloc>(), equals(testBloc));
    });

    test('registerCachedFactory replaces existing instance', () {
      final firstBloc = MockSearchSuggestionBloc();
      final secondBloc = MockSearchSuggestionBloc();

      SearchSuggestionServiceLocator.registerFactory<SearchSuggestionBloc>(
        testLocator,
        () => firstBloc,
      );
      SearchSuggestionServiceLocator.registerFactory<SearchSuggestionBloc>(
        testLocator,
        () => secondBloc,
      );

      expect(testLocator<SearchSuggestionBloc>(), equals(secondBloc));
    });

    test('setup registers all dependencies', () {
      SearchSuggestionServiceLocator.setup();

      expect(testLocator.isRegistered<SearchSuggestionRepository>(), isTrue);
      expect(testLocator.isRegistered<SearchSuggestionBloc>(), isTrue);
    });

    test('categoryLocator throws when accessing unregistered type', () {
      expect(
        () => searchSuggestionLocator<UnregisteredType>(),
        throwsA(isA<Error>()),
      );
    });

    test('multiple calls to setupCategoriesLocator do not throw', () {
      SearchSuggestionServiceLocator.setup();
      SearchSuggestionServiceLocator.setup();

      expect(testLocator.isRegistered<SearchSuggestionRepository>(), isTrue);
      expect(testLocator.isRegistered<SearchSuggestionBloc>(), isTrue);
    });
  });
}

// Helper class for testing unregistered type
class UnregisteredType {}
