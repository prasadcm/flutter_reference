import 'package:core/src/config/app_environment.dart';
import 'package:core/src/storage/cache_service.dart';
import 'package:core/src/storage/hive_cache_service.dart';
import 'package:get_it/get_it.dart';

final GetIt coreLocator = GetIt.instance;

class CoreServiceLocator {
  static void registerLazySingleton<T extends Object>(
    final GetIt locator,
    final T Function() factoryFunc,
  ) {
    if (locator.isRegistered<T>()) {
      locator.unregister<T>();
    }
    locator.registerLazySingleton<T>(factoryFunc);
  }

  static void setupAppEnvironment() {
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    final env = switch (flavor) {
      'dev' => AppEnvironment.development,
      'stge' => AppEnvironment.staging,
      'prod' => AppEnvironment.production,
      _ => AppEnvironment.development,
    };
    registerLazySingleton<AppEnvironment>(coreLocator, () => env);
  }

  static Future<void> setupCacheService({CacheService? cacheOverride}) async {
    final cacheService = cacheOverride ?? HiveCacheService(null);
    await cacheService.init();

    registerLazySingleton<CacheService>(coreLocator, () => cacheService);
  }

  static Future<void> setup({CacheService? cacheOverride}) async {
    setupAppEnvironment();
    await setupCacheService(cacheOverride: cacheOverride);
  }
}
