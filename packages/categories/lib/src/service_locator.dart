import 'package:categories/src/bloc/categories_bloc.dart';
import 'package:categories/src/data/categories_repository.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:network/network.dart';

final GetIt categoryLocator = GetIt.instance;

class CategoryServiceLocator {
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

    registerLazySingleton<CategoriesRepository>(
      categoryLocator,
      () => CategoriesRepository(
        apiClient: apiClient,
        cacheService: cacheService,
      ),
    );

    registerFactory(
      categoryLocator,
      () => CategoriesBloc(
        categoriesRepository: categoryLocator<CategoriesRepository>(),
      ),
    );
  }
}
