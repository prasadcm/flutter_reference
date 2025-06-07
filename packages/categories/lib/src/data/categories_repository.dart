import 'package:categories/src/data/category_item.dart';
import 'package:categories/src/data/category_response.dart';
import 'package:categories/src/data/category_section.dart';
import 'package:core/core.dart';
import 'package:network/network.dart';

class CategoriesRepository {
  CategoriesRepository({required this.apiClient, required this.cacheService});
  final ApiClient apiClient;
  final CacheService cacheService;
  CacheEntry<List<CategorySection>>? _cacheEntry;

  Future<List<CategorySection>> loadCategories() async {
    try {
      final response = await apiClient.get(ApiEndpoints.categories);
      final jsonList = response['data'] as List<dynamic>;
      final categories =
          jsonList
              .map(
                (json) =>
                    CategoryResponse.fromJson(json as Map<String, dynamic>),
              )
              .toList();
      final categorySections = _transform(categories);
      await saveToCache(categorySections);
      return categorySections;
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  CacheEntry<List<CategorySection>>? get cachedCategories {
    if (_cacheEntry == null || _cacheEntry!.isExpired == true) {
      _cacheEntry = cacheService.read<List<CategorySection>>(
        key: 'Categories',
        decode:
            (raw) =>
                (raw as List)
                    .map(
                      (item) => CategorySection.fromJson(
                        (item as Map).map((k, v) => MapEntry(k.toString(), v)),
                      ),
                    )
                    .toList(),
      );
    }
    return _cacheEntry;
  }

  Future<void> saveToCache(List<CategorySection>? categories) async {
    if (categories != null) {
      await cacheService.write<List<CategorySection>>(
        key: 'Categories',
        value: categories,
        ttlHrs: 2,
        encode:
            (sections) => sections.map((section) => section.toJson()).toList(),
      );
      _cacheEntry = null;
    }
  }

  void clearCache() {
    cacheService.delete('Categories');
    _cacheEntry = null;
  }

  List<CategorySection> _transform(List<CategoryResponse> categories) {
    final groupedCategories = <String, List<CategoryResponse>>{};

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
