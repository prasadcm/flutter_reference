import 'package:json_annotation/json_annotation.dart';

part 'search_suggestion_response.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchSuggestionItemResponse {
  const SearchSuggestionItemResponse({
    required this.name,
    this.iconUrl,
    this.type,
    this.slug,
    this.productId,
    this.categoryId,
    this.productUrl,
  });

  factory SearchSuggestionItemResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionItemResponseFromJson(json);

  final String name;
  final String? iconUrl;
  final String? type;
  final String? slug;
  final String? productId;
  final String? categoryId;
  final String? productUrl;

  Map<String, dynamic> toJson() => _$SearchSuggestionItemResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SearchSuggestionResponse {
  const SearchSuggestionResponse({required this.total, required this.results});

  factory SearchSuggestionResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionResponseFromJson(json);

  final int total;
  final List<SearchSuggestionItemResponse> results;

  Map<String, dynamic> toJson() => _$SearchSuggestionResponseToJson(this);
}
