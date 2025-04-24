import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:network/src/client/api_client.dart';
import 'package:network/src/client/dio_builder.dart';

final GetIt networkLocator = GetIt.instance;

class NetworkServiceLocator {
  static void registerLazySingleton<T extends Object>(
    GetIt locator,
    T Function() factoryFunc,
  ) {
    if (locator.isRegistered<T>()) {
      locator.unregister<T>();
    }
    locator.registerLazySingleton<T>(factoryFunc);
  }

  static void setup() {
    final appEnvironment = coreLocator<AppEnvironment>();

    registerLazySingleton<Dio>(
      networkLocator,
      () => DioBuilder(appEnvironment).dio,
    );

    registerLazySingleton<ApiClient>(
      networkLocator,
      () => ApiClient(networkLocator<Dio>()),
    );
  }
}
