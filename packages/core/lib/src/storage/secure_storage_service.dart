import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  final FlutterSecureStorage _storage;

  Future<void> saveSecureUrl(String key, String url) async =>
      _storage.write(key: key, value: url);

  Future<String?> getSecureUrl(String key) async => _storage.read(key: key);

  Future<void> deleteSecureUrl(String key) async => _storage.delete(key: key);

  Future<void> deleteAllSecureUrls() async => _storage.deleteAll();
}
