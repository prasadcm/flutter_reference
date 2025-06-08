import 'package:core/src/storage/cache_entry.dart';
import 'package:core/src/storage/cache_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveCacheService extends CacheService {
  HiveCacheService(HiveInterface? hive) : hive = hive ?? Hive;

  final HiveInterface hive;

  @override
  Future<void> init() async {
    await hive.initFlutter();
    await hive.openBox<dynamic>('hiveBoxWithTtl');
  }

  @override
  Future<void> write<T>({
    required String key,
    required T value,
    int ttlHrs = -1,
    dynamic Function(T value)? encode,
  }) async {
    final expiry = DateTime.now().add(
      ttlHrs < 0 ? const Duration(days: 365) : Duration(hours: ttlHrs),
    );
    final encodedValue = encode != null ? encode(value) : value;
    final entry = CacheEntry(value: encodedValue, expiry: expiry);
    final box = _getBox();
    await box.put(key, entry.toJson());
  }

  @override
  CacheEntry<T>? read<T>({
    required String key,
    T Function(dynamic raw)? decode,
  }) {
    final box = _getBox();
    final raw = box.get(key);
    if (raw is Map) {
      final jsonMap = raw.map((k, v) => MapEntry(k.toString(), v));
      final decodedValue =
          decode != null
              ? decode(_normalizeDynamicJson(jsonMap['value']))
              : jsonMap['value'] as T;
      return CacheEntry<T>.fromJson({...jsonMap, 'value': decodedValue});
    }
    return null;
  }

  @override
  Future<void> delete(String key) async {
    final box = _getBox();
    await box.delete(key);
  }

  @override
  Future<void> clear() async {
    final box = _getBox();
    await box.clear();
  }

  Box<dynamic> _getBox() {
    return hive.box<dynamic>('hiveBoxWithTtl');
  }

  dynamic _normalizeDynamicJson(dynamic input) {
    if (input is Map) {
      return input.map(
        (key, value) => MapEntry(key.toString(), _normalizeDynamicJson(value)),
      );
    } else if (input is List) {
      return input.map(_normalizeDynamicJson).toList();
    } else {
      return input;
    }
  }
}
