import 'package:dio/dio.dart';
import 'package:network/src/client/api_exception.dart';

class ApiClient {
  ApiClient(this.dio);

  final Dio dio;

  Future<Map<String, dynamic>> get(
    final String path, {
    final Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParams,
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Map<String, dynamic> _processResponse(
    Response<Map<String, dynamic>> response,
  ) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300 &&
        response.data != null) {
      return response.data!;
    } else {
      throw ApiException('Invalid status code: ${response.statusCode}');
    }
  }

  Exception _handleDioError(final DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return ApiException('Connection timeout');
    } else if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final message = e.response!.data.toString();
      return ApiException('[$statusCode] $message');
    } else {
      return ApiException(e.message ?? 'Unexpected error');
    }
  }

  // POST, PUT, DELETE methods can go here as needed...
}
