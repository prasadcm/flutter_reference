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

  static void registerCachedFactory<T extends Object>(
    GetIt locator,
    T Function() factoryFunc,
  ) {
    if (locator.isRegistered<T>()) {
      locator.unregister<T>();
    }
    locator.registerCachedFactory<T>(factoryFunc);
  }

  static void setup() {
    final apiClient = networkLocator<ApiClient>();

    registerLazySingleton<SuggestionsRepository>(
      suggestionLocator,
      () => SuggestionsRepository(apiClient),
    );

    registerCachedFactory(
      suggestionLocator,
      () => SuggestionsBloc(
        suggestionsRepository: suggestionLocator<SuggestionsRepository>(),
      ),
    );
  }
}
