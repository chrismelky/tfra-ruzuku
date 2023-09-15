// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_transfer_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockTransferItem _$StockTransferItemFromJson(Map<String, dynamic> json) =>
    StockTransferItem(
      json['id'] as int,
      json['uuid'] as String,
      json['productId'] as int,
      json['productName'] as String,
      json['packagingOptionId'] as int,
      json['packagingOptionName'] as String,
      json['bags'] as int,
      (json['quantity'] as num).toDouble(),
      (json['availableQuantity'] as num).toDouble(),
      json['stockCardUuid'] as String,
    );

Map<String, dynamic> _$StockTransferItemToJson(StockTransferItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'productId': instance.productId,
      'productName': instance.productName,
      'packagingOptionId': instance.packagingOptionId,
      'packagingOptionName': instance.packagingOptionName,
      'bags': instance.bags,
      'quantity': instance.quantity,
      'availableQuantity': instance.availableQuantity,
      'stockCardUuid': instance.stockCardUuid,
    };
