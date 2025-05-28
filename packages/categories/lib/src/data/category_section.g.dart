// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategorySection _$CategorySectionFromJson(Map<String, dynamic> json) =>
    CategorySection(
      title: json['title'] as String,
      items:
          (json['items'] as List<dynamic>)
              .map((e) => CategoryItem.fromJson(e as Map<String, dynamic>))
              .toList(),
      sequence: (json['sequence'] as num).toInt(),
    );

Map<String, dynamic> _$CategorySectionToJson(CategorySection instance) =>
    <String, dynamic>{
      'title': instance.title,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'sequence': instance.sequence,
    };
