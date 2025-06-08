import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ThumbnailImageCacheManager extends CacheManager {
  factory ThumbnailImageCacheManager() {
    return _instance;
  }

  ThumbnailImageCacheManager._()
    : super(
        Config(
          key,
          stalePeriod: stalePeriod,
          maxNrOfCacheObjects: maxObjects,
          repo: JsonCacheInfoRepository(databaseName: key),
          fileService: HttpFileService(),
        ),
      );
  static const key = 'ThumbnailImageCache';
  static Duration get stalePeriod => const Duration(days: 7);
  static int get maxObjects => 500;

  static final ThumbnailImageCacheManager _instance =
      ThumbnailImageCacheManager._();
}
