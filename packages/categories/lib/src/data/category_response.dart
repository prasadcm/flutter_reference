import 'package:json_annotation/json_annotation.dart';

part 'category_response.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryResponse {
  CategoryResponse(
    this.categoryId,
    this.name,
    this.categorySequence,
    this.image,
    this.item,
    this.itemId,
    this.itemSequence,
  );
  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);
  final String name;
  @JsonKey(name: 'category_id')
  final String categoryId;
  @JsonKey(name: 'item_id')
  final String itemId;
  final String item;
  final String image;
  @JsonKey(name: 'category_sequence')
  final int categorySequence;
  @JsonKey(name: 'item_sequence')
  final int itemSequence;

  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);
}
