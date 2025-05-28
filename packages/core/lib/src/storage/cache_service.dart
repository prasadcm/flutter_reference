import 'package:core/core.dart';

abstract class CacheService {
  const CacheService();

  Future<void> init();

  Future<void> write<T>({
    required String key,
    required T value,
    int ttlHrs = -1,
    dynamic Function(T value)? encode,
  });

  CacheEntry<T>? read<T>({
    required String key,
    T Function(dynamic raw)? decode,
  });

  Future<void> delete(String key);
  Future<void> clear();
}
