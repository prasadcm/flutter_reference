// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuggestionModel _$SuggestionModelFromJson(Map<String, dynamic> json) =>
    SuggestionModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$SuggestionModelToJson(SuggestionModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
    };
