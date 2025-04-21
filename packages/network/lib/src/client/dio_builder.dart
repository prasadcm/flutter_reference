import 'package:core/core.dart';
import 'package:dio/dio.dart';

class DioBuilder {
  factory DioBuilder(final AppEnvironment env) => DioBuilder._(env: env);

  DioBuilder._({required this.env})
    : dio = Dio(
        BaseOptions(
          baseUrl: env.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    dio.interceptors.addAll([
      // _createLogInterceptor(),
      // _createErrorInterceptor(),
    ]);
  }

  final AppEnvironment env;
  late Dio dio;
}
