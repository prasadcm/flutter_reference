import 'package:categories/src/bloc/categories_bloc.dart';
import 'package:categories/src/data/categories_repository.dart';
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

    registerLazySingleton<CategoriesRepository>(
      categoryLocator,
      () => CategoriesRepository(apiClient),
    );

    registerCachedFactory(
      categoryLocator,
      () => CategoriesBloc(
        categoriesRepository: categoryLocator<CategoriesRepository>(),
      ),
    );
  }
}
