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

    // Group items by category name
    for (final category in categories) {
      groupedCategories.putIfAbsent(category.name, () => []).add(category);
    }

    // Map and sort each section
    final sections =
        groupedCategories.entries.map((entry) {
          final sortedItems =
              entry.value
                ..sort((a, b) => a.itemSequence.compareTo(b.itemSequence));

          return CategorySection(
            title: entry.key,
            sequence: sortedItems.first.categorySequence,
            items:
                sortedItems.map((category) {
                  return CategoryItem(
                    id: category.categoryId,
                    name: category.item,
                    imageUrl: category.image,
                    sequence: category.itemSequence,
                  );
                }).toList(),
          );
        }).toList();

    // Sort the final list of sections by categorySequence
    // ignore: cascade_invocations
    sections.sort((a, b) => a.sequence.compareTo(b.sequence));

    return sections;
  }
}
