import 'package:json_annotation/json_annotation.dart';

part 'category_item.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryItem {
  CategoryItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.sequence,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) =>
      _$CategoryItemFromJson(json);

  final String id;
  final String name;
  final String imageUrl;
  final int sequence;

  Map<String, dynamic> toJson() => _$CategoryItemToJson(this);
}
