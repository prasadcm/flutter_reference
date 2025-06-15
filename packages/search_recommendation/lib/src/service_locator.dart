import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:network/network.dart';
import 'package:search_recommendation/search_recommendation.dart';

final GetIt recommendationLocator = GetIt.instance;

class SearchRecommendationServiceLocator {
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

    registerLazySingleton<SearchRecommendationRepository>(
      recommendationLocator,
      () => SearchRecommendationRepository(
        apiClient: apiClient,
        cacheService: cacheService,
      ),
    );

    registerFactory(
      recommendationLocator,
      () => SearchRecommendationBloc(
        recommendationRepository:
            recommendationLocator<SearchRecommendationRepository>(),
      ),
    );
  }
}
