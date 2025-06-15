import 'package:json_annotation/json_annotation.dart';

part 'search_recommendation_response.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchRecommendationResponse {
  const SearchRecommendationResponse({
    required this.name,
    this.iconUrl,
    this.type,
    this.slug,
    this.productId,
    this.categoryId,
    this.productUrl,
  });

  factory SearchRecommendationResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchRecommendationResponseFromJson(json);

  final String name;
  final String? iconUrl;
  final String? type;
  final String? slug;
  final String? productId;
  final String? categoryId;
  final String? productUrl;

  Map<String, dynamic> toJson() => _$SearchRecommendationResponseToJson(this);
}
