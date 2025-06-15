// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_recommendation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchRecommendationResponse _$SearchRecommendationResponseFromJson(
        Map<String, dynamic> json) =>
    SearchRecommendationResponse(
      name: json['name'] as String,
      iconUrl: json['iconUrl'] as String?,
      type: json['type'] as String?,
      slug: json['slug'] as String?,
      productId: json['productId'] as String?,
      categoryId: json['categoryId'] as String?,
      productUrl: json['productUrl'] as String?,
    );

Map<String, dynamic> _$SearchRecommendationResponseToJson(
        SearchRecommendationResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'iconUrl': instance.iconUrl,
      'type': instance.type,
      'slug': instance.slug,
      'productId': instance.productId,
      'categoryId': instance.categoryId,
      'productUrl': instance.productUrl,
    };
