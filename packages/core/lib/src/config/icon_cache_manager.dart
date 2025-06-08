import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class IconCacheManager extends CacheManager {
  factory IconCacheManager() {
    return _instance;
  }

  IconCacheManager._()
    : super(
        Config(
          key,
          stalePeriod: stalePeriod,
          maxNrOfCacheObjects: maxObjects,
          repo: JsonCacheInfoRepository(databaseName: key),
          fileService: HttpFileService(),
        ),
      );
  static const key = 'IconCache';

  static Duration get stalePeriod => const Duration(days: 30);
  static int get maxObjects => 500;

  static final IconCacheManager _instance = IconCacheManager._();
}
