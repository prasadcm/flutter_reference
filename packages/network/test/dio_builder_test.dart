import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/src/client/dio_builder.dart';

class MockDio extends Mock implements Dio {}

class MockInterceptor extends Mock implements Interceptor {}

void main() {
  group('DioBuilder', () {
    late AppEnvironment testEnvironment;

    setUp(() {
      testEnvironment = AppEnvironment.development;
    });

    test('creates Dio instance with correct base configuration', () {
      final builder = DioBuilder(testEnvironment);
      final dio = builder.dio;

      expect(dio, isA<Dio>());
      expect(dio.options.baseUrl, equals('${testEnvironment.baseUrl}/api/'));
      expect(dio.options.connectTimeout, equals(const Duration(seconds: 10)));
      expect(dio.options.receiveTimeout, equals(const Duration(seconds: 10)));
      expect(dio.options.headers['Content-Type'], equals('application/json'));
    });

    test('adds correct number of interceptors', () {
      final builder = DioBuilder(testEnvironment);
      final dio = builder.dio;

      expect(dio.interceptors.length, equals(1));
    });

    group('environment specific configuration', () {
      test('development environment uses correct base URL', () {
        // Arrange
        const devEnvironment = AppEnvironment.development;

        // Act
        final builder = DioBuilder(devEnvironment);

        // Assert
        expect(
          builder.dio.options.baseUrl,
          equals('${devEnvironment.baseUrl}/api/'),
        );
      });

      test('staging environment uses correct base URL', () {
        // Arrange
        const stageEnvironment = AppEnvironment.staging;

        // Act
        final builder = DioBuilder(stageEnvironment);

        // Assert
        expect(
          builder.dio.options.baseUrl,
          equals('${stageEnvironment.baseUrl}/api/'),
        );
      });

      test('production environment uses correct base URL', () {
        // Arrange
        const prodEnvironment = AppEnvironment.production;

        // Act
        final builder = DioBuilder(prodEnvironment);

        // Assert
        expect(
          builder.dio.options.baseUrl,
          equals('${prodEnvironment.baseUrl}/api/'),
        );
      });
    });

    group('headers configuration', () {
      test('content-type header is set correctly', () {
        // Act
        final builder = DioBuilder(testEnvironment);

        // Assert
        expect(
          builder.dio.options.headers['Content-Type'],
          equals('application/json'),
        );
      });

      test('headers are case-insensitive', () {
        // Act
        final builder = DioBuilder(testEnvironment);

        // Assert
        expect(
          builder.dio.options.headers['content-type'],
          equals('application/json'),
        );
        expect(
          builder.dio.options.headers['CONTENT-TYPE'],
          equals('application/json'),
        );
      });
    });

    test('creates new instance for each builder', () {
      final builder1 = DioBuilder(testEnvironment);
      final builder2 = DioBuilder(testEnvironment);

      expect(identical(builder1.dio, builder2.dio), isFalse);
    });
  });
}

// Helper extension for testing
extension DioOptionsAssertions on BaseOptions {
  void assertBasicConfiguration() {
    expect(baseUrl, isNotEmpty);
    expect(connectTimeout, isNotNull);
    expect(receiveTimeout, isNotNull);
    expect(headers['Content-Type'], equals('application/json'));
  }
}
