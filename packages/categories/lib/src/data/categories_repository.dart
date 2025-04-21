import 'package:categories/src/data/category_item.dart';
import 'package:categories/src/data/category_model.dart';
import 'package:categories/src/data/category_section.dart';
import 'package:network/network.dart';

class CategoriesRepository {
  CategoriesRepository(this._apiClient);
  final ApiClient _apiClient;
  List<CategorySection>? _cachedCategories;
  DateTime? _cacheTimestamp;
  Duration cacheValidity = const Duration(hours: 2);

  Future<List<CategorySection>> loadCategories() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.categories);
      final jsonList = response['data'] as List<dynamic>;
      final categories =
          jsonList
              .map(
                (json) => CategoryModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
      _cachedCategories = _transformToCategorySections(categories);
      return _cachedCategories!;
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  // ignore: unnecessary_getters_setters
  List<CategorySection>? get cachedCategories => _cachedCategories;

  set cachedCategories(List<CategorySection>? categories) {
    _cachedCategories = categories;
    _cacheTimestamp = DateTime.now();
  }

  bool get isCacheValid {
    if (_cachedCategories == null || _cacheTimestamp == null) return false;
    return DateTime.now().difference(_cacheTimestamp!) < cacheValidity;
  }

  void clearCache() {
    _cachedCategories = null;
    _cacheTimestamp = null;
  }

  List<CategorySection> _transformToCategorySections(
    List<CategoryModel> categories,
  ) {
    final groupedCategories = <String, List<CategoryModel>>{};

    for (final category in categories) {
      groupedCategories.putIfAbsent(category.name, () => []).add(category);
    }

    // Convert to CategorySection list
    return groupedCategories.entries.map((entry) {
      return CategorySection(
        title: entry.key,
        items:
            entry.value
                .map(
                  (category) => CategoryItem(
                    id: category.categoryId,
                    name: category.item,
                    imageUrl: category.image,
                  ),
                )
                .toList(),
      );
    }).toList();
  }
}
