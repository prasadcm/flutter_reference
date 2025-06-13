import 'package:json_annotation/json_annotation.dart';

part 'previously_searched_response.g.dart';

@JsonSerializable(explicitToJson: true)
class PreviouslySearchedResponse {
  const PreviouslySearchedResponse({
    required this.searchText,
    this.iconUrl,
    this.productId,
    this.categoryId,
    this.type,
    this.slug,
  });

  factory PreviouslySearchedResponse.fromJson(Map<String, dynamic> json) =>
      _$PreviouslySearchedResponseFromJson(json);

  final String searchText;
  final String? iconUrl;
  final String? productId;
  final String? categoryId;
  final String? type;
  final String? slug;

  Map<String, dynamic> toJson() => _$PreviouslySearchedResponseToJson(this);
}
