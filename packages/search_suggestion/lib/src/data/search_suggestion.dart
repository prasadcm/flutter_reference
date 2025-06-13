import 'package:json_annotation/json_annotation.dart';

part 'search_suggestion.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchSuggestionItem {
  const SearchSuggestionItem({
    required this.name,
    this.iconUrl,
    this.type,
    this.slug,
    this.productId,
    this.categoryId,
    this.productUrl,
  });

  factory SearchSuggestionItem.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionItemFromJson(json);

  final String name;
  final String? iconUrl;
  final String? type;
  final String? slug;
  final String? productId;
  final String? categoryId;
  final String? productUrl;

  Map<String, dynamic> toJson() => _$SearchSuggestionItemToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SearchSuggestion {
  const SearchSuggestion({required this.items, required this.total});

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionFromJson(json);

  final List<SearchSuggestionItem> items;
  final int total;

  Map<String, dynamic> toJson() => _$SearchSuggestionToJson(this);
}
