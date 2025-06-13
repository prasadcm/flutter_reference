import 'package:json_annotation/json_annotation.dart';

part 'previously_searched_item.g.dart';

@JsonSerializable(explicitToJson: true)
class PreviouslySearchedItem {
  const PreviouslySearchedItem({
    required this.searchText,
    this.iconUrl,
    this.productId,
    this.categoryId,
    this.type,
    this.slug,
  });

  factory PreviouslySearchedItem.fromJson(Map<String, dynamic> json) =>
      _$PreviouslySearchedItemFromJson(json);

  final String searchText;
  final String? iconUrl;
  final String? productId;
  final String? categoryId;
  final String? type;
  final String? slug;

  Map<String, dynamic> toJson() => _$PreviouslySearchedItemToJson(this);
}
