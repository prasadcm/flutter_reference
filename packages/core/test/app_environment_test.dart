import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppEnvironment Tests', () {
    test('isDevelopment returns correct value', () {
      for (final env in AppEnvironment.values) {
        expect(
          env.type == AppEnvironmentType.development,
          equals(env == AppEnvironment.development),
        );
      }
    });

    test('isProduction returns correct value', () {
      for (final env in AppEnvironment.values) {
        expect(
          env.type == AppEnvironmentType.production,
          equals(env == AppEnvironment.production),
        );
      }
    });

    test('isStaging returns correct value', () {
      for (final env in AppEnvironment.values) {
        expect(
          env.type == AppEnvironmentType.staging,
          equals(env == AppEnvironment.staging),
        );
      }
    });

    test('baseUrl does not contain spaces', () {
      for (final env in AppEnvironment.values) {
        expect(env.baseUrl.contains(' '), isFalse);
      }
    });

    test('baseUrl is lowercase', () {
      for (final env in AppEnvironment.values) {
        expect(env.baseUrl.toLowerCase(), equals(env.baseUrl));
      }
    });

    test('baseUrl is not empty', () {
      for (final env in AppEnvironment.values) {
        expect(env.baseUrl.isNotEmpty, isTrue);
      }
    });
  });
}
