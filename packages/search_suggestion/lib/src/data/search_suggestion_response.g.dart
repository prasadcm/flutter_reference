// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_suggestion_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchSuggestionItemResponse _$SearchSuggestionItemResponseFromJson(
  Map<String, dynamic> json,
) => SearchSuggestionItemResponse(
  name: json['name'] as String,
  iconUrl: json['iconUrl'] as String?,
  type: json['type'] as String?,
  slug: json['slug'] as String?,
  productId: json['productId'] as String?,
  categoryId: json['categoryId'] as String?,
  productUrl: json['productUrl'] as String?,
);

Map<String, dynamic> _$SearchSuggestionItemResponseToJson(
  SearchSuggestionItemResponse instance,
) => <String, dynamic>{
  'name': instance.name,
  'iconUrl': instance.iconUrl,
  'type': instance.type,
  'slug': instance.slug,
  'productId': instance.productId,
  'categoryId': instance.categoryId,
  'productUrl': instance.productUrl,
};

SearchSuggestionResponse _$SearchSuggestionResponseFromJson(
  Map<String, dynamic> json,
) => SearchSuggestionResponse(
  total: (json['total'] as num).toInt(),
  results:
      (json['results'] as List<dynamic>)
          .map(
            (e) => SearchSuggestionItemResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
);

Map<String, dynamic> _$SearchSuggestionResponseToJson(
  SearchSuggestionResponse instance,
) => <String, dynamic>{
  'total': instance.total,
  'results': instance.results.map((e) => e.toJson()).toList(),
};
