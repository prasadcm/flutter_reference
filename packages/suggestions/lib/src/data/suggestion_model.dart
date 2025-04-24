import 'package:json_annotation/json_annotation.dart';

part 'suggestion_model.g.dart';

@JsonSerializable()
class SuggestionModel {
  SuggestionModel(this.id, this.name);

  factory SuggestionModel.fromJson(Map<String, dynamic> json) =>
      _$SuggestionModelFromJson(json);
  final String name;
  final String id;

  Map<String, dynamic> toJson() => _$SuggestionModelToJson(this);
}
