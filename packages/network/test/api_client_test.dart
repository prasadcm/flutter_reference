import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/src/client/api_client.dart';
import 'package:network/src/client/api_exception.dart';

class MockDio extends Mock implements Dio {}

class MockResponse extends Mock implements Response<Map<String, dynamic>> {}

class MockDioError extends Mock implements DioException {}

void main() {
  group('ApiClient', () {
    late ApiClient apiClient;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      apiClient = ApiClient(mockDio);
    });

    group('get', () {
      test('successful request returns response data', () async {
        // Arrange
        final responseData = {'key': 'value'};
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.data).thenReturn(responseData);
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => response);

        // Act
        final result = await apiClient.get('test/path');

        // Assert
        expect(result, equals(responseData));
        verify(() => mockDio.get<Map<String, dynamic>>('test/path')).called(1);
      });

      test('handles query parameters correctly', () async {
        // Arrange
        final queryParams = {'param': 'value'};
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.data).thenReturn({});
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => response);

        // Act
        await apiClient.get('test/path', queryParams: queryParams);

        // Assert
        verify(
          () => mockDio.get<Map<String, dynamic>>(
            'test/path',
            queryParameters: queryParams,
          ),
        ).called(1);
      });

      test('throws ApiException on connection timeout', () async {
        // Arrange
        final dioError = MockDioError();
        when(
          () => dioError.type,
        ).thenReturn(DioExceptionType.connectionTimeout);
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(dioError);

        // Act & Assert
        expect(
          () => apiClient.get('test/path'),
          throwsA(
            isA<ApiException>().having(
              (e) => e.message,
              'message',
              'Connection timeout',
            ),
          ),
        );
      });

      test('throws ApiException with status code on error response', () async {
        // Arrange
        final errorResponse = Response(
          statusCode: 404,
          data: 'Not Found',
          requestOptions: RequestOptions(),
        );
        final dioError = DioException(
          response: errorResponse,
          requestOptions: RequestOptions(),
        );
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(dioError);

        // Act & Assert
        expect(
          () => apiClient.get('test/path'),
          throwsA(
            isA<ApiException>().having(
              (e) => e.message,
              'message',
              '[404] Not Found',
            ),
          ),
        );
      });

      test('throws ApiException on unexpected error', () async {
        // Arrange
        final dioError = MockDioError();
        when(() => dioError.type).thenReturn(DioExceptionType.unknown);
        when(() => dioError.message).thenReturn(null);
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(dioError);

        // Act & Assert
        expect(
          () => apiClient.get('test/path'),
          throwsA(
            isA<ApiException>().having(
              (e) => e.message,
              'message',
              'Unexpected error',
            ),
          ),
        );
      });
    });

    group('get - response processing', () {
      test('returns data for successful response', () async {
        // Arrange
        final responseData = {'key': 'value'};
        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        );
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => response);

        // Act
        final result = await apiClient.get('test/path');

        // Assert
        expect(result, equals(responseData));
      });

      test('throws ApiException for null status code', () async {
        // Arrange
        final response = Response<Map<String, dynamic>>(
          data: {'key': 'value'},
          requestOptions: RequestOptions(),
        );
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => response);

        // Act & Assert
        expect(() => apiClient.get('test/path'), throwsA(isA<ApiException>()));
      });

      test('throws ApiException for status code >= 300', () async {
        // Arrange
        final response = Response<Map<String, dynamic>>(
          data: {'key': 'value'},
          statusCode: 300,
          requestOptions: RequestOptions(),
        );
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => response);

        // Act & Assert
        expect(() => apiClient.get('test/path'), throwsA(isA<ApiException>()));
      });

      test('throws ApiException for null response data', () async {
        // Arrange
        final response = Response<Map<String, dynamic>>(
          statusCode: 200,
          requestOptions: RequestOptions(),
        );
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => response);

        // Act & Assert
        expect(() => apiClient.get('test/path'), throwsA(isA<ApiException>()));
      });
    });

    group('get - error handling', () {
      test('handles connection timeout', () async {
        // Arrange
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(),
          ),
        );

        // Act & Assert
        expect(
          () => apiClient.get('test/path'),
          throwsA(
            isA<ApiException>().having(
              (e) => e.message,
              'message',
              'Connection timeout',
            ),
          ),
        );
      });

      test('handles error response with status code', () async {
        // Arrange
        final errorResponse = Response(
          statusCode: 404,
          data: 'Not Found',
          requestOptions: RequestOptions(),
        );
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            response: errorResponse,
            requestOptions: RequestOptions(),
          ),
        );

        // Act & Assert
        expect(
          () => apiClient.get('test/path'),
          throwsA(
            isA<ApiException>().having(
              (e) => e.message,
              'message',
              '[404] Not Found',
            ),
          ),
        );
      });

      test('handles unexpected errors', () async {
        // Arrange
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(DioException(requestOptions: RequestOptions()));

        // Act & Assert
        expect(
          () => apiClient.get('test/path'),
          throwsA(
            isA<ApiException>().having(
              (e) => e.message,
              'message',
              'Unexpected error',
            ),
          ),
        );
      });
    });

    group('get - query parameters', () {
      test('includes query parameters in request', () async {
        // Arrange
        final queryParams = {'key': 'value'};
        final response = Response(
          data: {'result': 'success'},
          statusCode: 200,
          requestOptions: RequestOptions(),
        );
        when(
          () => mockDio.get<Map<String, dynamic>>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => response);

        // Act
        await apiClient.get('test/path', queryParams: queryParams);

        // Assert
        verify(
          () => mockDio.get<Map<String, dynamic>>(
            'test/path',
            queryParameters: queryParams,
          ),
        ).called(1);
      });
    });
  });
}
