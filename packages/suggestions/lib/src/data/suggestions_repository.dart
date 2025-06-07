import 'package:core/core.dart';
import 'package:network/network.dart';
import 'package:suggestions/src/data/suggestion_model.dart';
import 'package:suggestions/src/data/suggestion_response.dart';

class SuggestionsRepository {
  SuggestionsRepository({required this.apiClient, required this.cacheService});
  final ApiClient apiClient;
  final CacheService cacheService;

  CacheEntry<List<SuggestionModel>>? _cacheEntry;

  Future<List<SuggestionModel>> loadSuggestions() async {
    try {
      final response = await apiClient.get(ApiEndpoints.suggestions);
      final jsonList = response['data'] as List<dynamic>;
      final suggestionsResponse = jsonList
          .map(
            (json) => SuggestionResponse.fromJson(json as Map<String, dynamic>),
          )
          .toList();
      final suggestions = _transform(suggestionsResponse);
      await saveToCache(suggestions);
      return suggestions;
    } catch (e) {
      throw Exception('Failed to fetch suggestions: $e');
    }
  }

  Future<void> saveToCache(List<SuggestionModel>? suggestions) async {
    if (suggestions != null) {
      await cacheService.write<List<SuggestionModel>>(
        key: 'Suggestions',
        value: suggestions,
        ttlHrs: 24 * 8, // 8 days
        encode: (sections) =>
            sections.map((section) => section.toJson()).toList(),
      );
      _cacheEntry = null;
    }
  }

  CacheEntry<List<SuggestionModel>>? get cachedSuggestions {
    if (_cacheEntry == null || _cacheEntry!.isExpired == true) {
      _cacheEntry = cacheService.read<List<SuggestionModel>>(
        key: 'Suggestions',
        decode: (raw) => (raw as List)
            .map(
              (item) => SuggestionModel.fromJson(
                (item as Map).map((k, v) => MapEntry(k.toString(), v)),
              ),
            )
            .toList(),
      );
    }
    return _cacheEntry;
  }

  List<SuggestionModel> _transform(List<SuggestionResponse> searchList) {
    return searchList
        .map(
          (item) => SuggestionModel(
            name: item.name,
            id: item.id,
          ),
        )
        .toList();
  }

  void clearCache() {
    cacheService.delete('Suggestions');
    _cacheEntry = null;
  }
}
