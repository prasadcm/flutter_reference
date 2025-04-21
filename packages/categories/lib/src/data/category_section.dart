import 'package:categories/src/data/category_item.dart';

class CategorySection {
  CategorySection({required this.title, required this.items});
  final String title;
  final List<CategoryItem> items;
}
