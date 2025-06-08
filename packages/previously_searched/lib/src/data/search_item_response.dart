import 'package:json_annotation/json_annotation.dart';

part 'search_item_response.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchItemResponse {
  const SearchItemResponse({
    required this.product,
    this.productIcon,
    this.productUrl,
    this.searchCount,
  });

  factory SearchItemResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchItemResponseFromJson(json);

  final String product;
  final String? productIcon;
  final String? productUrl;
  final int? searchCount;

  Map<String, dynamic> toJson() => _$SearchItemResponseToJson(this);
}
