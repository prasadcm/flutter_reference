import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

enum IconCategory { search, error }

class CachedIconView extends StatelessWidget {
  CachedIconView({
    required this.iconUrl,
    required this.defaultIcon,
    this.size = 48,
    super.key,
  });
  final String iconUrl;
  final IconCategory defaultIcon;
  final double size;
  late final AppEnvironment env = coreLocator<AppEnvironment>();

  @override
  Widget build(BuildContext context) {
    if (iconUrl.isEmpty) {
      return defaultIconData(defaultIcon);
    }
    return CachedNetworkImage(
      imageUrl: '${env.baseUrl}/$iconUrl',
      width: size,
      height: size,
      cacheManager: IconCacheManager(),
      errorWidget: (context, url, error) => defaultIconData(defaultIcon),
    );
  }

  Icon defaultIconData(IconCategory category) {
    switch (category) {
      case IconCategory.search:
        return Icon(Icons.schedule, size: size);
      case IconCategory.error:
        return Icon(Icons.error, size: size);
    }
  }
}
