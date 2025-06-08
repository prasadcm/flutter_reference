import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:network/network.dart';
import 'package:previously_searched/src/bloc/previously_searched_bloc.dart';
import 'package:previously_searched/src/data/previously_searched_repository.dart';

final GetIt previouslySearchedLocator = GetIt.instance;

class PreviouslySearchedServiceLocator {
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

    registerLazySingleton<PreviouslySearchedRepository>(
      previouslySearchedLocator,
      () => PreviouslySearchedRepository(
        apiClient: apiClient,
        cacheService: cacheService,
      ),
    );

    registerFactory(
      previouslySearchedLocator,
      () => PreviouslySearchedBloc(
        searchRepository:
            previouslySearchedLocator<PreviouslySearchedRepository>(),
      ),
    );
  }
}
