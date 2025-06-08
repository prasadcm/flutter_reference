// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'previously_searched_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreviouslySearchedItem _$PreviouslySearchedItemFromJson(
  Map<String, dynamic> json,
) => PreviouslySearchedItem(
  product: json['product'] as String,
  productIcon: json['productIcon'] as String?,
  productUrl: json['productUrl'] as String?,
);

Map<String, dynamic> _$PreviouslySearchedItemToJson(
  PreviouslySearchedItem instance,
) => <String, dynamic>{
  'product': instance.product,
  'productIcon': instance.productIcon,
  'productUrl': instance.productUrl,
};
