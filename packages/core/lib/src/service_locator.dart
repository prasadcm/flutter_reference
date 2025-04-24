import 'package:core/src/config/app_environment.dart';
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

  static void setup() {
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    final env = switch (flavor) {
      'dev' => AppEnvironment.development,
      'stge' => AppEnvironment.staging,
      'prod' => AppEnvironment.production,
      _ => AppEnvironment.development,
    };
    registerLazySingleton<AppEnvironment>(coreLocator, () => env);
  }
}
