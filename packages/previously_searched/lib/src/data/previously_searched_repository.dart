import 'package:core/core.dart';
import 'package:network/network.dart';
import 'package:previously_searched/src/data/previously_searched_item.dart';
import 'package:previously_searched/src/data/search_item_response.dart';

class PreviouslySearchedRepository {
  PreviouslySearchedRepository({
    required this.apiClient,
    required this.cacheService,
  });
  final ApiClient apiClient;
  final CacheService cacheService;
  CacheEntry<List<PreviouslySearchedItem>>? _cacheEntry;

  Future<List<PreviouslySearchedItem>> loadPreviouslySearched() async {
    try {
      final response = await apiClient.get(
        // TODO(me): Apply the phone number dynamically.
        '${ApiEndpoints.previouslySearched}?phone_number=9980200445',
      );
      final responseData = response['data'] as Map<String, dynamic>;
      final jsonList = responseData['results'] as List<dynamic>;
      final searchList =
          jsonList
              .map(
                (json) =>
                    SearchItemResponse.fromJson(json as Map<String, dynamic>),
              )
              .toList();
      final previouslySearchedItems = _transform(searchList);
      await saveToCache(previouslySearchedItems);
      return previouslySearchedItems;
    } catch (e) {
      throw Exception('Failed to fetch search items: $e');
    }
  }

  CacheEntry<List<PreviouslySearchedItem>>? get cachedPreviouslySearched {
    if (_cacheEntry == null || _cacheEntry!.isExpired == true) {
      _cacheEntry = cacheService.read<List<PreviouslySearchedItem>>(
        key: 'PreviouslySearched',
        decode:
            (raw) =>
                (raw as List)
                    .map(
                      (item) => PreviouslySearchedItem.fromJson(
                        (item as Map).map((k, v) => MapEntry(k.toString(), v)),
                      ),
                    )
                    .toList(),
      );
    }
    return _cacheEntry;
  }

  Future<void> saveToCache(List<PreviouslySearchedItem>? categories) async {
    if (categories != null) {
      await cacheService.write<List<PreviouslySearchedItem>>(
        key: 'PreviouslySearched',
        value: categories,
        ttlHrs: 2,
        encode:
            (sections) => sections.map((section) => section.toJson()).toList(),
      );
      _cacheEntry = null;
    }
  }

  void clearCache() {
    cacheService.delete('PreviouslySearched');
    _cacheEntry = null;
  }

  List<PreviouslySearchedItem> _transform(List<SearchItemResponse> searchList) {
    return searchList
        .map(
          (item) => PreviouslySearchedItem(
            product: item.product,
            productIcon: item.productIcon,
            productUrl: item.productUrl,
          ),
        )
        .toList();
  }
}
