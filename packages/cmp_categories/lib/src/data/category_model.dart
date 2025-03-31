import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final String name;
  final String category_id;
  final String item_id;
  final String item;
  final String image;
  final int category_sequence;
  final int item_sequence;

  CategoryModel(
    this.category_id,
    this.name,
    this.category_sequence,
    this.image,
    this.item,
    this.item_id,
    this.item_sequence,
  );

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
