class SearchSuggestionItemViewModel {
  const SearchSuggestionItemViewModel({
    required this.iconUrl,
    required this.name,
    this.type,
    this.slug,
    this.productId,
    this.categoryId,
    this.productUrl,
  });

  final String iconUrl;
  final String name;
  final String? type;
  final String? slug;
  final String? productId;
  final String? categoryId;
  final String? productUrl;
}

class SearchSuggestionViewModel {
  const SearchSuggestionViewModel({
    required this.suggestions,
    required this.total,
  });

  final List<SearchSuggestionItemViewModel> suggestions;
  final int total;
}
