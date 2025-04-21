import 'package:core/src/storage/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late SecureStorageService secureStorageService;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    secureStorageService = SecureStorageService(storage: mockStorage);
  });

  group('SecureStorageService', () {
    const testKey = 'testKey';
    const testUrl = 'https://example.com';

    test('saveSecureUrl should call write on FlutterSecureStorage', () async {
      when(
        () => mockStorage.write(key: testKey, value: testUrl),
      ).thenAnswer((_) async => Future<void>.value());

      await secureStorageService.saveSecureUrl(testKey, testUrl);

      verify(() => mockStorage.write(key: testKey, value: testUrl)).called(1);
    });

    test('getSecureUrl should call read on FlutterSecureStorage', () async {
      when(
        () => mockStorage.read(key: testKey),
      ).thenAnswer((_) async => testUrl);

      final result = await secureStorageService.getSecureUrl(testKey);

      expect(result, testUrl);
      verify(() => mockStorage.read(key: testKey)).called(1);
    });

    test(
      'deleteSecureUrl should call delete on FlutterSecureStorage',
      () async {
        when(
          () => mockStorage.delete(key: testKey),
        ).thenAnswer((_) async => Future<void>.value());

        await secureStorageService.deleteSecureUrl(testKey);

        verify(() => mockStorage.delete(key: testKey)).called(1);
      },
    );

    test(
      'deleteAllSecureUrls should call deleteAll on FlutterSecureStorage',
      () async {
        when(
          () => mockStorage.deleteAll(),
        ).thenAnswer((_) async => Future<void>.value());

        await secureStorageService.deleteAllSecureUrls();

        verify(() => mockStorage.deleteAll()).called(1);
      },
    );
  });
}
