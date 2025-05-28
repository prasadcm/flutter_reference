import 'package:categories/src/data/category_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_section.g.dart';

@JsonSerializable(explicitToJson: true)
class CategorySection {
  CategorySection({
    required this.title,
    required this.items,
    required this.sequence,
  });

  factory CategorySection.fromJson(Map<String, dynamic> json) =>
      _$CategorySectionFromJson(json);

  final String title;
  final List<CategoryItem> items;
  final int sequence;

  Map<String, dynamic> toJson() => _$CategorySectionToJson(this);
}
