import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'category_model.dart';

class CategoriesRepository {
  const CategoriesRepository();

  Future<List<CategoryModel>> loadCategories() async {
    final String jsonString = await rootBundle.loadString(
      'packages/cmp_categories/assets/categories.json',
    );
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((data) => CategoryModel.fromJson(data)).toList();
  }
}
