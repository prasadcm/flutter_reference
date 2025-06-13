// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchSuggestionItem _$SearchSuggestionItemFromJson(
  Map<String, dynamic> json,
) => SearchSuggestionItem(
  name: json['name'] as String,
  iconUrl: json['iconUrl'] as String?,
  type: json['type'] as String?,
  slug: json['slug'] as String?,
  productId: json['productId'] as String?,
  categoryId: json['categoryId'] as String?,
  productUrl: json['productUrl'] as String?,
);

Map<String, dynamic> _$SearchSuggestionItemToJson(
  SearchSuggestionItem instance,
) => <String, dynamic>{
  'name': instance.name,
  'iconUrl': instance.iconUrl,
  'type': instance.type,
  'slug': instance.slug,
  'productId': instance.productId,
  'categoryId': instance.categoryId,
  'productUrl': instance.productUrl,
};

SearchSuggestion _$SearchSuggestionFromJson(Map<String, dynamic> json) =>
    SearchSuggestion(
      items:
          (json['items'] as List<dynamic>)
              .map(
                (e) => SearchSuggestionItem.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$SearchSuggestionToJson(SearchSuggestion instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total': instance.total,
    };
