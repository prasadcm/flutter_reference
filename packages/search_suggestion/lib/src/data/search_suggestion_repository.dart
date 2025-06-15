import 'package:network/network.dart';
import 'package:search_suggestion/src/data/search_suggestion.dart';

class SearchSuggestionRepository {
  SearchSuggestionRepository({required this.apiClient});
  final ApiClient apiClient;
  SearchSuggestion _previouslySearched = const SearchSuggestion(
    items: [],
    total: 0,
  );

  Future<SearchSuggestion> loadSearchSuggestion({required String query}) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.searchSuggestion}?query=$query',
      );
      final responseData = response['data'] as Map<String, dynamic>;
      return _previouslySearched = _transform(responseData);
    } catch (e) {
      throw Exception('Failed to fetch search items: $e');
    }
  }

  SearchSuggestion get previouslySearched {
    return _previouslySearched;
  }

  SearchSuggestion _transform(Map<String, dynamic> responseData) {
    final searchList =
        (responseData['results'] as List<dynamic>)
            .map(
              (item) =>
                  SearchSuggestionItem.fromJson(item as Map<String, dynamic>),
            )
            .toList();
    final total = responseData['total'] as int? ?? 0;
    return SearchSuggestion(items: searchList, total: total);
  }
}
