import 'package:categories/src/data/category_item.dart';

class CategorySection {
  CategorySection({
    required this.title,
    required this.items,
    required this.sequence,
  });
  final String title;
  final List<CategoryItem> items;
  final int sequence;
}
