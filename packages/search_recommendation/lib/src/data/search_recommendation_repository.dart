import 'package:core/core.dart';
import 'package:network/network.dart';
import 'package:search_recommendation/search_recommendation.dart';
import 'package:search_recommendation/src/data/search_recommendation_response.dart';

class SearchRecommendationRepository {
  SearchRecommendationRepository({
    required this.apiClient,
    required this.cacheService,
  });
  final ApiClient apiClient;
  final CacheService cacheService;

  CacheEntry<List<SearchRecommendationModel>>? _cacheEntry;

  Future<List<SearchRecommendationModel>> loadSearchRecommendation() async {
    try {
      final response = await apiClient.get(ApiEndpoints.searchRecommendation);
      final jsonList = response['data'] as List<dynamic>;
      final recommendationResponse = jsonList
          .map(
            (json) => SearchRecommendationResponse.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
      final recommendation = _transform(recommendationResponse);
      await saveToCache(recommendation);
      return recommendation;
    } catch (e) {
      throw Exception('Failed to fetch recommendation: $e');
    }
  }

  Future<void> saveToCache(
    List<SearchRecommendationModel>? recommendation,
  ) async {
    if (recommendation != null) {
      await cacheService.write<List<SearchRecommendationModel>>(
        key: 'SearchRecommendation',
        value: recommendation,
        ttlHrs: 24 * 8, // 8 days
        encode: (sections) =>
            sections.map((section) => section.toJson()).toList(),
      );
      _cacheEntry = null;
    }
  }

  CacheEntry<List<SearchRecommendationModel>>? get cachedSearchRecommendation {
    if (_cacheEntry == null || _cacheEntry!.isExpired == true) {
      _cacheEntry = cacheService.read<List<SearchRecommendationModel>>(
        key: 'SearchRecommendation',
        decode: (raw) => (raw as List)
            .map(
              (item) => SearchRecommendationModel.fromJson(
                (item as Map).map((k, v) => MapEntry(k.toString(), v)),
              ),
            )
            .toList(),
      );
    }
    return _cacheEntry;
  }

  List<SearchRecommendationModel> _transform(
    List<SearchRecommendationResponse> searchList,
  ) {
    return searchList
        .map(
          (item) => SearchRecommendationModel(
            name: item.name,
          ),
        )
        .toList();
  }

  void clearCache() {
    cacheService.delete('SearchRecommendation');
    _cacheEntry = null;
  }
}
