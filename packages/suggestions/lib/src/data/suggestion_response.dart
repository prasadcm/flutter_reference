import 'package:json_annotation/json_annotation.dart';

part 'suggestion_response.g.dart';

@JsonSerializable(explicitToJson: true)
class SuggestionResponse {
  const SuggestionResponse({required this.id, required this.name});

  factory SuggestionResponse.fromJson(Map<String, dynamic> json) =>
      _$SuggestionResponseFromJson(json);

  final String id;
  final String name;

  Map<String, dynamic> toJson() => _$SuggestionResponseToJson(this);
}
