import 'package:json_annotation/json_annotation.dart';

part 'search_recommendation_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchRecommendationModel {
  SearchRecommendationModel({required this.name});

  factory SearchRecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$SearchRecommendationModelFromJson(json);
  final String name;

  Map<String, dynamic> toJson() => _$SearchRecommendationModelToJson(this);
}
