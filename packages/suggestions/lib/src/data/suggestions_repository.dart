import 'package:network/network.dart';
import 'package:suggestions/src/data/suggestion_model.dart';

class SuggestionsRepository {
  SuggestionsRepository(this._apiClient);
  final ApiClient _apiClient;
  List<String>? _cachedSuggestions;
  DateTime? _cacheTimestamp;
  Duration cacheValidity = const Duration(hours: 2);

  Future<List<String>> loadSuggestions() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.suggestions);
      final jsonList = response['data'] as List<dynamic>;
      final suggestions = jsonList
          .map(
            (json) => SuggestionModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
      _cachedSuggestions = suggestions.map((e) => e.name).toList();
      return _cachedSuggestions!;
    } catch (e) {
      throw Exception('Failed to fetch suggestions: $e');
    }
  }

  // ignore: unnecessary_getters_setters
  List<String>? get cachedSuggestions => _cachedSuggestions;

  set cachedSuggestions(List<String>? categories) {
    _cachedSuggestions = categories;
    _cacheTimestamp = DateTime.now();
  }

  bool get isCacheValid {
    if (_cachedSuggestions == null || _cacheTimestamp == null) return false;
    return DateTime.now().difference(_cacheTimestamp!) < cacheValidity;
  }

  void clearCache() {
    _cachedSuggestions = null;
    _cacheTimestamp = null;
  }
}
