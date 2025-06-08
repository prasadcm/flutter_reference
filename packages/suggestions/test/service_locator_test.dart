import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/network.dart';
import 'package:suggestions/suggestions.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockSuggestionsRepository extends Mock implements SuggestionsRepository {}

class MockSuggestionsBloc extends Mock implements SuggestionsBloc {}

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
      final testInstance = MockSuggestionsRepository();

      SuggestionServiceLocator.registerLazySingleton<SuggestionsRepository>(
        testLocator,
        () => testInstance,
      );

      expect(testLocator<SuggestionsRepository>(), equals(testInstance));
    });

    test('registerLazySingleton replaces existing instance', () {
      final firstInstance = MockSuggestionsRepository();
      final secondInstance = MockSuggestionsRepository();

      SuggestionServiceLocator.registerLazySingleton<SuggestionsRepository>(
        testLocator,
        () => firstInstance,
      );
      SuggestionServiceLocator.registerLazySingleton<SuggestionsRepository>(
        testLocator,
        () => secondInstance,
      );

      expect(testLocator<SuggestionsRepository>(), equals(secondInstance));
    });

    test('registerCachedFactory registers new instance', () {
      final testBloc = MockSuggestionsBloc();

      SuggestionServiceLocator.registerFactory<SuggestionsBloc>(
        testLocator,
        () => testBloc,
      );

      expect(testLocator<SuggestionsBloc>(), equals(testBloc));
    });

    test('registerCachedFactory replaces existing instance', () {
      final firstBloc = MockSuggestionsBloc();
      final secondBloc = MockSuggestionsBloc();

      SuggestionServiceLocator.registerFactory<SuggestionsBloc>(
        testLocator,
        () => firstBloc,
      );
      SuggestionServiceLocator.registerFactory<SuggestionsBloc>(
        testLocator,
        () => secondBloc,
      );

      expect(testLocator<SuggestionsBloc>(), equals(secondBloc));
    });

    test('setup registers all dependencies', () {
      SuggestionServiceLocator.setup();

      expect(testLocator.isRegistered<SuggestionsRepository>(), isTrue);
      expect(testLocator.isRegistered<SuggestionsBloc>(), isTrue);
    });

    test('categoryLocator throws when accessing unregistered type', () {
      expect(
        () => suggestionLocator<UnregisteredType>(),
        throwsA(isA<Error>()),
      );
    });

    test('multiple calls to setupCategoriesLocator do not throw', () {
      SuggestionServiceLocator.setup();
      SuggestionServiceLocator.setup();

      expect(testLocator.isRegistered<SuggestionsRepository>(), isTrue);
      expect(testLocator.isRegistered<SuggestionsBloc>(), isTrue);
    });
  });
}

// Helper class for testing unregistered type
class UnregisteredType {}
