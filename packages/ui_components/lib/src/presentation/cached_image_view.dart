import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class CachedImageView extends StatelessWidget {
  CachedImageView({
    required this.url,
    super.key,
  });
  final String url;
  late final AppEnvironment env = coreLocator<AppEnvironment>();

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return defaultImage();
    }
    final env = coreLocator<AppEnvironment>();
    return CachedNetworkImage(
      imageUrl: '${env.baseUrl}/$url',
      cacheManager: ThumbnailImageCacheManager(),
      placeholder: (context, url) => defaultImage(),
      errorWidget: (context, url, error) => defaultImage(),
      fit: BoxFit.cover,
    );
  }

  Image defaultImage() {
    return Image.asset(
      'packages/ui_components/assets/placeholder/thumbnail.jpg',
    );
  }
}
