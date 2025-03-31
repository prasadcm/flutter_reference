// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      json['category_id'] as String,
      json['name'] as String,
      (json['category_sequence'] as num).toInt(),
      json['image'] as String,
      json['item'] as String,
      json['item_id'] as String,
      (json['item_sequence'] as num).toInt(),
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category_id': instance.category_id,
      'item_id': instance.item_id,
      'item': instance.item,
      'image': instance.image,
      'category_sequence': instance.category_sequence,
      'item_sequence': instance.item_sequence,
    };
