// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryResponse _$CategoryResponseFromJson(Map<String, dynamic> json) =>
    CategoryResponse(
      json['category_id'] as String,
      json['name'] as String,
      (json['category_sequence'] as num).toInt(),
      json['image'] as String,
      json['item'] as String,
      json['item_id'] as String,
      (json['item_sequence'] as num).toInt(),
    );

Map<String, dynamic> _$CategoryResponseToJson(CategoryResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category_id': instance.categoryId,
      'item_id': instance.itemId,
      'item': instance.item,
      'image': instance.image,
      'category_sequence': instance.categorySequence,
      'item_sequence': instance.itemSequence,
    };
