import 'package:categories/src/data/category_item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class CategoryItemWidget extends StatelessWidget {
  const CategoryItemWidget({required this.item, super.key});
  final CategoryItemViewModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 94,
      margin: const EdgeInsets.all(1),
      child: Card(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(child: CachedImageView(url: item.imageUrl)),
            // Title and Description
            Padding(
              padding: const EdgeInsets.all(2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
