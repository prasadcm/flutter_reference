import 'package:json_annotation/json_annotation.dart';

part 'previously_searched_item.g.dart';

@JsonSerializable(explicitToJson: true)
class PreviouslySearchedItem {
  const PreviouslySearchedItem({
    required this.product,
    this.productIcon,
    this.productUrl,
  });

  factory PreviouslySearchedItem.fromJson(Map<String, dynamic> json) =>
      _$PreviouslySearchedItemFromJson(json);

  final String product;
  final String? productIcon;
  final String? productUrl;

  Map<String, dynamic> toJson() => _$PreviouslySearchedItemToJson(this);
}
