import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:network/network.dart';
import 'package:suggestions/suggestions.dart';

final GetIt suggestionLocator = GetIt.instance;

class SuggestionServiceLocator {
  static void registerLazySingleton<T extends Object>(
    GetIt locator,
    T Function() factoryFunc,
  ) {
    if (locator.isRegistered<T>()) {
      locator.unregister<T>();
    }
    locator.registerLazySingleton<T>(factoryFunc);
  }

  static void registerFactory<T extends Object>(
    GetIt locator,
    T Function() factoryFunc,
  ) {
    if (locator.isRegistered<T>()) {
      locator.unregister<T>();
    }
    locator.registerFactory<T>(factoryFunc);
  }

  static void setup() {
    final apiClient = networkLocator<ApiClient>();
    final cacheService = coreLocator<CacheService>();

    registerLazySingleton<SuggestionsRepository>(
      suggestionLocator,
      () => SuggestionsRepository(
        apiClient: apiClient,
        cacheService: cacheService,
      ),
    );

    registerFactory(
      suggestionLocator,
      () => SuggestionsBloc(
        suggestionsRepository: suggestionLocator<SuggestionsRepository>(),
      ),
    );
  }
}
