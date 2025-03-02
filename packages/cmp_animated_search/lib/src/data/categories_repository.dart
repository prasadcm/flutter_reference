import 'dart:convert';

import '../data/category_model.dart';

class CategoriesRepository {
  List<CategoryModel> getCategories() {
    final List<dynamic> response = json.decode(categories());
    return response.map((item) => CategoryModel.fromJson(item)).toList();
  }

  String categories() {
    return '''
      [
        {"name": "Item 1", "icon": "icon 1"},
        {"name": "Item 2", "icon": "icon 2"},
        {"name": "Item 3", "icon": "icon  3"}
      ]
    ''';
  }
}
