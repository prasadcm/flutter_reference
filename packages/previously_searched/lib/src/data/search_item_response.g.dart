// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchItemResponse _$SearchItemResponseFromJson(Map<String, dynamic> json) =>
    SearchItemResponse(
      product: json['product'] as String,
      productIcon: json['productIcon'] as String?,
      productUrl: json['productUrl'] as String?,
      searchCount: (json['searchCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SearchItemResponseToJson(SearchItemResponse instance) =>
    <String, dynamic>{
      'product': instance.product,
      'productIcon': instance.productIcon,
      'productUrl': instance.productUrl,
      'searchCount': instance.searchCount,
    };
