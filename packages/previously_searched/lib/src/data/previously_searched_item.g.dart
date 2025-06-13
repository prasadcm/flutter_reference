// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'previously_searched_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreviouslySearchedItem _$PreviouslySearchedItemFromJson(
  Map<String, dynamic> json,
) => PreviouslySearchedItem(
  searchText: json['searchText'] as String,
  iconUrl: json['iconUrl'] as String?,
  productId: json['productId'] as String?,
  categoryId: json['categoryId'] as String?,
  type: json['type'] as String?,
  slug: json['slug'] as String?,
);

Map<String, dynamic> _$PreviouslySearchedItemToJson(
  PreviouslySearchedItem instance,
) => <String, dynamic>{
  'searchText': instance.searchText,
  'iconUrl': instance.iconUrl,
  'productId': instance.productId,
  'categoryId': instance.categoryId,
  'type': instance.type,
  'slug': instance.slug,
};
