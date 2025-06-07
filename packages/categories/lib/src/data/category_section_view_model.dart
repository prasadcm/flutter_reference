import 'package:categories/src/data/category_item_view_model.dart';

class CategorySectionViewModel {
  CategorySectionViewModel({
    required this.title,
    required this.items,
    required this.sequence,
  });

  final String title;
  final List<CategoryItemViewModel> items;
  final int sequence;
}
